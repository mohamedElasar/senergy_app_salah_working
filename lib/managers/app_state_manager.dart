import 'package:flutter/material.dart';

import '../models/har_models.dart';

class AppStateManager extends ChangeNotifier {
  bool _register = false;
  bool _harreportsactions = false;
  bool _tripdetails = false;
  bool _hardetails = false;
  bool _mytrips = false;
  bool _harreports = false;
  bool _singletrip = false;
  bool _singlehar = false;
  bool _singleaction = false;
  int? _tripId;
  int? _harId;
  int? _actionId;

  bool get register => _register;
  bool get tripdetails => _tripdetails;
  bool get hardetails => _hardetails;
  bool get mytrips => _mytrips;
  bool get singletrip => _singletrip;
  bool get singlehar => _singlehar;
  bool get singleaction => _singleaction;
  bool get harreports => _harreports;
  bool get harreportsactions => _harreportsactions;
  int get tripId => _tripId!;
  int get harId => _harId!;
  int get actionId => _actionId!;

  void registerStudent(bool value) {
    _register = value;
    notifyListeners();
  }

  void gototripdetails(bool value) {
    _tripdetails = value;

    notifyListeners();
  }

  void gotohardetails(bool value) {
    _hardetails = value;

    notifyListeners();
  }

  void gotomytrips(bool value) {
    _mytrips = value;
    notifyListeners();
  }

  void gotomyactions(bool value) {
    _harreportsactions = value;
    notifyListeners();
  }

  void gotomyharReports(bool value) {
    _harreports = value;
    notifyListeners();
  }

  void gotomysingletrips(bool value, int id) {
    _singletrip = value;
    _tripId = id;
    notifyListeners();
  }

  void gotomysinglehar(bool value, int id) {
    _singlehar = value;
    _harId = id;
    _actionDueTimeUnix = null;

    notifyListeners();
  }

  void gotomysingleaction(bool value, int id) {
    _singleaction = value;
    _actionId = id;
    _actionDueTimeUnix = null;

    notifyListeners();
  }

  void gotoHome() {
    // _tripdetails = false;
    // _mytrips = false;
    // _singletrip = false;
    // _hardetails = false;

    _harreportsactions = false;
    _tripdetails = false;
    _hardetails = false;
    _mytrips = false;
    _harreports = false;
    _singletrip = false;
    _singlehar = false;
    _singleaction = false;

    notifyListeners();
  }

  User _action_assignedTo = User();
  User get action_assignedTo {
    return _action_assignedTo;
  }

  void set_har_action_assigned_to(User item) {
    _action_assignedTo = item;
    notifyListeners();
  }

  void clearactoin() {
    _action_assignedTo = User();

    notifyListeners();
  }

  void clearaction() {
    _actionDueTimeUnix = null;
    notifyListeners();
  }

  var _actionDueTimeUnix;
  get actionDueTimeUnix {
    return _actionDueTimeUnix;
  }

  void setactionDueTime(DateTime time) {
    _actionDueTimeUnix = time;
    notifyListeners();
  }
}
