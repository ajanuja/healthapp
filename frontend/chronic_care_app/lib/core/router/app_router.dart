import 'package:chronic_care_app/modules/appointment/screens/schedule_appointment_screen.dart';
import 'package:chronic_care_app/modules/doctor/screens/add_patient_screen.dart';
import 'package:chronic_care_app/modules/doctor/screens/doctor_patients_screen.dart';
import 'package:chronic_care_app/modules/doctor/screens/patient_report_screen.dart';
import 'package:chronic_care_app/modules/doctor/screens/prescribe_medicine_screen.dart';
import 'package:chronic_care_app/modules/medicines/screens/add_medicine_screen.dart';
import 'package:chronic_care_app/modules/dashboard/screens/caregiver_dashboard_screen.dart';
import 'package:chronic_care_app/modules/dashboard/screens/doctor_dashboard_screen.dart';
import 'package:chronic_care_app/modules/medicines/screens/medicine_history_screen.dart';
import 'package:chronic_care_app/modules/medicines/screens/medicine_screen.dart';
import 'package:chronic_care_app/modules/dashboard/screens/patient_dashboard_screen.dart';
import 'package:chronic_care_app/modules/notifications/screens/notifications_screen.dart';
import 'package:chronic_care_app/modules/splash/splash_screen.dart';
import 'package:chronic_care_app/modules/vitals/screens/add_vital_screen.dart';
import 'package:chronic_care_app/modules/vitals/screens/vital_trends_screen.dart';
import 'package:chronic_care_app/modules/vitals/screens/vitals_screen.dart';
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

    GoRoute(
      path: "/medicine-history",
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return MedicineHistoryScreen(
          medicineId: data["medicineId"],
          medicineName: data["medicineName"],
        );
      },
    ),

    GoRoute(path: "/vitals", builder: (context, state) => const VitalsScreen()),

    GoRoute(
      path: "/add-vital",
      builder: (context, state) => const AddVitalScreen(),
    ),

    GoRoute(
      path: "/vital-trends",
      builder: (context, state) => const VitalTrendsScreen(),
    ),

    GoRoute(
      path: "/notifications",
      builder: (context, state) => const NotificationsScreen(),
    ),

    GoRoute(
      path: "/doctor-patients",
      builder: (context, state) => const DoctorPatientsScreen(),
    ),

    GoRoute(
      path: "/patient-report",
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return PatientReportScreen(
          patientId: data["patientId"],
          patientName: data["patientName"],
        );
      },
    ),

    GoRoute(
      path: "/add-patient",
      builder: (context, state) => const AddPatientScreen(),
    ),

    GoRoute(
      path: "/prescribe-medicine",
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return PrescribeMedicineScreen(
          patientId: data["patientId"],
          patientName: data["patientName"],
        );
      },
    ),

    GoRoute(
      path: "/schedule-appointment",

      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>;

        return ScheduleAppointmentScreen(
          patientId: data["patientId"],
          patientName: data["patientName"],
        );
      },
    ),
  ],
);
