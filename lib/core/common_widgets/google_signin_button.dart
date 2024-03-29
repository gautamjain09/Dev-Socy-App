import 'package:devsocy/core/constants.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:devsocy/core/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLogin;
  const SignInButton({super.key, this.isFromLogin = true});

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref
        .watch(authControllerProvider.notifier)
        .signInWithGoogle(context, isFromLogin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton.icon(
        onPressed: () {
          signInWithGoogle(context, ref);
        },
        icon: Image.asset(
          Constants.googlePath,
          width: 40,
        ),
        label: const Text(
          "Continue with Google",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(
            double.infinity,
            50,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36),
          ),
        ),
      ),
    );
  }
}
