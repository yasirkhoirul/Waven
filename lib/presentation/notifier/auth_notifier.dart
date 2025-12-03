import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class CubitListenable extends ChangeNotifier {
  late final StreamSubscription _subscription;

  CubitListenable(BlocBase cubit) {
    _subscription = cubit.stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}