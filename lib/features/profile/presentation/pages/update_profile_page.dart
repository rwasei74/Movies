import 'package:flutter/material.dart';

const _yellow = Color(0xFFFFC400);
const _panel = Color(0xFF292B2A);

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});
  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  var _picker = false;
  var _avatar = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF101111),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 11),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: _yellow, size: 18),
            ),
            const Center(
              child: Text(
                'Pick Avatar',
                style: TextStyle(color: _yellow, fontSize: 8),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: GestureDetector(
                onTap: () => setState(() => _picker = !_picker),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF5BC4E2),
                  child: Text(
                    _avatarFaces[_avatar],
                    style: const TextStyle(fontSize: 34),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const _ProfileField(
              icon: Icons.person_rounded,
              hint: 'John Safwat',
            ),
            const SizedBox(height: 8),
            const _ProfileField(icon: Icons.phone_rounded, hint: '01200000000'),
            const SizedBox(height: 10),
            const Text(
              'Reset Password',
              style: TextStyle(color: Colors.white, fontSize: 9),
            ),
            const Spacer(),
            if (_picker)
              _AvatarPicker(
                selected: _avatar,
                onSelect: (value) => setState(() {
                  _avatar = value;
                  _picker = false;
                }),
              ),
            if (_picker) const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF02727),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
            const SizedBox(height: 7),
            SizedBox(
              width: double.infinity,
              height: 36,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _yellow,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Update Data',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

const _avatarFaces = [
  '🧑🏻',
  '👩🏽‍🎨',
  '👩🏻‍🚀',
  '👨🏽‍🚒',
  '👩🏻‍💼',
  '🧑🏾‍🎤',
  '👨🏻‍🎨',
  '👩🏼‍🔧',
  '🧔🏻',
];

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.icon, required this.hint});
  final IconData icon;
  final String hint;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 36,
    child: TextField(
      style: const TextStyle(color: Colors.white, fontSize: 10),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFD3D3D3), fontSize: 9),
        prefixIcon: Icon(icon, color: Colors.white, size: 16),
        filled: true,
        fillColor: _panel,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

class _AvatarPicker extends StatelessWidget {
  const _AvatarPicker({required this.selected, required this.onSelect});
  final int selected;
  final ValueChanged<int> onSelect;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(12),
    ),
    child: GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _avatarFaces.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 7,
        crossAxisSpacing: 9,
      ),
      itemBuilder: (_, index) => InkWell(
        onTap: () => onSelect(index),
        child: CircleAvatar(
          backgroundColor: index == selected
              ? _yellow
              : const Color(0xFF4A5EA4),
          child: Text(
            _avatarFaces[index],
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    ),
  );
}
