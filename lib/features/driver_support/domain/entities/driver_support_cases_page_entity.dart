import 'package:zadana_delivery/features/driver_support/domain/entities/driver_support_case_entity.dart';

class DriverSupportCasesPageEntity {
  const DriverSupportCasesPageEntity({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.hasMore,
  });

  final List<DriverSupportCaseEntity> items;
  final int page;
  final int pageSize;
  final int total;
  final bool hasMore;
}
