import 'package:chronic_care_app/modules/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      final role = await ref
                          .read(authProvider.notifier)
                          .login(
                            email: emailController.text,

                            password: passwordController.text,
                          );

                      if (role != null) {
                        print("ROLE:");
                        print(role);

                        if (!context.mounted) return;

                        final normalizedRole = role.toUpperCase();

                        if (normalizedRole == "PATIENT") {
                          context.go("/patient-dashboard");
                        } else if (normalizedRole == "DOCTOR") {
                          context.go("/doctor-dashboard");
                        } else if (normalizedRole == "CAREGIVER") {
                          context.go("/caregiver-dashboard");
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Login Failed")),
                        );
                      }
                    },

              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Login"),
            ),
            TextButton(
              onPressed: () {
                context.push("/register");
              },

              child: const Text("Create Account"),
            ),
          ],
        ),
      ),
    );
  }
}
