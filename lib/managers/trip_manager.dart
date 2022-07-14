import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import '../httpexception.dart';

import '../models/carModel.dart';
import '../models/purposeModel.dart';
import './auth_manager.dart';
import '../models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TripManager extends ChangeNotifier {
  void receiveToken(Auth_manager auth, List<TripModel> trips) {
    _authToken = auth.token;
    _name = auth.username;
    // _trips = trips;
  }

  String? _authToken;
  String? _name;
  List<TripModel>? _trips = [];
  List<TripModel>? get trips => _trips;
  List<Car>? _cars = [];
  List<Car>? get cars => _cars;
  List<Purpose>? _Purposes = [];
  List<Purpose>? get Purposes => _Purposes;

  TripModel? _single_trip;
  TripModel? get single_trip => _single_trip;

  int _page = 0;
  get page => _page;
  get hasmore => _hasMore;
  get pageNumber => _pageNumber;
  get error => _error;
  get loading => _loading;

  bool _hasMore = false;
  int _pageNumber = 0;
  bool _error = false;
  bool _loading = true;

  final int _defaultsizePerPage = 10;

  Future<void> add_trip(
    String phone,
    // String carNumber,
    String passengers,
    String from,
    String to,
    String startTime,
    String eArrivalTime,
    String startday,
    String eArrivalday,
    // String user,
    bool tirepressure,
    bool wear,
    bool walldamage,
    bool dust,
    bool wheel,
    bool spare,
    bool jack,
    bool roadside,
    bool flash,
    bool engine,
    bool brake,
    bool gear,
    bool clutch,
    bool washer,
    bool radiator,
    bool battery,
    bool terminals,
    bool belts,
    bool fans,
    bool ac,
    bool rubber,
    bool leakage,
    bool driver,
    bool vehicle,
    bool passes,
    bool fuel,
    bool scaba,
    bool extinguishers,
    bool first,
    bool seat,
    bool drinking,
    bool head,
    bool back,
    bool side,
    bool interior,
    bool warning,
    bool brakelights,
    bool turn,
    bool reverse,
    bool windscreen,
    bool air,
    bool couplings,
    bool winch,
    bool horn,
    bool secured,
    bool clean,
    bool left,
    bool right,
    String notes,
    int startTimeunix,
    int endTimeUnix,
    int carid,
    int purposeId,
    // bool isApproved,
    // dynamic isApprovedAt,
    // bool isClosed,
    // dynamic isClosedAt,
  ) async {
    var url = Uri.http('10.0.2.2:5000', '/api/trips');
    try {
      Dio dio = Dio();
      String urld = 'http://10.0.2.2:5000/api/trips';
      Map<String, dynamic> params = {
        // 'driverName': _name,
        'phone': phone,
        // 'carNumber': carNumber,
        'passengers': passengers,
        'from': from,
        'to': to,
        'startTime': startTime,
        'eArrivalTime': eArrivalTime,
        'startday': startday,
        'eArrivalday': eArrivalday,
        // 'user': user,
        'tirepressure': tirepressure,
        'wear': wear,
        'walldamage': walldamage,
        'dust': dust,
        'wheel': wheel,
        'spare': spare,
        'jack': jack,
        'roadside': roadside,
        'engine': engine,
        'brake': brake,
        'gear': gear,
        'clutch': clutch,
        'washer': washer,
        'radiator': radiator,
        'battery': battery,
        'terminals': terminals,
        'belts': belts,
        'fans': fans,
        'ac': ac,
        'rubber': rubber,
        'leakage': leakage,
        'driver': driver,
        'vehicle': vehicle,
        'passes': passes,
        'fuel': fuel,
        'scaba': scaba,
        'extinguishers': extinguishers,
        'first': first,
        'seat': seat,
        'drinking': drinking,
        'head': head,
        'back': back,
        'side': side,
        'interior': interior,
        'warning': warning,
        'brakelights': brakelights,
        'turn': turn,
        'reverse': reverse,
        'windscreen': windscreen,
        'air': air,
        'couplings': couplings,
        'winch': winch,
        'horn': horn,
        'secured': secured,
        'clean': clean,
        'left': left,
        'right': right,
        'notes': notes,
        'startTimeStamp': startTimeunix,
        'endTimeStamp': endTimeUnix,
        'car_id': carid,
        'purpose_id': purposeId,
      };
      dio.options.headers["Authorization"] = 'Bearer $_authToken';
      dio.options.headers["Accept"] = 'application/json';
      var response = await dio.post(urld, data: jsonEncode(params));
    } on DioError catch (e) {
      throw HttpException(e.response!.data['message']);
    }

    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  Future<void> get_trips() async {
    var url = Uri.http('10.0.2.2:5000', '/api/trips/mine');
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );
      final responseData = json.decode(response.body);

      List<dynamic> tripsList = responseData;
      var list = tripsList.map((data) => TripModel.fromJson(data)).toList();
      _trips = list;

      // add exception

    } catch (error) {
      print('errortrips');
    }

    notifyListeners();
  }

  Future<void> get_cars() async {
    var url = Uri.http('10.0.2.2:5000', '/api/trips/cars/cars');
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );
      final responseData = json.decode(response.body);

      List<dynamic> carsList = responseData;
      var list = carsList.map((data) => Car.fromJson(data)).toList();
      _cars = list;

      // add exception

    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> get_purposes() async {
    var url = Uri.http('10.0.2.2:5000', '/api/trips/purpose/all/all');
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );
      final responseData = json.decode(response.body);

      List<dynamic> carsList = responseData;
      var list = carsList.map((data) => Purpose.fromJson(data)).toList();
      _Purposes = list;

      // add exception

    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> get_all_trips({bool mine = false}) async {
    // var url = Uri.http('10.0.2.2:5000', '/api/trips');
    print(_trips!.length.toString());

    var url = mine
        ? Uri.http(
            '10.0.2.2:5000',
            '/api/trips/p/mine',
            {
              "page": '0',
              "size": '10',
            },
          )
        : Uri.http(
            '10.0.2.2:5000',
            '/api/trips/p/all',
            {
              "page": '0',
              "size": '10',
            },
          );
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );
      final responseData = json.decode(response.body);

      List<dynamic> tripsList = responseData['trips'];
      var list = tripsList.map((data) => TripModel.fromJson(data)).toList();
      _trips = list;

      // add exception

    } catch (error) {
      print('errortrips');
    }

    notifyListeners();
  }

  void resetlist() {
    _trips = [];
    _loading = true;
    _pageNumber = 0;
    _error = false;
    // print(_pageNumber);
    notifyListeners();
  }

  void setloading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void seterror(bool value) {
    _error = value;
    notifyListeners();
  }

  Future<void> getMoreData({bool mine = false}) async {
    // print(_trips!.length.toString());
    var url = mine
        ? Uri.http(
            '10.0.2.2:5000',
            '/api/trips/p/mine',
            {
              "page": _pageNumber.toString(),
              "size": '10',
            },
          )
        : Uri.http(
            '10.0.2.2:5000',
            '/api/trips/p/all',
            {
              "page": _pageNumber.toString(),
              "size": '10',
            },
          );
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );

      final responseData = json.decode(response.body);
      // print(url);
      // print(responseData);

      List<dynamic> tripsList = responseData['trips'];
      var fetchedTrips =
          tripsList.map((data) => TripModel.fromJson(data)).toList();

      _hasMore = fetchedTrips.length == 10;
      _loading = false;
      _pageNumber = _pageNumber + 1;

      _trips!.addAll(fetchedTrips);
      // print(_trips!.length.toString());
    } catch (e) {
      print(e);
      _loading = false;
      _error = true;
      notifyListeners();
    }

    notifyListeners();
  }

  Future<void> get_single_trips(int id) async {
    var url = Uri.http('10.0.2.2:5000', '/api/trips/$id');
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );
      final responseData = json.decode(response.body);

      _single_trip = TripModel.fromJson(responseData[0]);

      // add exception
      // print(_single_trip);
    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> close_single_trips(int id) async {
    var url = Uri.http('10.0.2.2:5000', '/api/trips/$id/close');
    try {
      var response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );

      // add exception

    } catch (error) {
      print('closesingleTripError');
    }

    notifyListeners();
  }

  Future<void> danger_single_trips(int id) async {
    var url = Uri.http('10.0.2.2:5000', '/api/trips/$id/danger');
    try {
      var response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );
    } catch (error) {
      print('dangersingleTripError');
    }

    notifyListeners();
  }

  Future<void> approve_single_trips(int id) async {
    var url = Uri.http('10.0.2.2:5000', '/api/trips/$id/approve');
    try {
      var response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );

      // add exception

    } catch (error) {
      print('closesingleTripError');
    }

    notifyListeners();
  }

  Future<void> delete_single_trip(int id) async {
    var url = Uri.http('10.0.2.2:5000', '/api/trips/$id/delete');
    final existingIndex = _trips!.indexWhere((trip) => trip.id == id);
    var existingtrip = _trips![existingIndex];
    // print(existingsubject.name);
    _trips!.removeAt(existingIndex);
    // print('here');
    notifyListeners();
    try {
      var response = await http.delete(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );
      final responseData = json.decode(response.body);
      if (responseData['message'] == 'Invalid Admin Token') {
        _trips!.insert(existingIndex, existingtrip);
        notifyListeners();
        throw HttpException('YOU ARE NOT ADMIN');
      }
      if (response.statusCode > 400) {
        // print('asd');
        _trips!.insert(existingIndex, existingtrip);
        notifyListeners();
        throw HttpException('SOMETHING IS WRONG');
      }
      // add exception

    } catch (error) {
      print(error);
      throw (error);
    }

    notifyListeners();
  }
}
