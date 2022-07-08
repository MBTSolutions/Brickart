import 'dart:async';

import 'package:brickart_flutter/models/user.dart';
import 'package:brickart_flutter/services/auth_service.dart';
import 'package:brickart_flutter/services/user_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

import 'bloc.dart';

class DrawerBloc implements Bloc {
  UserService _userService;
  AuthService _authService;
  final _userProfileController = BehaviorSubject<User>();
  StreamSubscription<User> _userStreamSubscription;

  ValueStream<User> get userProfile => _userProfileController.stream;

  DrawerBloc({UserService userService, AuthService authService}) {
    _userService = userService ?? UserService();
    _authService = authService ?? AuthService();

    _initStreams();
  }

  void _initStreams() {
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
