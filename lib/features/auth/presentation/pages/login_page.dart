import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) => AuthPage(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AuthLogo(size: 88),
        const SizedBox(height: 42),
        const AuthTextField(
          hint: 'Email',
          icon: Icons.mail_rounded,
          iconAsset: 'assets/icons/Vector (3).png',
        ),
        const SizedBox(height: 10),
        const AuthTextField(
          hint: 'Password',
          icon: Icons.lock_rounded,
          iconAsset: 'assets/icons/Vector (1).png',
          obscure: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const ForgotPasswordPage(),
              ),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.only(top: 3, bottom: 8),
              minimumSize: Size.zero,
            ),
            child: const Text(
              'Forget Password ?',
              style: TextStyle(color: Color(0xFFFFC400), fontSize: 8),
            ),
          ),
        ),
        AuthButton(label: 'Login', onTap: () {}),
        const SizedBox(height: 20),
        Row(
          children: const [
            Expanded(child: Divider(color: Color(0xFFFFC400))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'OR',
                style: TextStyle(color: Colors.white, fontSize: 9),
              ),
            ),
            Expanded(child: Divider(color: Color(0xFFFFC400))),
          ],
        ),
        const SizedBox(height: 16),
        GoogleButton(onTap: () {}),
        const SizedBox(height: 20),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              "Don't Have Account ? ",
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const RegisterPage()),
              ),
              child: const Text(
                'Create One',
                style: TextStyle(color: Color(0xFFFFC400), fontSize: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 36),
        const _LanguageSwitcher(),
      ],
    ),
  );
}

class _LanguageSwitcher extends StatelessWidget {
  const _LanguageSwitcher();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFFFFC400)),
      borderRadius: BorderRadius.circular(11),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/icons/LR.png', width: 14),
        const SizedBox(width: 5),
        const Text('🇱🇾', style: TextStyle(fontSize: 13)),
      ],
    ),
  );
}
