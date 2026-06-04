import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import '../../core/storage/token_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    checkLogin();
  }

  Future<void> checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    final token = await TokenStorage.getToken();

    final role = await TokenStorage.getRole();

    if (!mounted) return;

    // NOT LOGGED IN
    if (token == null || role == null) {
      context.go("/login");

      return;
    }

    // PATIENT
    if (role == "PATIENT") {
      context.go("/patient-dashboard");
    }
    // DOCTOR
    else if (role == "DOCTOR") {
      context.go("/doctor-dashboard");
    }
    // CAREGIVER
    else if (role == "CAREGIVER") {
      context.go("/caregiver-dashboard");
    } else {
      context.go("/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
