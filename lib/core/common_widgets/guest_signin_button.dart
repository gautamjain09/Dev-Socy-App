import 'package:devsocy/core/theme/pallete.dart';
import 'package:devsocy/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuestLoginButton extends ConsumerWidget {
  const GuestLoginButton({super.key});

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton.icon(
        onPressed: () {
          signInAsGuest(ref, context);
        },
        icon: Icon(
          Icons.person_pin,
          size: 28,
        ),
        label: const Text(
          "SignIn as Guest",
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
