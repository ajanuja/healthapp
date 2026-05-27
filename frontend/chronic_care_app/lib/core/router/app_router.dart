import 'package:chronic_care_app/modules/auth/screens/caregiver_dashboard_screen.dart';
import 'package:chronic_care_app/modules/auth/screens/doctor_dashboard_screen.dart';
import 'package:chronic_care_app/modules/auth/screens/patient_dashboard_screen.dart';
import 'package:go_router/go_router.dart';

import '../../modules/auth/screens/login_screen.dart';
import '../../modules/auth/screens/register_screen.dart';

final appRouter = GoRouter(
  initialLocation: "/login",

  routes: [
    GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),

    GoRoute(
      path: "/register",

      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(
      path: "/patient-dashboard",

      builder: (context, state) => const PatientDashboardScreen(),
    ),

    GoRoute(
      path: "/doctor-dashboard",

      builder: (context, state) => const DoctorDashboardScreen(),
    ),

    GoRoute(
      path: "/caregiver-dashboard",

      builder: (context, state) => const CaregiverDashboardScreen(),
    ),
  ],
);
