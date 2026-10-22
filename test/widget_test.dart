import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/app/app.dart';

void main() {
  testWidgets('يعرض التطبيق شاشة البداية', (tester) async {
    await tester.pumpWidget(const MoviesApp());

    expect(find.byIcon(Icons.play_arrow_rounded), findsOneWidget);
  });
}
