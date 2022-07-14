import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/carModel.dart';
import '../models/purposeModel.dart';

class TripTextManager extends ChangeNotifier {
  // ignore: prefer_final_fields
  var _tripdata = {
    'driver_name': '',
    'phone_number': '',
    'car_name': '',
    'passengers': '',
    'from': '',
    'to': '',
    'content': '',
    'title': '',
  };
  dynamic get tripdata {
    return _tripdata;
  }

  String _start_time = '';
  String get start_time {
    return _start_time;
  }

  String _end_time = '';
  String get end_time {
    return _end_time;
  }

  String _start_clock = '';
  String get start_clock {
    return _start_clock;
  }

  String _end_clock = '';
  String get end_clock {
    return _end_clock;
  }

  var _StartTimeUnix;
  get StartTimeUnix {
    return _StartTimeUnix;
  }

  var _EndTimeUnix;
  get EndTimeUnix {
    return _EndTimeUnix;
  }

  void setdata(String item, String data) {
    _tripdata[item] = data;
    notifyListeners();
  }

  void setstart_time(String time) {
    _start_time = time;
    notifyListeners();
  }

  void setstart_clock(String clock) {
    _start_clock = clock;
    notifyListeners();
  }

  void setend_clock(String clock) {
    _end_clock = clock;
    print(clock);
    notifyListeners();
  }

  void setend_time(String time) {
    _end_time = time;
    notifyListeners();
  }

  void setStartDateUnix(DateTime clock) {
    _StartTimeUnix = clock;
    notifyListeners();
  }

  void setEndDateUnix(DateTime time) {
    _EndTimeUnix = time;
    notifyListeners();
  }

  Car _trip_Car = Car();
  Car get trip_Car {
    return _trip_Car;
  }

  void set_trip_Car(Car item) {
    _trip_Car = item;
    notifyListeners();
  }

  Purpose _trip_Purpose = Purpose();
  Purpose get trip_Purpose {
    return _trip_Purpose;
  }

  void set_trip_Purpose(Purpose item) {
    _trip_Purpose = item;
    notifyListeners();
  }

  void clearAll() {
    _tripdata = {
      'driver_name': '',
      'phone_number': '',
      'car_name': '',
      'passengers': '',
      'from': '',
      'to': '',
      'content': '',
      'title': '',
    };
    _start_time = '';
    _end_time = '';
    _start_clock = '';
    _end_clock = '';
    _StartTimeUnix = null;
    _EndTimeUnix = null;

    notifyListeners();
  }
}
