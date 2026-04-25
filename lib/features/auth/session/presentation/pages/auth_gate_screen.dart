import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
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
    final color = context.colorScheme;
    final locale = context.localization;

    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<AuthGateCubit, AuthGateState>(
        listener: (context, state) {
          final route = state.targetRoute;
          if (route == null) return;
          context.pushReplacementNamed(route);
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FBFD),
          body: Stack(
            children: [
              const Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFF8FBFD), Color(0xFFEEF8FA)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -70,
                left: -30,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Positioned(
                bottom: -60,
                right: -20,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondary.withValues(alpha: 0.08),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Spacer(),
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 460,
                              maxHeight: 460,
                            ),
                            child: Lottie.asset(
                              Assets.splash,
                              fit: BoxFit.contain,
                              repeat: true,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: color.surface.withValues(alpha: 0.88),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.10),
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              Assets.logoDark,
                              height: 62,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              locale.auth_gate_ready_description,
                              textAlign: TextAlign.center,
                              style: getRegularStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: FontSize.size13,
                                color: color.onSurfaceVariant,
                              ).copyWith(height: 1.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
