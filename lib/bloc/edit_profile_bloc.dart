import 'dart:async';

import 'package:brickart_flutter/models/user.dart';
import 'package:brickart_flutter/services/auth_service.dart';
import 'package:brickart_flutter/services/user_service.dart';
import 'package:brickart_flutter/util/fields_validation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'bloc.dart';

class EditProfileBloc implements Bloc {
  UserService _userService;
  AuthService _authService;
  final _fullNameRegexp = RegExp(fullNameRegExp);
  final _mobileRegexp = RegExp(mobileRegExp);
  final _passRegexp = RegExp(passwordRegExp);

  final _userProfileController = BehaviorSubject<User>();
  StreamSubscription<User> _userStreamSubscription;

  final _fullNameController = BehaviorSubject<String>();
  final _mobileController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>.seeded('');
  final _passwordConfirmationController = BehaviorSubject<String>.seeded('');
  final _isFullNameValidController = BehaviorSubject<bool>.seeded(true);
  final _isMobileValidController = BehaviorSubject<bool>.seeded(true);
  final _isPasswordValidController = BehaviorSubject<bool>.seeded(true);
  final _isPasswordConfirmationValidController =
      BehaviorSubject<bool>.seeded(true);
  final _isFormValidController = BehaviorSubject<bool>.seeded(false);

  ValueStream<User> get userProfile => _userProfileController.stream;
  StreamSink<String> get fullName => _fullNameController.sink;

  StreamSink<String> get mobile => _mobileController.sink;
  StreamSink<String> get password => _passwordController.sink;
  StreamSink<String> get passwordConfirmation =>
      _passwordConfirmationController.sink;
  ValueStream<bool> get isFullNameValid => _isFullNameValidController.stream;

  ValueStream<bool> get isMobileValid => _isMobileValidController.stream;
  ValueStream<bool> get isPasswordValid => _isPasswordValidController.stream;
  ValueStream<bool> get isPasswordConfirmationValid =>
      _isPasswordConfirmationValidController.stream;
  ValueStream<bool> get isFormValid => _isFormValidController.stream;

  EditProfileBloc({UserService userService, AuthService authService}) {
    _userService = userService ?? UserService();
    _authService = authService ?? AuthService();

    _initStreams();
  }

  void _initStreams() {
    // Inits auth status listener to populate _userProfileController
    _authService.authStatus.listen((fbUser) {
      if (fbUser != null) {
        var userStream = _userService.getUserProfile(fbUser.uid).map<User>(
            (event) => event.exists ? User.fromMap(event.data()) : null);
        _userStreamSubscription =
            userStream.listen((user) => _userProfileController.add(user));
      } else {
        if (_userStreamSubscription != null) {
          _userProfileController.add(null);
          _userStreamSubscription.cancel();
        }
      }
    });

    // Validates full name
    _isFullNameValidController.addStream(
        _fullNameController.map<bool>((fullName) => _validateName(fullName)));

    // Validates mobile phone
    _isMobileValidController.addStream(
        _mobileController.map<bool>((mobile) => _validateMobile(mobile)));

    // Validates password
    _isPasswordValidController.addStream(
        _passwordController.map<bool>((pass) => _validatePassword(pass)));

    // Validates password confirmation
    CombineLatestStream.combine2<String, String, bool>(
        _passwordController,
        _passwordConfirmationController,
        (a, b) => _validatePasswordConfirmation(a, b)).listen((value) {
      _isPasswordConfirmationValidController.add(value);
    });

    // Validates form
    CombineLatestStream.combine4<bool, bool, bool, bool, bool>(
        _isFullNameValidController,
        _isMobileValidController,
        _isPasswordValidController,
        _isPasswordConfirmationValidController,
        (fullName, mobile, pass, passConfirm) =>
            (fullName && mobile && pass && passConfirm)).listen((value) {
      _isFormValidController.add(value);
    });
  }

  /// Updates user profile on database based on controller fields
  Future<void> updateProfile() async {
    if (_isFormValidController.value) {
      var currentUser = _authService.currentUser;

      Map<String, dynamic> changesMap = {};

      if (_fullNameController.value != null) {
        changesMap['name'] = _fullNameController.value;
      }
      if (_mobileController.value != null) {
        changesMap['mobile_phone'] = _mobileController.value;
      }
      await _userService.updateUserProfile(currentUser.uid, changesMap);

      if (_passwordController.value.isNotEmpty) {
        await currentUser.updatePassword(_passwordController.value);
        _passwordController.add('');
        _passwordConfirmationController.add('');
      }
    } else {
      print('Invalid form');
      throw Error();
    }
  }

  /// Validates full name string
  bool _validateName(String name) {
    return name != null ? _fullNameRegexp.hasMatch(name) : false;
  }

  /// Validates mobile phone string
  bool _validateMobile(String mobile) {
    return mobile != null ? _mobileRegexp.hasMatch(mobile) : false;
  }

  /// Validates password string
  bool _validatePassword(String password) {
    return password.isEmpty ? true : _passRegexp.hasMatch(password);
  }

  /// Validated password confirmation string
  bool _validatePasswordConfirmation(
      String password, String passwordConfirmation) {
    return password == passwordConfirmation ? true : false;
  }

  @override
  void dispose() {
    _fullNameController.close();

    _mobileController.close();
    _passwordController.close();
    _isFullNameValidController.close();

    _isMobileValidController.close();
    _isPasswordValidController.close();
    _isPasswordConfirmationValidController.close();
    _isFormValidController.close();
  }
}
