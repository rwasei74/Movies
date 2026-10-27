import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_language.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../viewmodels/auth_view_model.dart';
import '../widgets/auth_widgets.dart';
import 'forgot_password_page.dart';
import 'register_page.dart';
import '../../../home/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  late final _model = AuthViewModel(
    FirebaseAuthRepository(FirebaseAuth.instance),
  );

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _model.close();
    super.dispose();
  }

  Future<void> _login() async {
    if (_email.text.trim().isEmpty || _password.text.isEmpty) {
      _model.validationError('Enter your email and password.');
      return;
    }
    final success = await _model.run(
      () => _model.repository.signIn(
        email: _email.text,
        password: _password.text,
      ),
    );
    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomePage()),
        (_) => false,
      );
    }
  }

  Future<void> _googleLogin() async {
    final success = await _model.run(_model.repository.signInWithGoogle);
    if (success && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(builder: (_) => const HomePage()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthViewModel, AuthState>(
    bloc: _model,
    builder: (context, state) => AuthPage(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AuthLogo(size: 88),
          const SizedBox(height: 42),
          AuthTextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            hint: AppLanguage.text(
              context,
              en: 'Email',
              ar: 'البريد الإلكتروني',
            ),
            icon: Icons.mail_rounded,
            iconAsset: 'assets/icons/Vector (3).png',
          ),
          const SizedBox(height: 10),
          AuthTextField(
            controller: _password,
            hint: AppLanguage.text(context, en: 'Password', ar: 'كلمة المرور'),
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
              child: Text(
                AppLanguage.text(
                  context,
                  en: 'Forgot password?',
                  ar: 'نسيت كلمة المرور؟',
                ),
                style: const TextStyle(color: Color(0xFFFFC400), fontSize: 10),
              ),
            ),
          ),
          AuthButton(
            label: state.loading
                ? AppLanguage.text(
                    context,
                    en: 'Please wait...',
                    ar: 'يرجى الانتظار...',
                  )
                : AppLanguage.text(context, en: 'Login', ar: 'تسجيل الدخول'),
            onTap: state.loading ? null : _login,
          ),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: Divider(color: Color(0xFFFFC400))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  AppLanguage.text(context, en: 'OR', ar: 'أو'),
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              Expanded(child: Divider(color: Color(0xFFFFC400))),
            ],
          ),
          const SizedBox(height: 16),
          GoogleButton(onTap: state.loading ? null : _googleLogin),
          const SizedBox(height: 20),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                AppLanguage.text(
                  context,
                  en: "Don't have an account? ",
                  ar: 'ما عندكش حساب؟ ',
                ),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const RegisterPage()),
                ),
                child: Text(
                  AppLanguage.text(context, en: 'Create one', ar: 'إنشاء حساب'),
                  style: const TextStyle(
                    color: Color(0xFFFFC400),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),
          const LanguageSwitcher(),
        ],
      ),
    ),
  );
}
