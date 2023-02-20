import 'package:devsocy/core/common_widgets/sign_in_button.dart';
import 'package:devsocy/core/constants/constants.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(Constants.logoPath, height: 36),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              "Skip",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
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
            height: 20,
          ),
          SignInButton(),
        ],
      ),
    );
  }
}
