import 'package:chronic_care_app/modules/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final fullNameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final ageController = TextEditingController();

  String selectedRole = "PATIENT";

  String? selectedGender;

  @override
  Widget build(BuildContext context) {
    final loading = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),

            const SizedBox(height: 16),

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

            const SizedBox(height: 16),

            DropdownButtonFormField(
              value: selectedRole,

              items: const [
                DropdownMenuItem(value: "PATIENT", child: Text("Patient")),

                DropdownMenuItem(value: "DOCTOR", child: Text("Doctor")),

                DropdownMenuItem(value: "CAREGIVER", child: Text("Caregiver")),
              ],

              onChanged: (value) {
                setState(() {
                  selectedRole = value!;
                });
              },

              decoration: const InputDecoration(labelText: "Role"),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField(
              value: selectedGender,

              items: const [
                DropdownMenuItem(value: "MALE", child: Text("Male")),

                DropdownMenuItem(value: "FEMALE", child: Text("Female")),
              ],

              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                });
              },

              decoration: const InputDecoration(labelText: "Gender"),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Age"),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: loading
                  ? null
                  : () async {
                      final success = await ref
                          .read(authProvider.notifier)
                          .register(
                            fullName: fullNameController.text,

                            email: emailController.text,

                            password: passwordController.text,

                            role: selectedRole,

                            gender: selectedGender,

                            age: ageController.text.isEmpty
                                ? null
                                : int.parse(ageController.text),
                          );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Registration Success")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Registration Failed")),
                        );
                      }
                    },

              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Register"),
            ),

            TextButton(
              onPressed: () {
                context.pop();
              },

              child: const Text("Already have account? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
