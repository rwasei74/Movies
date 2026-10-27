import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../viewmodels/auth_view_model.dart';
import '../widgets/auth_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  late final _model = AuthViewModel(
    FirebaseAuthRepository(FirebaseAuth.instance),
  );

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _model.close();
    super.dispose();
  }

  Future<void> _register() async {
    if (_name.text.trim().isEmpty ||
        _email.text.trim().isEmpty ||
        _password.text.isEmpty) {
      _model.validationError('Please fill in all fields.');
      return;
    }
    if (_password.text != _confirm.text) {
      _model.validationError('Passwords do not match.');
      return;
    }
    final success = await _model.run(
      () => _model.repository.register(
        name: _name.text,
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

  @override
  Widget build(BuildContext context) => BlocBuilder<AuthViewModel, AuthState>(
    bloc: _model,
    builder: (context, state) => AuthPage(
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
          AuthTextField(
            hint: 'Name',
            icon: Icons.badge_outlined,
            controller: _name,
          ),
          const SizedBox(height: 10),
          AuthTextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            hint: 'Email',
            icon: Icons.mail_rounded,
            iconAsset: 'assets/icons/Vector (3).png',
          ),
          const SizedBox(height: 10),
          AuthTextField(
            controller: _password,
            hint: 'Password',
            icon: Icons.lock_rounded,
            iconAsset: 'assets/icons/Vector (1).png',
            obscure: true,
          ),
          const SizedBox(height: 10),
          AuthTextField(
            controller: _confirm,
            hint: 'Confirm Password',
            icon: Icons.lock_rounded,
            iconAsset: 'assets/icons/Vector (1).png',
            obscure: true,
          ),
          const SizedBox(height: 12),
          AuthButton(
            label: state.loading ? 'Please wait...' : 'Create Account',
            onTap: state.loading ? null : _register,
          ),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                state.error!,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              'Already Have Account ? Login',
              style: TextStyle(color: Colors.white, fontSize: 8),
            ),
          ),
          const SizedBox(height: 13),
          const _RegisterLanguages(),
        ],
      ),
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
