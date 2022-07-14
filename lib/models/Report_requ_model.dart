import 'package:senergy/models/har_models.dart';

class HARMODEL {
  int? id;
  String? title;
  String? content;
  int? reportDate;
  int? entryDate;
  int? lastModify;
  String? reportId;
  int? status;
  int? closingDate;
  int? acknowledgedDate;
  String? area;
  int? riskRating;
  dynamic classs;
  bool? clientInvolved;
  bool? industryRecognized;
  bool? hide;
  bool? draft;
  int? reportType;
  int? likelihood;
  int? severity;
  int? reporter;
  int? lastModifyBy;
  int? closedBy;
  int? acknowledgedBy;
  int? department;
  int? category;
  int? type;
  int? event_severity;
  ReportHarType? reportHarType;
  ReportLikelihood? reportLikelihood;
  ReportSeverity? reportSeverity;
  User? reportReporter;
  User? reportLastModifyBy;
  User? reportClosedBy;
  User? reportAcknowledgedBy;
  ReportDepartment? reportDepartment;
  ReportCategory? reportCategory;
  ReportType_? reportType_;
  ReportLocation? reportLocation;
  String? image;

  HARMODEL({
    this.id,
    this.title,
    this.content,
    this.reportDate,
    this.entryDate,
    this.lastModify,
    this.reportId,
    this.status,
    this.closingDate,
    this.acknowledgedDate,
    this.area,
    this.riskRating,
    this.classs,
    this.clientInvolved,
    this.industryRecognized,
    this.hide,
    this.draft,
    this.reportType,
    this.likelihood,
    this.severity,
    this.reporter,
    this.lastModifyBy,
    this.closedBy,
    this.acknowledgedBy,
    this.department,
    this.category,
    this.type,
    this.reportHarType,
    this.reportLikelihood,
    this.reportSeverity,
    this.reportReporter,
    this.reportLastModifyBy,
    this.reportClosedBy,
    this.reportAcknowledgedBy,
    this.reportDepartment,
    this.reportCategory,
    this.reportType_,
    this.reportLocation,
    this.event_severity,
    this.image,
  });

  HARMODEL.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    reportDate = json['report_date'];
    entryDate = json['entry_date'];
    lastModify = json['last_modify'];
    reportId = json['report_id'];
    status = json['status'];
    closingDate = json['closing_date'];
    acknowledgedDate = json['acknowledged_date'];
    area = json['area'];
    riskRating = json['risk_rating'];
    classs = json['class'];
    clientInvolved = json['client_involved'];
    industryRecognized = json['industry_recognized'];
    hide = json['hide'];
    draft = json['draft'];
    reportType = json['report_type'];
    likelihood = json['likelihood'];
    severity = json['severity'];
    reporter = json['reporter'];
    lastModifyBy = json['last_modify_by'];
    closedBy = json['closed_by'];
    acknowledgedBy = json['acknowledged_by'];
    department = json['department'];
    category = json['category'];
    type = json['type'];
    image = json['image'];
    event_severity = json['event_severity'];
    reportHarType = json['report_har_type'] != null
        ? new ReportHarType.fromJson(json['report_har_type'])
        : null;
    reportLikelihood = json['report_likelihood'] != null
        ? new ReportLikelihood.fromJson(json['report_likelihood'])
        : null;
    reportSeverity = json['report_severity'] != null
        ? new ReportSeverity.fromJson(json['report_severity'])
        : null;
    reportReporter = json['report_reporter'] != null
        ? new User.fromJson(json['report_reporter'])
        : null;
    reportLastModifyBy = json['report_last_modify_by'] != null
        ? new User.fromJson(json['report_last_modify_by'])
        : null;
    reportClosedBy = json['report_closed_by'] != null
        ? new User.fromJson(json['report_closed_by'])
        : null;
    reportAcknowledgedBy = json['report_acknowledged_by'] != null
        ? new User.fromJson(json['report_acknowledged_by'])
        : null;
    reportDepartment = json['report_department'] != null
        ? new ReportDepartment.fromJson(json['report_department'])
        : null;
    reportCategory = json['report_category'] != null
        ? new ReportCategory.fromJson(json['report_category'])
        : null;
    reportType_ = json['report_type_'] != null
        ? new ReportType_.fromJson(json['report_type_'])
        : null;
    reportLocation = json['report_location'] != null
        ? new ReportLocation.fromJson(json['report_location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['report_date'] = this.reportDate;
    data['entry_date'] = this.entryDate;
    data['last_modify'] = this.lastModify;
    data['report_id'] = this.reportId;
    data['status'] = this.status;
    data['closing_date'] = this.closingDate;
    data['acknowledged_date'] = this.acknowledgedDate;
    data['area'] = this.area;
    data['risk_rating'] = this.riskRating;
    data['class'] = this.classs;
    data['client_involved'] = this.clientInvolved;
    data['industry_recognized'] = this.industryRecognized;
    data['hide'] = this.hide;
    data['draft'] = this.draft;
    data['report_type'] = this.reportType;
    data['likelihood'] = this.likelihood;
    data['severity'] = this.severity;
    data['reporter'] = this.reporter;
    data['last_modify_by'] = this.lastModifyBy;
    data['closed_by'] = this.closedBy;
    data['acknowledged_by'] = this.acknowledgedBy;
    data['department'] = this.department;
    data['category'] = this.category;
    data['type'] = this.type;
    data['image'] = this.image;
    data['event_severity'] = this.event_severity;
    if (this.reportHarType != null) {
      data['report_har_type'] = this.reportHarType!.toJson();
    }
    if (this.reportLikelihood != null) {
      data['report_likelihood'] = this.reportLikelihood!.toJson();
    }
    if (this.reportSeverity != null) {
      data['report_severity'] = this.reportSeverity!.toJson();
    }
    if (this.reportReporter != null) {
      data['report_reporter'] = this.reportReporter!.toJson();
    }
    if (this.reportLastModifyBy != null) {
      data['report_last_modify_by'] = this.reportLastModifyBy!.toJson();
    }
    if (this.reportClosedBy != null) {
      data['report_closed_by'] = this.reportClosedBy!.toJson();
    }
    if (this.reportAcknowledgedBy != null) {
      data['report_acknowledged_by'] = this.reportAcknowledgedBy!.toJson();
    }
    if (this.reportDepartment != null) {
      data['report_department'] = this.reportDepartment!.toJson();
    }
    if (this.reportCategory != null) {
      data['report_category'] = this.reportCategory!.toJson();
    }
    if (this.reportType != null) {
      data['report_type_'] = this.reportType_!.toJson();
    }
    if (this.reportLocation != null) {
      data['report_location'] = this.reportLocation!.toJson();
    }
    return data;
  }
}
