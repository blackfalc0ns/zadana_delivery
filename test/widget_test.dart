import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zadana_delivery/core/di/di.dart';
import 'package:zadana_delivery/features/auth/presentation/screens/driver_profile_completion_screen.dart';
import 'package:zadana_delivery/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App boots into the new auth flow', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await getIt.reset();
    await configureDependencies();

    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle();

    expect(find.byType(DriverProfileCompletionScreen), findsOneWidget);
  });
}
