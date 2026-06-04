import 'package:chronic_care_app/modules/medicines/screens/add_medicine_screen.dart';
import 'package:chronic_care_app/modules/dashboard/screens/caregiver_dashboard_screen.dart';
import 'package:chronic_care_app/modules/dashboard/screens/doctor_dashboard_screen.dart';
import 'package:chronic_care_app/modules/medicines/screens/medicine_screen.dart';
import 'package:chronic_care_app/modules/dashboard/screens/patient_dashboard_screen.dart';
import 'package:chronic_care_app/modules/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

import '../../modules/auth/screens/login_screen.dart';
import '../../modules/auth/screens/register_screen.dart';

final appRouter = GoRouter(
  initialLocation: "/",

  routes: [
    GoRoute(path: "/", builder: (context, state) => const SplashScreen()),
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

    GoRoute(
      path: "/medicines",
      builder: (context, state) => const MedicineScreen(),
    ),

    GoRoute(
      path: "/add-medicine",

      builder: (context, state) => const AddMedicineScreen(),
    ),
  ],
);
