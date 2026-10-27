import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../viewmodels/auth_view_model.dart';
import '../widgets/auth_widgets.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();
  late final _model = AuthViewModel(
    FirebaseAuthRepository(FirebaseAuth.instance),
  );
  @override
  void dispose() {
    _email.dispose();
    _model.close();
    super.dispose();
  }

  Future<void> _reset() async {
    if (_email.text.trim().isEmpty) {
      _model.validationError('Enter your email address.');
      return;
    }
    final success = await _model.run(
      () => _model.repository.sendPasswordReset(_email.text),
    );
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'If an account exists, a password reset email will be sent.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthViewModel, AuthState>(
    bloc: _model,
    builder: (context, state) => AuthPage(
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
          AuthTextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            hint: 'Email',
            icon: Icons.mail_rounded,
            iconAsset: 'assets/icons/Vector (3).png',
          ),
          const SizedBox(height: 12),
          AuthButton(
            label: state.loading ? 'Please wait...' : 'Verify Email',
            onTap: state.loading ? null : _reset,
          ),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
        ],
      ),
    ),
  );
}
