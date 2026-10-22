import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});
  @override
  Widget build(BuildContext context) => AuthPage(
    child: Column(
      children: [
        const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Color(0xFFFFC400),
              size: 17,
            ),
          ),
        ),
        const SizedBox(height: 36),
        Image.asset(
          'assets/images/Forgot password-bro 1.png',
          width: 185,
          height: 185,
        ),
        const SizedBox(height: 45),
        const AuthTextField(
          hint: 'Email',
          icon: Icons.mail_rounded,
          iconAsset: 'assets/icons/Vector (3).png',
        ),
        const SizedBox(height: 12),
        AuthButton(label: 'Verify Email', onTap: () {}),
      ],
    ),
  );
}
