import 'package:flutter/material.dart';
import 'package:inventory/models/household.dart';
import 'package:inventory/models/invitation.dart';
import 'package:inventory/models/user.dart';
import 'package:inventory/services/api.dart';
import 'package:inventory/services/user.dart';

class UserProvider extends ChangeNotifier {
  List<Household>? _households;
  List<Invitation>? _invitations;
  User? _currentUser;
  late UserService _instance;

  UserProvider() {
    _instance = UserService.instance;
    refresh();
    _instance.addListener(refresh);
  }

  Future<void> refresh() async {
    if (_instance.currentUser == null) {
      _households = null;
      _invitations = null;
      _currentUser = null;
    } else {
      _currentUser = _instance.currentUser;
      _households = await APIService.instance.getHouseholds(
        _currentUser!.households,
      );
      _invitations = await APIService.instance.getInvitations(
        _currentUser!.invitations,
      );
    }

    notifyListeners();
  }

  List<Household>? get housholds => _households;
  List<Invitation>? get invitations => _invitations;
  User? get currentUser => _currentUser;
}
