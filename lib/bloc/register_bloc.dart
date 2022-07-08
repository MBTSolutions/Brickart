import 'dart:async';

import 'package:brickart_flutter/bloc/bloc.dart';
import 'package:brickart_flutter/models/register_errors.dart';
import 'package:brickart_flutter/services/auth_service.dart';
import 'package:brickart_flutter/services/user_service.dart';
import 'package:brickart_flutter/util/fields_validation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class RegisterBloc implements Bloc {
  UserService _userService;
  AuthService _authService;
  final _fullNameRegexp = RegExp(fullNameRegExp);
  final _emailRegexp = RegExp(emailRegExp);
  final _passRegexp = RegExp(passwordRegExp);

  final _fullNameController = BehaviorSubject<String>();
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _isFullNameValidController = BehaviorSubject<bool>.seeded(false);
  final _isEmailValidController = BehaviorSubject<bool>.seeded(false);
  final _isPasswordValidController = BehaviorSubject<bool>.seeded(false);
  final _isFormValidController = BehaviorSubject<bool>.seeded(false);
  final displayErrors = BehaviorSubject<bool>.seeded(false);
  final _error = BehaviorSubject<RegisterErrors>.seeded(RegisterErrors.none);

  StreamSink<String> get fullName => _fullNameController.sink;
  StreamSink<String> get email => _emailController.sink;
  StreamSink<String> get password => _passwordController.sink;
  ValueStream<bool> get isFullNameValid => _isFullNameValidController.stream;
  ValueStream<bool> get isEmailValid => _isEmailValidController.stream;
  ValueStream<bool> get isPasswordValid => _isPasswordValidController.stream;
  ValueStream<bool> get isFormValid => _isFormValidController.stream;
  ValueStream<RegisterErrors> get error => _error.stream;

  RegisterBloc({UserService userService, AuthService authService}) {
    _userService = userService ?? UserService();
    _authService = authService ?? AuthService();

    _initStreams();
  }

  void _initStreams() {
    _isFullNameValidController.addStream(_fullNameController.map<bool>(
        (fullName) =>
            fullName != null ? _fullNameRegexp.hasMatch(fullName) : false));

    _isEmailValidController.addStream(_emailController.map<bool>(
        (email) => email != null ? _emailRegexp.hasMatch(email) : false));

    _isPasswordValidController.addStream(_passwordController.map<bool>(
        (pass) => pass != null ? _passRegexp.hasMatch(pass) : false));

    CombineLatestStream.combine3<bool, bool, bool, bool>(
        _isFullNameValidController,
        _isEmailValidController,
        _isPasswordValidController,
        (fullName, email, pass) => (fullName && email && pass)).listen((value) {
      _isFormValidController.add(value);
    });
  }

  Future<dynamic> registerUser() async {
    if (_isFormValidController.value) {
      var authResult = await _authService.createUser(
          _emailController.value, _passwordController.value);

      if (authResult.user != null) {
        await _userService.createUserProfile(authResult.user.uid, {
          'name': _fullNameController.value,
          'email': _emailController.value,
          'created_at': DateTime.now().toIso8601String()
        });
        _fullNameController.add('');
        _emailController.add('');
        _passwordController.add('');
        displayErrors.add(false);
        return authResult;
      }
      return null;
    } else {
      print('Form invalid');
      _error.add(RegisterErrors.form_invalid);
      displayErrors.add(true);
      return null;
    }
  }

  @override
  void dispose() {
    _fullNameController.close();
    _emailController.close();
    _passwordController.close();
    _isFullNameValidController.close();
    _isEmailValidController.close();
    _isPasswordValidController.close();
    _isFormValidController.close();
    displayErrors.close();
  }
}
