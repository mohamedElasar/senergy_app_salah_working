import 'dart:io';

import 'package:flutter/material.dart';
import '../models/har_models.dart';

class HarTextManager extends ChangeNotifier {
  // ignore: prefer_final_fields

  String _event_date = '';
  String get event_date {
    return _event_date;
  }

  var _event_dateTime;
  get event_dateTime {
    return _event_dateTime;
  }

  void set_event_date(String item, DateTime date) {
    _event_date = item;
    _event_dateTime = date;
    notifyListeners();
  }

  ReportLocation _har_location = ReportLocation();
  ReportLocation get har_location {
    return _har_location;
  }

  void set_har_location(ReportLocation item) {
    _har_location = item;
    notifyListeners();
  }

  ReportDepartment _har_department = ReportDepartment();
  ReportDepartment get har_department {
    return _har_department;
  }

  void set_har_department(ReportDepartment item) {
    _har_department = item;
    notifyListeners();
  }

  ReportHarType _har_report_type = ReportHarType();
  ReportHarType get har_report_type {
    return _har_report_type;
  }

  void set_har_report_type(ReportHarType item) {
    _har_report_type = item;
    notifyListeners();
  }

  ReportType_ _har_report_type_ = ReportType_();
  ReportType_ get har_report_type_ {
    return _har_report_type_;
  }

  void set_har_report_type_(ReportType_ item) {
    _har_report_type_ = item;
    notifyListeners();
  }

  ReportSeverity _har_report_severity = ReportSeverity();
  ReportSeverity get har_report_severity {
    return _har_report_severity;
  }

  void set_har_report_severity(ReportSeverity item) {
    _har_report_severity = item;
    notifyListeners();
  }

  ReportLikelihood _har_report_likelihood = ReportLikelihood();
  ReportLikelihood get har_report_likelihood {
    return _har_report_likelihood;
  }

  void set_har_report_likelihood(ReportLikelihood item) {
    _har_report_likelihood = item;
    notifyListeners();
  }

  ReportCategory _har_report_category = ReportCategory();
  ReportCategory get har_report_category {
    return _har_report_category;
  }

  void set_har_report_category(ReportCategory item) {
    _har_report_category = item;
    notifyListeners();
  }

  var _har_report_img;
  get har_report_img {
    return _har_report_img;
  }

  void set_har_report_img(File item) {
    _har_report_img = item;
    notifyListeners();
  }

  void clearAll() {
    _har_report_img = null;
    _event_dateTime = null;
    _event_date = '';

    // _hardata = {
    //   'driver_name': '',
    //   'phone_number': '',
    //   'car_name': '',
    //   'passengers': '',
    //   'from': '',
    //   'to': '',
    // };
    // _event_date = '';
    notifyListeners();
  }
}
