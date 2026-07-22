import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:zadana_delivery/core/network/api_results.dart';
import 'package:zadana_delivery/core/services/driver_realtime_service.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_method_upsert_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_payout_preference_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_create_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_summary_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transaction_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_transactions_page_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawal_request_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/entities/driver_wallet_withdrawals_page_entity.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/create_driver_wallet_payment_method_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/create_driver_wallet_withdrawal_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/cancel_driver_wallet_withdrawal_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/delete_driver_wallet_payment_method_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/get_driver_wallet_payment_methods_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/get_driver_wallet_summary_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/get_driver_wallet_transactions_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/get_driver_wallet_withdrawals_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/make_driver_wallet_payment_method_primary_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/usecase/update_driver_wallet_payment_method_usecase.dart';
import 'package:zadana_delivery/features/wallet/domain/repo/wallet_repository.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_event.dart';
import 'package:zadana_delivery/features/wallet/presentation/manager/wallet_state.dart';

enum WalletWithdrawalBlockReason {
  none,
  noPrimaryMethod,
  codBlocked,
  noBalance,
}

enum WalletHeroState { ready, addPrimaryMethod, codBlocked, noWithdrawable }

enum WalletAlertState { none, codBlocked, pendingPayout, verificationRequired }

enum WalletPaymentMethodsState {
  empty,
  verificationRequired,
  hasPrimaryMethod,
  completed,
}

@injectable
class WalletViewModel extends Cubit<WalletState> {
  WalletViewModel(
    this._getDriverWalletSummaryUseCase,
    this._getDriverWalletTransactionsUseCase,
    this._getDriverWalletPaymentMethodsUseCase,
    this._createDriverWalletPaymentMethodUseCase,
    this._updateDriverWalletPaymentMethodUseCase,
    this._deleteDriverWalletPaymentMethodUseCase,
    this._makeDriverWalletPaymentMethodPrimaryUseCase,
    this._createDriverWalletWithdrawalUseCase,
    this._getDriverWalletWithdrawalsUseCase,
    this._cancelDriverWalletWithdrawalUseCase,
    this._walletRepository,
    DriverRealtimeService driverRealtimeService,
  ) : super(const WalletState()) {
    _walletUpdatedSubscription = driverRealtimeService.driverWalletUpdated
        .listen((_) {
          unawaited(_refreshWalletCollections(forceRefresh: true));
        });
    _walletNotificationSubscription = driverRealtimeService.notifications
        .listen((payload) {
          final screen =
              payload['screen']?.toString().trim().toLowerCase() ?? '';
          final event = payload['event']?.toString().trim().toLowerCase() ?? '';
          final eventName =
              payload['eventName']?.toString().trim().toLowerCase() ?? '';
          final popupType =
              payload['popupType']?.toString().trim().toLowerCase() ?? '';
          if (screen == 'wallet' ||
              event.startsWith('wallet.') ||
              eventName.startsWith('wallet.') ||
              popupType == 'driver_wallet_updated') {
            unawaited(_refreshWalletCollections(forceRefresh: true));
          }
        });
  }

  final GetDriverWalletSummaryUseCase _getDriverWalletSummaryUseCase;
  final GetDriverWalletTransactionsUseCase _getDriverWalletTransactionsUseCase;
  final GetDriverWalletPaymentMethodsUseCase
  _getDriverWalletPaymentMethodsUseCase;
  final CreateDriverWalletPaymentMethodUseCase
  _createDriverWalletPaymentMethodUseCase;
  final UpdateDriverWalletPaymentMethodUseCase
  _updateDriverWalletPaymentMethodUseCase;
  final DeleteDriverWalletPaymentMethodUseCase
  _deleteDriverWalletPaymentMethodUseCase;
  final MakeDriverWalletPaymentMethodPrimaryUseCase
  _makeDriverWalletPaymentMethodPrimaryUseCase;
  final CreateDriverWalletWithdrawalUseCase
  _createDriverWalletWithdrawalUseCase;
  final GetDriverWalletWithdrawalsUseCase _getDriverWalletWithdrawalsUseCase;
  final CancelDriverWalletWithdrawalUseCase
  _cancelDriverWalletWithdrawalUseCase;
  final WalletRepository _walletRepository;
  DriverPayoutPreferenceEntity? _payoutPreference;
  DriverPayoutPreferenceEntity? get payoutPreference => _payoutPreference;
  late final StreamSubscription<Map<String, dynamic>>
  _walletUpdatedSubscription;
  late final StreamSubscription<Map<String, dynamic>>
  _walletNotificationSubscription;

  DriverWalletSummaryEntity? get summary => state.summary;

  List<DriverPayoutMethodEntity> get paymentMethods =>
      state.paymentMethods.isNotEmpty
      ? state.paymentMethods
      : state.summary?.paymentMethods ?? const <DriverPayoutMethodEntity>[];

  DriverPayoutMethodEntity? get primaryPaymentMethod {
    for (final method in paymentMethods) {
      if (method.isPrimary && method.isVerified) return method;
    }
    return null;
  }

  bool get hasPrimaryPaymentMethod => primaryPaymentMethod != null;

  double get netWithdrawable =>
      summary?.netWithdrawable ?? summary?.availableToWithdraw ?? 0;

  double get codOwedBalance => summary?.codOwedBalance ?? 0;

  bool get hasOutstandingCodDebt => codOwedBalance > 0;

  bool get canRequestWithdrawal =>
      netWithdrawable > 0 && !hasOutstandingCodDebt && hasPrimaryPaymentMethod;

  double get withdrawableAmount =>
      summary?.netWithdrawable ?? summary?.availableToWithdraw ?? 0;

  bool get isWalletEmpty => summary?.isEmpty ?? false;

  bool get hasAlerts =>
      (summary?.pendingBalance ?? 0) > 0 ||
      (summary?.codOwedBalance ?? 0) > 0 ||
      paymentMethods.any((item) => !item.isVerified);

  List<DriverWalletTransactionEntity> get recentTransactionsPreview =>
      summary?.recentTransactions.take(3).toList(growable: false) ??
      const <DriverWalletTransactionEntity>[];

  WalletWithdrawalBlockReason get withdrawalBlockReason {
    if (!hasPrimaryPaymentMethod) {
      return WalletWithdrawalBlockReason.noPrimaryMethod;
    }
    if (hasOutstandingCodDebt) {
      return WalletWithdrawalBlockReason.codBlocked;
    }
    if (netWithdrawable <= 0) {
      return WalletWithdrawalBlockReason.noBalance;
    }
    return WalletWithdrawalBlockReason.none;
  }

  WalletHeroState get heroState {
    switch (withdrawalBlockReason) {
      case WalletWithdrawalBlockReason.none:
        return WalletHeroState.ready;
      case WalletWithdrawalBlockReason.noPrimaryMethod:
        return WalletHeroState.addPrimaryMethod;
      case WalletWithdrawalBlockReason.codBlocked:
        return WalletHeroState.codBlocked;
      case WalletWithdrawalBlockReason.noBalance:
        return WalletHeroState.noWithdrawable;
    }
  }

  WalletAlertState get alertState {
    if ((summary?.codOwedBalance ?? 0) > 0) {
      return WalletAlertState.codBlocked;
    }
    if (paymentMethods.any((item) => !item.isVerified)) {
      return WalletAlertState.verificationRequired;
    }
    if ((summary?.pendingBalance ?? 0) > 0) {
      return WalletAlertState.pendingPayout;
    }
    return WalletAlertState.none;
  }

  WalletPaymentMethodsState get paymentMethodsState {
    if (paymentMethods.isEmpty) {
      return WalletPaymentMethodsState.empty;
    }
    if (paymentMethods.any((item) => !item.isVerified)) {
      return WalletPaymentMethodsState.verificationRequired;
    }
    if (paymentMethods.any((item) => item.isPrimary)) {
      return WalletPaymentMethodsState.hasPrimaryMethod;
    }
    return WalletPaymentMethodsState.completed;
  }

  bool get showGlobalError =>
      !state.isLoading && state.failure != null && state.summary == null;

  bool get hasTransactionsMore =>
      state.transactions.length < state.transactionsTotalCount;

  bool get hasWithdrawalsMore =>
      state.withdrawals.length < state.withdrawalsTotalCount;

  void loadInitial() {
    doIntent(const WalletLoadEvent());
    unawaited(loadPayoutPreference());
  }

  Future<void> loadPayoutPreference() async {
    final result = await _walletRepository.getPayoutPreference();
    if (result case ApiSuccessResult(data: final preference)) {
      _payoutPreference = preference;
      emit(state.copyWith());
    }
  }

  Future<bool> updatePayoutPreference(String payoutDay) async {
    final result = await _walletRepository.updatePayoutPreference(payoutDay);
    if (result case ApiSuccessResult(data: final preference)) {
      _payoutPreference = preference;
      emit(state.copyWith());
      return true;
    }
    return false;
  }

  Future<void> refreshWallet() async {
    await doIntent(const WalletLoadEvent(refresh: true));
  }

  Future<dynamic> doIntent(WalletEvent event) {
    switch (event) {
      case WalletLoadEvent():
        return _refreshWallet(forceRefresh: event.refresh);
      case WalletClearErrorEvent():
        _clearError();
        return Future<void>.value();
      case WalletCreatePaymentMethodEvent():
        return _createPaymentMethod(event.request);
      case WalletUpdatePaymentMethodEvent():
        return _updatePaymentMethod(event.id, event.request);
      case WalletDeletePaymentMethodEvent():
        return _deletePaymentMethod(event.id);
      case WalletMakePaymentMethodPrimaryEvent():
        return _makePrimary(event.id);
      case WalletCreateWithdrawalEvent():
        return _createWithdrawal(event.request);
      case WalletLoadTransactionsEvent():
        return _loadTransactions(event.refresh);
      case WalletLoadMoreTransactionsEvent():
        return _loadMoreTransactions();
      case WalletLoadWithdrawalsEvent():
        return _loadWithdrawals(event.refresh);
      case WalletLoadMoreWithdrawalsEvent():
        return _loadMoreWithdrawals();
    }
  }

  Future<void> _refreshWallet({required bool forceRefresh}) async {
    final shouldShowLoading = state.summary == null;
    emit(
      state.copyWith(
        isLoading: shouldShowLoading,
        isRefreshing: forceRefresh || !shouldShowLoading,
        clearFailure: true,
      ),
    );

    final summaryResult = await _getDriverWalletSummaryUseCase.call();
    switch (summaryResult) {
      case ApiSuccessResult(data: final summary):
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            summary: summary,
            paymentMethods: summary.paymentMethods,
            clearFailure: true,
          ),
        );
        emit(state.copyWith(isRefreshing: false));
      case ApiErrorResult():
        emit(
          state.copyWith(
            isLoading: false,
            isRefreshing: false,
            failure: summaryResult.failure,
          ),
        );
    }
  }

  Future<void> _refreshWalletCollections({required bool forceRefresh}) async {
    await _refreshWallet(forceRefresh: forceRefresh);
    await Future.wait<void>([
      _loadTransactionsPage(page: 1, refresh: true),
      _loadWithdrawalsPage(page: 1, refresh: true),
    ]);
  }

  Future<bool> createPaymentMethod(
    DriverPayoutMethodUpsertRequestEntity request,
  ) {
    return _createPaymentMethod(request);
  }

  Future<bool> _createPaymentMethod(
    DriverPayoutMethodUpsertRequestEntity request,
  ) async {
    emit(state.copyWith(isSubmittingPaymentMethod: true, clearFailure: true));
    final result = await _createDriverWalletPaymentMethodUseCase.call(request);
    return _handlePaymentMethodMutationResult(result);
  }

  Future<bool> updatePaymentMethod(
    String id,
    DriverPayoutMethodUpsertRequestEntity request,
  ) {
    return _updatePaymentMethod(id, request);
  }

  Future<bool> _updatePaymentMethod(
    String id,
    DriverPayoutMethodUpsertRequestEntity request,
  ) async {
    emit(
      state.copyWith(
        isSubmittingPaymentMethod: true,
        activePaymentMethodId: id,
        clearFailure: true,
      ),
    );
    final result = await _updateDriverWalletPaymentMethodUseCase.call(
      id,
      request,
    );
    return _handlePaymentMethodMutationResult(result);
  }

  Future<bool> deletePaymentMethod(String id) {
    return _deletePaymentMethod(id);
  }

  Future<bool> _deletePaymentMethod(String id) async {
    emit(state.copyWith(activePaymentMethodId: id, clearFailure: true));
    final result = await _deleteDriverWalletPaymentMethodUseCase.call(id);
    switch (result) {
      case ApiSuccessResult():
        await _refreshSummaryAndMethods();
        emit(
          state.copyWith(clearActivePaymentMethodId: true, clearFailure: true),
        );
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            clearActivePaymentMethodId: true,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<bool> makePrimary(String id) {
    return _makePrimary(id);
  }

  Future<bool> _makePrimary(String id) async {
    emit(state.copyWith(activePaymentMethodId: id, clearFailure: true));
    final result = await _makeDriverWalletPaymentMethodPrimaryUseCase.call(id);
    return _handlePaymentMethodMutationResult(result, clearLoadingIdOnly: true);
  }

  Future<bool> createWithdrawal(
    DriverWalletCreateWithdrawalRequestEntity request,
  ) {
    return _createWithdrawal(request);
  }

  Future<bool> cancelWithdrawal(String withdrawalId) async {
    if (state.cancellingWithdrawalId != null) return false;
    emit(
      state.copyWith(cancellingWithdrawalId: withdrawalId, clearFailure: true),
    );
    final result = await _cancelDriverWalletWithdrawalUseCase.call(
      withdrawalId,
    );
    switch (result) {
      case ApiSuccessResult():
        await _refreshWalletCollections(forceRefresh: true);
        emit(state.copyWith(clearCancellingWithdrawalId: true));
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            failure: result.failure,
            clearCancellingWithdrawalId: true,
          ),
        );
        return false;
    }
  }

  Future<bool> _createWithdrawal(
    DriverWalletCreateWithdrawalRequestEntity request,
  ) async {
    emit(state.copyWith(isSubmittingWithdrawal: true, clearFailure: true));
    // The key is created once per user action and is retained by the request
    // object, so callers can retry the exact same request safely.
    final result = await _createDriverWalletWithdrawalUseCase.call(request);
    switch (result) {
      case ApiSuccessResult():
        await _refreshWalletCollections(forceRefresh: true);
        emit(state.copyWith(isSubmittingWithdrawal: false, clearFailure: true));
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSubmittingWithdrawal: false,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<void> loadTransactions({bool refresh = false}) {
    return _loadTransactions(refresh);
  }

  Future<void> _loadTransactions(bool refresh) async {
    final requestedPage = refresh ? 1 : state.transactionsPage;
    await _loadTransactionsPage(page: requestedPage, refresh: refresh);
  }

  Future<void> loadMoreTransactions() {
    return _loadMoreTransactions();
  }

  Future<void> ensureTransactionsLoaded() async {
    if (state.transactions.isNotEmpty) return;
    await loadTransactions(refresh: true);
  }

  Future<void> _loadMoreTransactions() async {
    if (!hasTransactionsMore || state.isLoadingMoreTransactions) return;
    await _loadTransactionsPage(page: state.transactionsPage, refresh: false);
  }

  Future<void> loadWithdrawals({bool refresh = false}) {
    return _loadWithdrawals(refresh);
  }

  Future<void> _loadWithdrawals(bool refresh) async {
    final requestedPage = refresh ? 1 : state.withdrawalsPage;
    await _loadWithdrawalsPage(page: requestedPage, refresh: refresh);
  }

  Future<void> loadMoreWithdrawals() {
    return _loadMoreWithdrawals();
  }

  Future<void> ensureWithdrawalsLoaded() async {
    if (state.withdrawals.isNotEmpty) return;
    await loadWithdrawals(refresh: true);
  }

  Future<void> _loadMoreWithdrawals() async {
    if (!hasWithdrawalsMore || state.isLoadingMoreWithdrawals) return;
    await _loadWithdrawalsPage(page: state.withdrawalsPage, refresh: false);
  }

  Future<void> _loadTransactionsPage({
    required int page,
    required bool refresh,
  }) async {
    if (state.isTransactionsLoading || state.isLoadingMoreTransactions) return;
    emit(
      state.copyWith(
        isTransactionsLoading: refresh || state.transactions.isEmpty,
        isLoadingMoreTransactions: !refresh && state.transactions.isNotEmpty,
        clearFailure: true,
      ),
    );

    final result = await _getDriverWalletTransactionsUseCase.call(page: page);
    switch (result) {
      case ApiSuccessResult(data: final page):
        _applyTransactionsPage(page, refresh: refresh);
      case ApiErrorResult():
        emit(
          state.copyWith(
            isTransactionsLoading: false,
            isLoadingMoreTransactions: false,
            failure: result.failure,
          ),
        );
    }
  }

  Future<void> _loadWithdrawalsPage({
    required int page,
    required bool refresh,
  }) async {
    if (state.isWithdrawalsLoading || state.isLoadingMoreWithdrawals) return;
    emit(
      state.copyWith(
        isWithdrawalsLoading: refresh || state.withdrawals.isEmpty,
        isLoadingMoreWithdrawals: !refresh && state.withdrawals.isNotEmpty,
        clearFailure: true,
      ),
    );

    final result = await _getDriverWalletWithdrawalsUseCase.call(page: page);
    switch (result) {
      case ApiSuccessResult(data: final page):
        _applyWithdrawalsPage(page, refresh: refresh);
      case ApiErrorResult():
        emit(
          state.copyWith(
            isWithdrawalsLoading: false,
            isLoadingMoreWithdrawals: false,
            failure: result.failure,
          ),
        );
    }
  }

  void clearError() {
    doIntent(const WalletClearErrorEvent());
  }

  void _clearError() {
    if (state.failure == null) return;
    emit(state.copyWith(clearFailure: true));
  }

  Future<bool> _handlePaymentMethodMutationResult(
    ApiResult<DriverPayoutMethodEntity> result, {
    bool clearLoadingIdOnly = false,
  }) async {
    switch (result) {
      case ApiSuccessResult():
        await _refreshSummaryAndMethods();
        emit(
          state.copyWith(
            isSubmittingPaymentMethod: false,
            clearActivePaymentMethodId: true,
            clearFailure: true,
          ),
        );
        return true;
      case ApiErrorResult():
        emit(
          state.copyWith(
            isSubmittingPaymentMethod: false,
            clearActivePaymentMethodId: clearLoadingIdOnly,
            failure: result.failure,
          ),
        );
        return false;
    }
  }

  Future<void> _refreshSummaryAndMethods() async {
    final summaryResult = await _getDriverWalletSummaryUseCase.call();
    if (summaryResult case ApiSuccessResult(data: final summary)) {
      emit(
        state.copyWith(
          summary: summary,
          paymentMethods: summary.paymentMethods,
        ),
      );
      return;
    }

    final methodsResult = await _getDriverWalletPaymentMethodsUseCase.call();
    if (methodsResult case ApiSuccessResult(data: final methods)) {
      emit(state.copyWith(paymentMethods: methods));
    }
  }

  void _applyTransactionsPage(
    DriverWalletTransactionsPageEntity page, {
    required bool refresh,
  }) {
    emit(
      state.copyWith(
        isTransactionsLoading: false,
        isLoadingMoreTransactions: false,
        transactions: refresh
            ? _deduplicateTransactions(page.items)
            : _deduplicateTransactions(<DriverWalletTransactionEntity>[
                ...state.transactions,
                ...page.items,
              ]),
        transactionsPage: page.page + 1,
        transactionsTotalCount: page.totalCount,
        clearFailure: true,
      ),
    );
  }

  void _applyWithdrawalsPage(
    DriverWalletWithdrawalsPageEntity page, {
    required bool refresh,
  }) {
    emit(
      state.copyWith(
        isWithdrawalsLoading: false,
        isLoadingMoreWithdrawals: false,
        withdrawals: refresh
            ? _deduplicateWithdrawals(page.items)
            : _deduplicateWithdrawals(<DriverWalletWithdrawalRequestEntity>[
                ...state.withdrawals,
                ...page.items,
              ]),
        withdrawalsPage: page.page + 1,
        withdrawalsTotalCount: page.totalCount,
        clearFailure: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _walletUpdatedSubscription.cancel();
    await _walletNotificationSubscription.cancel();
    return super.close();
  }

  List<DriverWalletTransactionEntity> _deduplicateTransactions(
    List<DriverWalletTransactionEntity> items,
  ) {
    final seenIds = <String>{};
    final uniqueItems = <DriverWalletTransactionEntity>[];
    for (final item in items) {
      if (!seenIds.add(item.id)) continue;
      uniqueItems.add(item);
    }
    return uniqueItems;
  }

  List<DriverWalletWithdrawalRequestEntity> _deduplicateWithdrawals(
    List<DriverWalletWithdrawalRequestEntity> items,
  ) {
    final seenIds = <String>{};
    final uniqueItems = <DriverWalletWithdrawalRequestEntity>[];
    for (final item in items) {
      if (!seenIds.add(item.id)) continue;
      uniqueItems.add(item);
    }
    return uniqueItems;
  }
}
