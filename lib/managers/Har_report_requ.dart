// ignore: file_names
import 'dart:convert';
import 'dart:io';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:senergy/models/ActionModel.dart';
import 'package:senergy/models/adv_model.dart';

import '../models/Report_requ_model.dart';
import '../models/har_models.dart';
import '../models/trip_model.dart';
import 'auth_manager.dart';
import 'package:http/http.dart' as http;

class HarReport_Manager extends ChangeNotifier {
  void receiveToken(Auth_manager auth, List<HARMODEL> data) {
    _authToken = auth.token;
    reporter_id = auth.userid;
    _data = data;
  }

  String? _authToken;
  int? reporter_id;
  List<HARMODEL>? _data = [];
  List<HARMODEL>? get data => _data;

  HARMODEL? _single_har = HARMODEL();
  HARMODEL? get single_har => _single_har;
  ActionModel? _single_action = ActionModel();
  ActionModel? get single_action => _single_action;

//users
  List<User> _users = [];
  List<User>? get users => _users;
//har types
  List<ReportHarType> _report_har_types = [];
  List<ReportHarType>? get report_har_types => _report_har_types;

//likelihood
  List<ReportLikelihood> _report_likelihoods = [];
  List<ReportLikelihood>? get report_likelihoods => _report_likelihoods;

//severity
  List<ReportSeverity> _report_severitys = [];
  List<ReportSeverity>? get report_severitys => _report_severitys;

//department
  List<ReportDepartment> _report_departments = [];
  List<ReportDepartment>? get report_department => _report_departments;

//category
  List<ReportCategory> _report_categorys = [];
  List<ReportCategory>? get report_categorys => _report_categorys;
// report_type_
  List<ReportType_> _report_type_s = [];
  List<ReportType_>? get report_type_s => _report_type_s;

  List<ReportLocation> _report_locations = [];
  List<ReportLocation>? get report_location => _report_locations;

  List<Classification_Group> _classification_groups = [];
  List<Classification_Group>? get classification_groups =>
      _classification_groups;

  List<Classification> _classifications = [];
  List<Classification>? get classifications => _classifications;
  List<Adv> _advs = [];
  List<Adv>? get advs => _advs;
  List<ActionModel> _actions_for_user = [];
  List<ActionModel>? get actions_for_user => _actions_for_user;

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

  Future<void> get_users() async {
    var url = Uri.http('10.0.2.2:5000', '/api/users');

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
      var list = tripsList.map((data) => User.fromJson(data)).toList();
      _users = list;

      // add exception

    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> get_har_types() async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/har_types');
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
      var list = tripsList.map((data) => ReportHarType.fromJson(data)).toList();
      _report_har_types = list;
      // add exception
      print(responseData);
    } catch (error) {
      print('errorhar_report_har_types');
    }

    notifyListeners();
  }

  Future<void> get_har_locations() async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/locations');
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
      var list =
          tripsList.map((data) => ReportLocation.fromJson(data)).toList();
      _report_locations = list;

      // add exception

    } catch (error) {
      print('errorhar_report_locations');
    }

    notifyListeners();
  }

  Future<void> get_har_likelihood() async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/likelihood');
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
      var list =
          tripsList.map((data) => ReportLikelihood.fromJson(data)).toList();
      _report_likelihoods = list;

      // add exception

    } catch (error) {
      print('errorhar_report_liklihoods');
    }

    notifyListeners();
  }

  Future<void> get_har_severity() async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/severity');
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
      var list =
          tripsList.map((data) => ReportSeverity.fromJson(data)).toList();
      _report_severitys = list;

      // add exception

    } catch (error) {
      print('errorhar_report_severity');
    }

    notifyListeners();
  }

  Future<void> get_har_department() async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/department');
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
      var list =
          tripsList.map((data) => ReportDepartment.fromJson(data)).toList();
      _report_departments = list;

      // add exception

    } catch (error) {
      print('errorhar_report_department');
    }

    notifyListeners();
  }

  Future<void> get_har_report_requirments() async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/all/required/report');
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );
      final responseData = json.decode(response.body);
      // print(responseData['locations']);

      List<dynamic> hazards_categorys = responseData['hazards_categorys'];
      List<dynamic> departments = responseData['departments'];
      List<dynamic> liklihoods = responseData['liklihoods'];
      List<dynamic> locations = responseData['locations'];
      List<dynamic> reportTypes = responseData['reportTypes'];
      List<dynamic> severities = responseData['severities'];
      List<dynamic> har_types = responseData['har_types'];
      List<dynamic> class_details = responseData['class_details'];

      var list1 = hazards_categorys
          .map((data) => ReportCategory.fromJson(data))
          .toList();
      _report_categorys = list1;
      var list2 =
          departments.map((data) => ReportDepartment.fromJson(data)).toList();
      _report_departments = list2;
      var list3 =
          liklihoods.map((data) => ReportLikelihood.fromJson(data)).toList();
      _report_likelihoods = list3;
      var list4 =
          locations.map((data) => ReportLocation.fromJson(data)).toList();
      _report_locations = list4;
      var list5 =
          reportTypes.map((data) => ReportType_.fromJson(data)).toList();
      _report_type_s = list5;
      var list6 =
          severities.map((data) => ReportSeverity.fromJson(data)).toList();
      _report_severitys = list6;
      var list7 =
          har_types.map((data) => ReportHarType.fromJson(data)).toList();
      _report_har_types = list7;
      var list8 = class_details
          .map((data) => Classification_Group.fromJson(data))
          .toList();
      _classification_groups = list8;

      // add exception

    } catch (error) {
      print(error);
      print('errorhar_report_requirements');
    }

    notifyListeners();
  }

  Future<void> get_har_category() async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/hazards_categories');
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
      var list =
          tripsList.map((data) => ReportCategory.fromJson(data)).toList();
      _report_categorys = list;

      // add exception

    } catch (error) {
      print(error);
      print('errorhar_report_categories');
    }

    notifyListeners();
  }

  Future<void> get_har_report_types_() async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/report_type');
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
      var list = tripsList.map((data) => ReportType_.fromJson(data)).toList();
      _report_type_s = list;

      // add exception

    } catch (error) {
      print('errorhar_report_tyrpes_');
    }

    notifyListeners();
  }

  Future<void> get_classificationGroups() async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/class_details');
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
      var list =
          tripsList.map((data) => Classification_Group.fromJson(data)).toList();
      _classification_groups = list;

      // add exception

    } catch (error) {
      print('errorhar_classification_groups');
    }

    notifyListeners();
  }

  Future<void> add_HAR(
      {file,
      reporter,
      eventDate,
      title,
      content,
      locationId,
      segment,
      reportType,
      type,
      likelihood,
      category,
      checklist_list,
      event_severity}) async {
    // var url = Uri.http('10.0.2.2:5000', '/api/har/report');

    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(file.path, filename: fileName),
      'reporter': reporter_id,
      'title': title,
      'content': content,
      'report_date': eventDate,
      'entry_date': DateTime.now().toUtc().millisecondsSinceEpoch,
      'location': locationId,
      'department': segment,
      'report_type': reportType,
      'type': type,
      'likelihood': likelihood,
      'category': category,
      'checklist_list': checklist_list,
      'event_severity': event_severity
    });

    try {
      Dio dio = Dio();
      String urld = 'http://10.0.2.2:5000/api/har/report';

      dio.options.headers["Authorization"] = 'Bearer $_authToken';
      var response = await dio.post(
        urld,
        data: formData,
        options: Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
        ),
      );
      if (response.statusCode != 200) {
        throw HttpException(response.toString());
      }
    } on DioError catch (e) {
      print(e);
      throw HttpException(e.response!.data);
    }

    notifyListeners();
  }

  Future<void> add_HAR_withoutImage(
      {reporter,
      eventDate,
      title,
      content,
      locationId,
      segment,
      reportType,
      type,
      likelihood,
      category,
      checklist_list,
      event_severity}) async {
    // var url = Uri.http('10.0.2.2:5000', '/api/har/report');

    FormData formData = FormData.fromMap({
      'reporter': reporter_id,
      'title': title,
      'content': content,
      'report_date': eventDate,
      'entry_date': DateTime.now().toUtc().millisecondsSinceEpoch,
      'location': locationId,
      'department': segment,
      'report_type': reportType,
      'type': type,
      'likelihood': likelihood,
      'category': category,
      'checklist_list': checklist_list,
      'event_severity': event_severity
    });

    try {
      Dio dio = Dio();
      String urld = 'http://10.0.2.2:5000/api/har/report';

      dio.options.headers["Authorization"] = 'Bearer $_authToken';
      var response = await dio.post(
        urld,
        data: formData,
        options: Options(
          followRedirects: false,
          // will not throw errors
          validateStatus: (status) => true,
        ),
      );

      if (response.statusCode != 200) {
        throw HttpException(response.toString());
      }
    } on DioError catch (e) {
      // print(e);
      throw HttpException(e.response!.data);
    }

    notifyListeners();
  }

  Future<void> get_all_hars({bool mine = false}) async {
    // var url = Uri.http('10.0.2.2:5000', '/api/trips');
    var url = Uri.http(
      '10.0.2.2:5000',
      '/api/har/reports',
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
      var list = tripsList.map((data) => HARMODEL.fromJson(data)).toList();
      _data = list;
      // add exception

    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> getMoreData({bool mine = false}) async {
    print(_data!.length.toString());
    // var url = Uri.http(
    //   '10.0.2.2:5000',
    //   '/api/har/reports',
    //   {
    //     "page": _pageNumber.toString(),
    //     "size": '10',
    //   },
    // );
    var url = mine
        ? Uri.http(
            '10.0.2.2:5000',
            '/api/har/reports/mine/all/mine',
            {
              "page": _pageNumber.toString(),
              "size": '10',
            },
          )
        : Uri.http(
            '10.0.2.2:5000',
            '/api/har/reports',
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
      print(url);
      print(responseData);

      List<dynamic> tripsList = responseData['trips'];
      var fetchedHars =
          tripsList.map((data) => HARMODEL.fromJson(data)).toList();
      _hasMore = fetchedHars.length == 10;
      _loading = false;
      _pageNumber = _pageNumber + 1;

      _data!.addAll(fetchedHars);
    } catch (e) {
      print(e);
      print('e');
      _loading = false;
      _error = true;
      notifyListeners();
    }

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

  void resetlist() {
    _actions_for_user = [];
    _data = [];
    _loading = true;
    _pageNumber = 0;
    _error = false;
    // print(_pageNumber);
    notifyListeners();
  }

  Future<void> get_single_har(int id) async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/reports/$id');
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );
      final responseData = json.decode(response.body);

      _single_har = HARMODEL.fromJson(responseData[0]);

      // add exception

    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> get_single_action(int id) async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/myactions/one/$id');
    try {
      var response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
      );
      final responseData = json.decode(response.body);

      _single_action = ActionModel.fromJson(responseData);

      // add exception

    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> get_classifications_for_report(String id) async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/classifications/$id');
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
      var list =
          tripsList.map((data) => Classification.fromJson(data)).toList();
      _classifications = list;

      // add exception

    } catch (error) {
      print('errorhar_classifications_for_report');
    }

    notifyListeners();
  }

  Future<void> get_advs() async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/advs/all/all');
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
      var list = tripsList.map((data) => Adv.fromJson(data)).toList();
      _advs = list;

      // add exception

    } catch (error) {
      print('error advs');
    }

    notifyListeners();
  }

  Future<void> get_actions_for_user(String id) async {
    // var url = Uri.http('10.0.2.2:5000', '/api/har/actions/all/$id');
    var url = Uri.http(
      '10.0.2.2:5000',
      '/api/har/actions/all/$id',
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

      List<dynamic> tripsList = responseData['trips'];
      var list = tripsList.map((data) => ActionModel.fromJson(data)).toList();
      _hasMore = list.length == 10;
      _loading = false;
      _pageNumber = _pageNumber + 1;

      _actions_for_user.addAll(list);

      // add exception

    } catch (error) {
      print(error);
    }

    notifyListeners();
  }

  Future<void> add_Action2({
    int? assignedBy,
    int? assignedTo,
    String? actionDetails,
    int? dueDate,
    int? reportID,
  }) async {
    var url = Uri.http('10.0.2.2:5000', '/api/har/action');

    try {
      Dio dio = Dio();
      String urld = 'http://10.0.2.2:5000/api/har/action';
      Map<String, dynamic> params = {
        'action_details': actionDetails,
        'target_date': dueDate,
        'assigned_to': assignedTo,
        'assigned_by': assignedBy,
        // 'action_entry_date': DateTime.now().toUtc().millisecondsSinceEpoch,
        'report_id': reportID,
      };
      dio.options.headers["Authorization"] = 'Bearer $_authToken';
      dio.options.headers["Accept"] = 'application/json';
      var response = await dio.post(urld, data: jsonEncode(params));
      print(response);

      if (response.data['message'] != null) {
        throw HttpException(response.data['message']);
      }
    } on DioError catch (e) {
      throw HttpException(e.response!.data['message']);
    }

    notifyListeners();
  }

  Future<void> closeAction2({
    int? id,
    String? closingNote,
    int? closingDate,
  }) async {
    String urld = 'http://10.0.2.2:5000/api/har/action/$id/action';
    Dio dio = Dio();
    Map<String, dynamic> params = {
      'closingNote': closingNote,
      'closing_date': closingDate,
    };

    // var url = Uri.http('10.0.2.2:5000', '/api/har/action/$id/action');
    try {
      dio.options.headers["Authorization"] = 'Bearer $_authToken';
      dio.options.headers["Accept"] = 'application/json';
      var response = await dio.put(urld, data: jsonEncode(params));
      print(response);

      // add exception
      if (response.statusCode != 200) {
        throw HttpException('error');
      }
    } catch (error) {
      print('closeactionError');
      throw HttpException(error.toString());
    }

    notifyListeners();
  }

  Future<void> closeAction({
    int? id,
    String? closingNote,
    int? closingDate,
  }) async {
    print(closingNote);
    print(closingDate);
    var url = Uri.http('10.0.2.2:5000', '/api/har/action/$id/action');
    try {
      var response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $_authToken'
        },
        body: json.encode({
          'closingNote': closingNote,
          'closing_date': closingDate,
        }),
      );

      // add exception
      if (response.statusCode != 200) {
        throw HttpException('error');
      }
      print(response.body);
    } catch (error) {
      print('closeactionError');
      throw HttpException(error.toString());
    }

    notifyListeners();
  }
}
