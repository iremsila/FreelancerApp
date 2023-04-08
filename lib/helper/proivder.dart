import 'package:flutter/cupertino.dart';

class AppProvider with ChangeNotifier {
  int current = 0;
  Widget? widgets;
  changeCurrent(int index) {
    current = index;
    notifyListeners();
  }
}