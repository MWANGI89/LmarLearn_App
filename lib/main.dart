import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Screens
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/home/home_screen.dart';

// Dashboards
import 'dashboards/superadmin_dashboard.dart';
import 'dashboards/unified_dashboard.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lmar Learn',
      initialRoute: '/home',
      routes: {
        '/home': (_) => const HomeScreen(),
        '/login': (_) => const LoginScreen(),
        '/sign-up': (_) => const RegisterScreen(), // Updated route name

        // Unified dashboards for admin, student, lecturer
        '/admin-dashboard': (context) => _buildDashboard(context),
        '/student-dashboard': (context) => _buildDashboard(context),
        '/lecturer-dashboard': (context) => _buildDashboard(context),

        // Superadmin dashboard
        '/superadmin-dashboard': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          final user = (args is Map && args['loggedUser'] != null)
              ? args['loggedUser'] as dynamic
              : null;

          if (user != null) {
            return SuperAdminDashboard(superAdminUser: user);
          }
          return const HomeScreen();
        },
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
    );
  }

  // Helper function for admin/student/lecturer dashboards
  static Widget _buildDashboard(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final user = (args is Map && args['loggedUser'] != null)
        ? args['loggedUser'] as dynamic
        : null;

    if (user != null) {
      return UnifiedDashboard(loggedUser: user);
    }
    return const HomeScreen();
  }
}
