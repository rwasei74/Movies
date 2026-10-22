import 'package:flutter/foundation.dart';

class OnboardingViewModel extends ChangeNotifier {
  int currentPage = 0;

  void changePage(int value) {
    currentPage = value;
    notifyListeners();
  }
}
