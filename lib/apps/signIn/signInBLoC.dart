import 'dart:async';

import 'package:digitalcard/models/user.dart';
import 'package:flutter/material.dart';
import 'package:digitalcard/services/auth.dart';

class SignInBloc {
  final AuthBase auth;
  SignInBloc({@required this.auth});

  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isloadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) {
    _isLoadingController.add(isLoading);
  }

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User> signInAnonymusly() async =>
      await _signIn(auth.signInAnonymously);

  // Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);
}
