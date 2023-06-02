import 'package:devsocy/Responsive/responsive.dart';
import 'package:devsocy/core/common_widgets/guest_signin_button.dart';
import 'package:devsocy/core/common_widgets/loader.dart';
import 'package:devsocy/core/common_widgets/google_signin_button.dart';
import 'package:devsocy/core/constants.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          Constants.logoPath,
          height: 36,
        ),
      ),
      body: isLoading
          ? const Loader()
          : Responsive(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Dive into Anything",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 22,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      Constants.loginEmotePath,
                      height: 300,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const SignInButton(),
                  const Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const GuestLoginButton()
                ],
              ),
            ),
    );
  }
}
