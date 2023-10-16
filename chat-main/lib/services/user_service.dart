import 'dart:async';

import 'package:chat/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserService {
  static UserService? _instance;

  late CollectionReference _userDB;
  auth.User? _currentFirebaseUser;
  User? _currentUser;
  static final StreamController<User?> _userStreamController =
      StreamController<User>.broadcast();
  static Stream<User?> userStream = _userStreamController.stream;

  static UserService getInstance() {
    if (_instance == null) {
      _instance = UserService._();
      return _instance!;
    } else {
      return _instance!;
    }
  }

  UserService._() {
    _userDB = FirebaseFirestore.instance.collection("/users");
    _currentFirebaseUser = auth.FirebaseAuth.instance.currentUser;
    auth.FirebaseAuth.instance.authStateChanges().listen(_authListener);
    if (_currentFirebaseUser != null) {
      User.fromReference(_currentFirebaseUser!.uid).then((value) {
        _currentUser = value;
        _userStreamController.add(_currentUser);
      }).then((User? value) {
        _currentUser = value;
        _userStreamController.add(_currentUser);
      });
    }
  }

  Future<void> manualUpdateUser() async {
    _currentFirebaseUser = auth.FirebaseAuth.instance.currentUser;
    _currentUser = await User.fromReference(_currentFirebaseUser!.uid);
  }

  void _authListener(auth.User? user) async {
    if (user != null) {
      _currentFirebaseUser = user;
      _currentUser = await User.fromReference(user.uid);
      _userStreamController.add(_currentUser);
      _userDB.doc(_currentUser!.uuid).snapshots().listen((event) async {
        _currentUser = await User.fromReference(_currentFirebaseUser!.uid);
        _userStreamController.add(_currentUser!);
      });
    }
  }

  Future<void> updateUser(User newUserInfo) async {
    newUserInfo = User(
      firstName: newUserInfo.firstName ?? _currentUser!.firstName,
      lastName: newUserInfo.lastName ?? _currentUser!.lastName,
      profilePhoto: newUserInfo.profilePhoto ?? _currentUser!.profilePhoto,
      uuid: _currentUser!.uuid,
    );

    _currentUser = newUserInfo;

    _userDB.doc(newUserInfo.uuid).update({
      "first_name": newUserInfo.firstName,
      "last_name": newUserInfo.lastName,
      "photo_url": newUserInfo.profilePhoto,
    });
  }

  User? getCurrentUser() {
    return _currentUser;
  }

  bool isLoggedIn() {
    return _currentUser != null;
  }

  static void initialize() {
    _instance = getInstance();
  }
}
