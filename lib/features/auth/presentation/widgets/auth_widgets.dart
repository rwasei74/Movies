import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _yellow = Color(0xFFFFC400);
const _fieldColor = Color(0xFF262928);

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key, this.size = 70});
  final double size;

  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/icons/325f2e24bac68df23f7c61f7b92e3b9a0a265676.png',
    width: size,
    height: size,
  );
}

class AuthTextField extends StatefulWidget {
  const AuthTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.iconAsset,
    this.obscure = false,
    this.controller,
    this.keyboardType,
  });
  final String hint;
  final IconData icon;
  final String? iconAsset;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _hide = true;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 40,
    child: TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      autocorrect: !widget.obscure,
      obscureText: widget.obscure && _hide,
      style: const TextStyle(color: Colors.white, fontSize: 11),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(color: Color(0xFFD0D0D0), fontSize: 10),
        prefixIcon: widget.iconAsset == null
            ? Icon(widget.icon, color: Colors.white, size: 17)
            : Padding(
                padding: const EdgeInsets.all(11),
                child: Image.asset(widget.iconAsset!, color: Colors.white),
              ),
        suffixIcon: widget.obscure
            ? IconButton(
                onPressed: () => setState(() => _hide = !_hide),
                icon: _hide
                    ? Image.asset(
                        'assets/icons/🦆 icon _eye off_.png',
                        width: 17,
                      )
                    : const Icon(
                        Icons.visibility_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
              )
            : null,
        filled: true,
        fillColor: _fieldColor,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: const BorderSide(color: _yellow),
        ),
      ),
    ),
  );
}

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 42,
    child: ElevatedButton.icon(
      onPressed: onTap,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 17),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _yellow,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

class AuthPage extends StatelessWidget {
  const AuthPage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF101111),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
}

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key, required this.onTap});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 42,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: _yellow,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/🦆 icon _google_.svg',
            width: 16,
            height: 16,
          ),
          const SizedBox(width: 6),
          const Text(
            'Login with Google',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}
