class User {
  int? id;
  dynamic loginId;
  String? password;
  String? name;
  String? email;
  int? status;
  dynamic position;
  bool? defaultPass;
  bool? loginHar;
  bool? loginJm;
  bool? loginTr;
  bool? loginAudit;
  bool? admin;
  dynamic lastlogin;
  bool? isAdmin;

  User(
      {this.id,
      this.loginId,
      this.password,
      this.name,
      this.email,
      this.status,
      this.position,
      this.defaultPass,
      this.loginHar,
      this.loginJm,
      this.loginTr,
      this.loginAudit,
      this.admin,
      this.lastlogin,
      this.isAdmin});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    loginId = json['login_id'];
    password = json['password'];
    name = json['name'];
    email = json['email'];
    status = json['status'];
    position = json['position'];
    defaultPass = json['default_pass'];
    loginHar = json['login_har'];
    loginJm = json['login_jm'];
    loginTr = json['login_tr'];
    loginAudit = json['login_audit'];
    admin = json['admin'];
    lastlogin = json['lastlogin'];
    isAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['login_id'] = this.loginId;
    data['password'] = this.password;
    data['name'] = this.name;
    data['email'] = this.email;
    data['status'] = this.status;
    data['position'] = this.position;
    data['default_pass'] = this.defaultPass;
    data['login_har'] = this.loginHar;
    data['login_jm'] = this.loginJm;
    data['login_tr'] = this.loginTr;
    data['login_audit'] = this.loginAudit;
    data['admin'] = this.admin;
    data['lastlogin'] = this.lastlogin;
    data['isAdmin'] = this.isAdmin;
    return data;
  }
}

class ReportHarType {
  int? id;
  String? type;

  ReportHarType({this.id, this.type});

  ReportHarType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_name'] = this.type;
    return data;
  }
}

class ReportLocation {
  int? id;
  String? name;

  ReportLocation({this.id, this.name});

  ReportLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['location_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['location_name'] = this.name;
    return data;
  }
}

class ReportLikelihood {
  int? id;
  String? likelihood;

  ReportLikelihood({this.id, this.likelihood});

  ReportLikelihood.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    likelihood = json['likelihood'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['likelihood'] = this.likelihood;
    return data;
  }
}

class ReportSeverity {
  int? id;
  String? severity;

  ReportSeverity({this.id, this.severity});

  ReportSeverity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    severity = json['severity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['severity'] = this.severity;
    return data;
  }
}

class ReportDepartment {
  int? id;
  String? departmentName;

  ReportDepartment({this.id, this.departmentName});

  ReportDepartment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    departmentName = json['department_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['department_name'] = this.departmentName;
    return data;
  }
}

class ReportCategory {
  int? id;
  String? hazardCategory;

  ReportCategory({this.id, this.hazardCategory});

  ReportCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hazardCategory = json['hazard_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['hazard_category'] = this.hazardCategory;
    return data;
  }
}

class ReportType_ {
  int? id;
  String? type;

  ReportType_({this.id, this.type});

  ReportType_.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    return data;
  }
}

class Classification_Group {
  int? id;
  String? classificationName;
  String? classificationGroup;

  Classification_Group(
      {this.id, this.classificationName, this.classificationGroup});

  Classification_Group.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classificationName = json['classification_name'];
    classificationGroup = json['classification_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['classification_name'] = this.classificationName;
    data['classification_group'] = this.classificationGroup;
    return data;
  }
}

class Classification {
  int? id;
  int? reportId;
  int? classificationItem;
  Classification_Group? classificationItems;

  Classification(
      {this.id,
      this.reportId,
      this.classificationItem,
      this.classificationItems});

  Classification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reportId = json['report_id'];
    classificationItem = json['classification_item'];
    classificationItems = json['classification_items'] != null
        ? new Classification_Group.fromJson(json['classification_items'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['report_id'] = this.reportId;
    data['classification_item'] = this.classificationItem;
    if (this.classificationItems != null) {
      data['classification_items'] = this.classificationItems!.toJson();
    }
    return data;
  }
}
