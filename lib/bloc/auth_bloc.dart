import 'dart:async';

import 'package:brickart_flutter/bloc/bloc.dart';
import 'package:brickart_flutter/models/auth_status.dart';
import 'package:brickart_flutter/models/login_errors.dart';
import 'package:brickart_flutter/services/auth_service.dart';
import 'package:brickart_flutter/services/user_service.dart';
import 'package:brickart_flutter/util/fields_validation.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

class AuthBloc implements Bloc {
  UserService _userService;
  AuthService _authService;
  final _emailRegexp = RegExp(emailRegExp);
  final _passRegexp = RegExp(passwordRegExp);
  final _currentUserController = BehaviorSubject<firebase_auth.User>();
  final _authStatus = BehaviorSubject<AuthStatus>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _isEmailValidController = BehaviorSubject<bool>.seeded(false);
  final _isPasswordValidController = BehaviorSubject<bool>.seeded(false);
  final _isFormValidController = BehaviorSubject<bool>.seeded(false);
  final displayErrors = BehaviorSubject<bool>.seeded(false);
  final _error = BehaviorSubject<LoginErrors>.seeded(LoginErrors.none);

  ValueStream<firebase_auth.User> get currentUser => _currentUserController.stream;
  ValueStream<AuthStatus> get authStatus => _authStatus.stream;
  StreamSink<String> get email => _emailController.sink;
  StreamSink<String> get password => _passwordController.sink;
  ValueStream<bool> get isEmailValid => _isEmailValidController.stream;
  ValueStream<bool> get isPasswordValid => _isPasswordValidController.stream;
  ValueStream<bool> get isFormValid => _isFormValidController.stream;
  ValueStream<LoginErrors> get error => _error.stream;

  AuthBloc({UserService userService, AuthService authService}) {
    _authService = authService ?? AuthService();
    _userService = userService ?? UserService();

    _initStreams();
  }

  void _initStreams() {
    _currentUserController.addStream(_authService.authStatus);
    _currentUserController.listen((value) {
      //print('Auth status: $value');
      if (value != null) {
        _authStatus.add(AuthStatus.signedIn);
      } else {
        _authStatus.add(AuthStatus.signedOut);
      }
    });

    _isEmailValidController.addStream(_emailController.map<bool>(
        (email) => email != null ? _emailRegexp.hasMatch(email) : false));

    _isPasswordValidController.addStream(_passwordController.map<bool>(
        (pass) => pass != null ? _passRegexp.hasMatch(pass) : false));

    CombineLatestStream.combine2<bool, bool, bool>(
        _isEmailValidController,
        _isPasswordValidController,
        (email, pass) => (email && pass)).listen((value) {
      _isFormValidController.add(value);
    });
  }

  /// Signs in user with email and password.
  Future<dynamic> signInWithEmail() async {
    if (_isFormValidController.value) {
      try {
        var authResult = await _authService.signInWithEmail(
            _emailController.value, _passwordController.value);
        _emailController.add('');
        _passwordController.add('');
        displayErrors.add(false);
        return authResult;
      } catch (error) {
        print(error.code);
        _error.add(LoginErrors.unknown_error);
        displayErrors.add(true);
        return null;
      }
    } else {
      print('Form invalid');
      _error.add(LoginErrors.form_invalid);
      displayErrors.add(true);
      return null;
    }
  }

  /// Signs in user with Google account.
  Future<dynamic> signInWithGoogle() async {
    try {
      var authResult = await _authService.signInWithGoogle();
      if (authResult.user != null) {
        var hasProfile = await _userService.userHasProfile(authResult.user.uid);
        print('Has profile: $hasProfile');
        if (!hasProfile) {
          print('Creating profile');
          await _userService.createUserProfile(authResult.user.uid, {
            'name': authResult.user.displayName,
            'email': authResult.user.email,
            'profile_picture': authResult.user.photoUrl,
            'created_at': DateTime.now().toIso8601String()
          });
        }
      }
      _emailController.add('');
      _passwordController.add('');
      displayErrors.add(false);
      return authResult;
    } catch (error) {
      print(error);
      return null;
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    return _authService.signOut();
  }

  @override
  void dispose() {
    _currentUserController.close();
    _emailController.close();
    _passwordController.close();
    displayErrors.close();
    _error.close();
  }
}
