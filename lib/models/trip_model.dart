import 'package:senergy/models/purposeModel.dart';

import 'carModel.dart';
import 'har_models.dart';

class TripModel {
  int? id;

  String? phone;
  String? carNumber;
  String? passengers;
  String? from;
  String? to;

  String? user;
  bool? tirepressure;
  bool? wear;
  bool? walldamage;
  bool? dust;
  bool? wheel;
  bool? spare;
  bool? jack;
  bool? roadside;
  bool? flash;
  bool? engine;
  bool? brake;
  bool? gear;
  bool? clutch;
  bool? washer;
  bool? radiator;
  bool? battery;
  bool? terminals;
  bool? belts;
  bool? fans;
  bool? ac;
  bool? rubber;
  bool? leakage;
  bool? driver;
  bool? vehicle;
  bool? passes;
  bool? fuel;
  bool? scaba;
  bool? extinguishers;
  bool? first;
  bool? seat;
  bool? drinking;
  bool? head;
  bool? back;
  bool? side;
  bool? interior;
  bool? warning;
  bool? brakelights;
  bool? turn;
  bool? reverse;
  bool? windscreen;
  bool? air;
  bool? couplings;
  bool? winch;
  bool? horn;
  bool? secured;
  bool? clean;
  bool? left;
  bool? right;

  String? notes;

  bool? isApproved;
  dynamic isApprovedAt;
  bool? isClosed;
  dynamic isClosedAt;
  bool? danger;

  int? startUnixTime;
  int? endUnixTime;
  User? userProfile;
  Car? car;
  Purpose? purpose;

  TripModel(
      {this.id,
      this.phone,
      this.carNumber,
      this.passengers,
      this.from,
      this.to,
      this.user,
      this.tirepressure,
      this.wear,
      this.walldamage,
      this.dust,
      this.wheel,
      this.spare,
      this.jack,
      this.roadside,
      this.flash,
      this.engine,
      this.brake,
      this.gear,
      this.clutch,
      this.washer,
      this.radiator,
      this.battery,
      this.terminals,
      this.belts,
      this.fans,
      this.ac,
      this.rubber,
      this.leakage,
      this.driver,
      this.vehicle,
      this.passes,
      this.fuel,
      this.scaba,
      this.extinguishers,
      this.first,
      this.seat,
      this.drinking,
      this.head,
      this.back,
      this.side,
      this.interior,
      this.warning,
      this.brakelights,
      this.turn,
      this.reverse,
      this.windscreen,
      this.air,
      this.couplings,
      this.winch,
      this.horn,
      this.secured,
      this.clean,
      this.left,
      this.right,
      this.notes,
      this.isApproved,
      this.isApprovedAt,
      this.isClosed,
      this.isClosedAt,
      this.danger,
      this.startUnixTime,
      this.endUnixTime,
      this.userProfile,
      this.car,
      this.purpose});

  TripModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    // driverName = json['driverName'];
    phone = json['phone'];
    carNumber = json['carNumber'];
    passengers = json['passengers'];
    from = json['from'];
    to = json['to'];
    // startTime = json['startTime'];
    // eArrivalTime = json['eArrivalTime'];
    // startday = json['startday'];
    // eArrivalday = json['eArrivalday'];
    user = json['user'];
    tirepressure = json['tirepressure'];
    wear = json['wear'];
    walldamage = json['walldamage'];
    dust = json['dust'];
    wheel = json['wheel'];
    spare = json['spare'];
    jack = json['jack'];
    roadside = json['roadside'];
    flash = json['roadside'];
    engine = json['engine'];
    brake = json['brake'];
    gear = json['gear'];
    clutch = json['clutch'];
    washer = json['washer'];
    radiator = json['radiator'];
    battery = json['battery'];
    terminals = json['terminals'];
    belts = json['belts'];
    fans = json['fans'];
    ac = json['ac'];
    rubber = json['rubber'];
    leakage = json['leakage'];
    driver = json['driver'];
    vehicle = json['vehicle'];
    passes = json['passes'];
    fuel = json['fuel'];
    scaba = json['scaba'];
    extinguishers = json['extinguishers'];
    first = json['first'];
    seat = json['seat'];
    drinking = json['drinking'];
    head = json['head'];
    back = json['back'];
    side = json['side'];
    interior = json['interior'];
    warning = json['warning'];
    brakelights = json['brakelights'];
    turn = json['turn'];
    reverse = json['reverse'];
    windscreen = json['windscreen'];
    air = json['air'];
    couplings = json['couplings'];
    winch = json['winch'];
    horn = json['horn'];
    secured = json['secured'];
    clean = json['clean'];
    left = json['left'];
    right = json['right'];
    notes = json['notes'];
    isApproved = json['isApproved'];
    isApprovedAt = json['isApprovedAt'];
    isClosed = json['isClosed'];
    isClosedAt = json['isClosedAt'];
    danger = json['danger'];
    startUnixTime = json['startTimeStamp'];
    endUnixTime = json['endTimeStamp'];
    userProfile =
        json['userr'] != null ? new User.fromJson(json['userr']) : null;
    car = json['carr'] != null ? new Car.fromJson(json['carr']) : null;
    purpose = json['purposee'] != null
        ? new Purpose.fromJson(json['purposee'])
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    // data['driverName'] = this.driverName;
    data['phone'] = this.phone;
    data['carNumber'] = this.carNumber;
    data['passengers'] = this.passengers;
    data['from'] = this.from;
    data['to'] = this.to;
    // data['startTime'] = this.startTime;
    // data['eArrivalTime'] = this.eArrivalTime;
    data['user'] = this.user;
    data['tirepressure'] = this.tirepressure;
    data['wear'] = this.wear;
    data['walldamage'] = this.walldamage;
    data['dust'] = this.dust;
    data['wheel'] = this.wheel;
    data['spare'] = this.spare;
    data['jack'] = this.jack;
    data['roadside'] = this.roadside;
    data['roadside'] = this.roadside;
    data['engine'] = this.engine;
    data['brake'] = this.brake;
    data['gear'] = this.gear;
    data['clutch'] = this.clutch;
    data['washer'] = this.washer;
    data['radiator'] = this.radiator;
    data['battery'] = this.battery;
    data['terminals'] = this.terminals;
    data['belts'] = this.belts;
    data['fans'] = this.fans;
    data['ac'] = this.ac;
    data['rubber'] = this.rubber;
    data['leakage'] = this.leakage;
    data['driver'] = this.driver;
    data['vehicle'] = this.vehicle;
    data['passes'] = this.passes;
    data['fuel'] = this.fuel;
    data['scaba'] = this.scaba;
    data['extinguishers'] = this.extinguishers;
    data['first'] = this.first;
    data['seat'] = this.seat;
    data['drinking'] = this.drinking;
    data['head'] = this.head;
    data['back'] = this.back;
    data['side'] = this.side;
    data['interior'] = this.interior;
    data['warning'] = this.warning;
    data['brakelights'] = this.brakelights;
    data['turn'] = this.turn;
    data['reverse'] = this.reverse;
    data['windscreen'] = this.windscreen;
    data['air'] = this.air;
    data['couplings'] = this.couplings;
    data['winch'] = this.winch;
    data['horn'] = this.horn;
    data['secured'] = this.secured;
    data['clean'] = this.clean;
    data['left'] = this.left;
    data['right'] = this.right;
    data['notes'] = this.notes;
    data['isApproved'] = this.isApproved;
    data['isApprovedAt'] = this.isApprovedAt;
    data['isClosed'] = this.isClosed;
    data['isClosedAt'] = this.isClosedAt;
    data['danger'] = this.danger;
    data['startTimeStamp'] = this.startUnixTime;
    data['endTimeStamp'] = this.endUnixTime;
    if (this.userProfile != null) {
      data['userr'] = this.userProfile!.toJson();
    }
    if (this.car != null) {
      data['carr'] = this.car!.toJson();
    }
    if (this.purpose != null) {
      data['purposee'] = this.purpose!.toJson();
    }

    return data;
  }
}
