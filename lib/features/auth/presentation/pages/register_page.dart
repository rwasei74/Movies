import 'package:flutter/material.dart';
import '../widgets/auth_widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});
  @override
  Widget build(BuildContext context) => AuthPage(
    child: Column(
      children: [
        const SizedBox(height: 9),
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
        const SizedBox(height: 4),
        const _Avatars(),
        const SizedBox(height: 2),
        const Text(
          'Avatar',
          style: TextStyle(color: Colors.white, fontSize: 8),
        ),
        const SizedBox(height: 20),
        const AuthTextField(hint: 'Name', icon: Icons.badge_outlined),
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
        const AuthTextField(
          hint: 'Confirm Password',
          icon: Icons.lock_rounded,
          iconAsset: 'assets/icons/Vector (1).png',
          obscure: true,
        ),
        const SizedBox(height: 10),
        const AuthTextField(
          hint: 'Phone Number',
          icon: Icons.phone_rounded,
          iconAsset: 'assets/icons/Vector (4).png',
        ),
        const SizedBox(height: 12),
        AuthButton(label: 'Create Account', onTap: () {}),
        const SizedBox(height: 16),
        const Text(
          'Already Have Account ? Login',
          style: TextStyle(color: Colors.white, fontSize: 8),
        ),
        const SizedBox(height: 13),
        const _RegisterLanguages(),
      ],
    ),
  );
}

class _Avatars extends StatelessWidget {
  const _Avatars();
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: Color(0xFF4EC0CF),
        child: Text('👨🏻‍🎨', style: TextStyle(fontSize: 22)),
      ),
      SizedBox(width: 5),
      CircleAvatar(
        radius: 31,
        backgroundColor: Color(0xFFEF5E4D),
        child: Text('🧑🏻', style: TextStyle(fontSize: 34)),
      ),
      SizedBox(width: 5),
      CircleAvatar(
        radius: 20,
        backgroundColor: Color(0xFFC45B39),
        child: Text('👨🏽‍🚒', style: TextStyle(fontSize: 21)),
      ),
    ],
  );
}

class _RegisterLanguages extends StatelessWidget {
  const _RegisterLanguages();
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/icons/LR.png', width: 15),
      const SizedBox(width: 5),
      const Text('🇱🇾', style: TextStyle(fontSize: 14)),
    ],
  );
}
