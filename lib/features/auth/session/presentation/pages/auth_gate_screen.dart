import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zadana_delivery/config/routing/routing_extensions.dart';
import 'package:zadana_delivery/config/theme/colors.dart';
import 'package:zadana_delivery/config/theme/font_manger.dart';
import 'package:zadana_delivery/config/theme/styles_manger.dart';
import 'package:zadana_delivery/core/constants/assets.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/core/extensions/extensions.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_cubit.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_event.dart';
import 'package:zadana_delivery/features/auth/session/presentation/manager/auth_gate_state.dart';

class AuthGateScreen extends StatefulWidget {
  const AuthGateScreen({super.key});

  @override
  State<AuthGateScreen> createState() => _AuthGateScreenState();
}

class _AuthGateScreenState extends State<AuthGateScreen> {
  late final AuthGateCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<AuthGateCubit>();
    _cubit.doIntent(const AuthGateStartedEvent());
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.localization;
    final color = context.colorScheme;

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<AuthGateCubit, AuthGateState>(
        listener: (context, state) {
          final route = state.targetRoute;
          if (route == null) return;
          context.pushReplacementNamed(route);
        },
        child: Scaffold(
          backgroundColor: color.surface,
          body: Center(
            child: Container(
              width: 240,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.surfaceContainerLow,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: color.shadow.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: color.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Image.asset(
                          Assets.logoDark,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    locale.auth_gate_ready_title,
                    style: getBoldStyle(
                      fontFamily: FontConstant.cairo,
                      fontSize: FontSize.size20,
                      color: color.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    locale.auth_gate_ready_description,
                    textAlign: TextAlign.center,
                    style: getRegularStyle(
                      fontFamily: FontConstant.cairo,
                      color: color.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const CircularProgressIndicator(strokeWidth: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
