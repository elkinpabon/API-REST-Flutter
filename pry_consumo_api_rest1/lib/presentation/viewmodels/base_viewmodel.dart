import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  bool loading = false;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }
}
