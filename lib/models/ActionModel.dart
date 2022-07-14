import 'package:senergy/models/Report_requ_model.dart';
import 'package:senergy/models/har_models.dart';

class ActionModel {
  int? id;
  String? actionDetails;
  String? closingNote;
  int? targetDate;
  int? closingDate;
  int? actionEntryDate;
  bool? closed;
  int? assignedTo;
  int? assignedBy;
  int? closedBy;
  int? reportId;
  HARMODEL? reportIdd;
  User? closedByy;
  User? assignedToo;
  User? assignedByy;

  ActionModel(
      {this.id,
      this.actionDetails,
      this.closingNote,
      this.targetDate,
      this.closingDate,
      this.actionEntryDate,
      this.closed,
      this.assignedTo,
      this.assignedBy,
      this.closedBy,
      this.reportId,
      this.reportIdd,
      this.closedByy,
      this.assignedToo,
      this.assignedByy});

  ActionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    actionDetails = json['action_details'];
    closingNote = json['closingNote'];
    targetDate = json['target_date'];
    closingDate = json['closing_date'];
    actionEntryDate = json['action_entry_date'];
    closed = json['closed'];
    assignedTo = json['assigned_to'];
    assignedBy = json['assigned_by'];
    closedBy = json['closed_by'];
    reportId = json['report_id'];
    reportIdd = json['report_idd'] != null
        ? new HARMODEL.fromJson(json['report_idd'])
        : null;
    closedByy = json['closed_byy'] != null
        ? new User.fromJson(json['closed_byy'])
        : null;
    assignedToo = json['assigned_too'] != null
        ? new User.fromJson(json['assigned_too'])
        : null;
    assignedByy = json['assigned_byy'] != null
        ? new User.fromJson(json['assigned_byy'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['action_details'] = this.actionDetails;
    data['closingNote'] = this.closingNote;
    data['target_date'] = this.targetDate;
    data['closing_date'] = this.closingDate;
    data['action_entry_date'] = this.actionEntryDate;
    data['closed'] = this.closed;
    data['assigned_to'] = this.assignedTo;
    data['assigned_by'] = this.assignedBy;
    data['closed_by'] = this.closedBy;
    data['report_id'] = this.reportId;
    if (this.reportIdd != null) {
      data['report_idd'] = this.reportIdd!.toJson();
    }
    if (this.closedByy != null) {
      data['closed_byy'] = this.closedByy!.toJson();
    }
    if (this.assignedToo != null) {
      data['assigned_too'] = this.assignedToo!.toJson();
    }
    if (this.assignedByy != null) {
      data['assigned_byy'] = this.assignedByy!.toJson();
    }
    return data;
  }
}
