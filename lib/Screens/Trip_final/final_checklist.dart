import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/managers/app_state_manager.dart';
import 'package:senergy/managers/trip_manager.dart';

import '../../constants.dart';

class FinalChecklist extends StatefulWidget {
  FinalChecklist(
      {Key? key,
      required this.tirepressure,
      required this.wear,
      required this.walldamage,
      required this.dust,
      required this.wheel,
      required this.spare,
      required this.jack,
      required this.roadside,
      required this.flash,
      required this.engine,
      required this.brake,
      required this.gear,
      required this.clutch,
      required this.washer,
      required this.radiator,
      required this.battery,
      required this.terminals,
      required this.belts,
      required this.fans,
      required this.ac,
      required this.rubber,
      required this.leakage,
      required this.driver,
      required this.vehicle,
      required this.passes,
      required this.fuel,
      required this.scaba,
      required this.extinguishers,
      required this.first,
      required this.seat,
      required this.drinking,
      required this.head,
      required this.back,
      required this.side,
      required this.interior,
      required this.warning,
      required this.brakelights,
      required this.turn,
      required this.reverse,
      required this.windscreen,
      required this.air,
      required this.couplings,
      required this.winch,
      required this.horn,
      required this.secured,
      required this.clean,
      required this.left,
      required this.right,
      required this.notes,
      required this.tripid,
      required this.closed,
      required this.closedat,
      required this.isadmin,
      required this.isapproved})
      : super(key: key);

  bool tirepressure;
  bool wear;
  bool walldamage;
  bool dust;
  bool wheel;
  bool spare;
  bool jack;
  bool roadside;
  bool flash;
  bool engine;
  bool brake;
  bool gear;
  bool clutch;
  bool washer;
  bool radiator;
  bool battery;
  bool terminals;
  bool belts;
  bool fans;
  bool ac;
  bool rubber;
  bool leakage;
  bool driver;
  bool vehicle;
  bool passes;
  bool fuel;
  bool scaba;
  bool extinguishers;
  bool first;
  bool seat;
  bool drinking;
  bool head;
  bool back;
  bool side;
  bool interior;
  bool warning;
  bool brakelights;
  bool turn;
  bool reverse;
  bool windscreen;
  bool air;
  bool couplings;
  bool winch;
  bool horn;
  bool secured;
  bool clean;
  bool left;
  bool right;
  String notes;
  int tripid;
  bool closed;
  final closedat;
  bool isadmin;
  bool isapproved;

  @override
  State<FinalChecklist> createState() => _FinalChecklistState();
}

var _isLoading = false;

class _FinalChecklistState extends State<FinalChecklist> {
  void _closeTrip(int id, context) {
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<TripManager>(context, listen: false)
          .close_single_trips(id)
          .then((_) {
        // Navigator.pop(context);
        Provider.of<AppStateManager>(context, listen: false).gotoHome();
      }).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[300],
            content: const Text(
              'Your Trip is closed',
              style: TextStyle(fontFamily: 'GE-medium'),
            ),
            duration: const Duration(seconds: 3),
          ),
        ),
      );
    } catch (e) {
      const errorMessage = 'Try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _approveTrip(int id, context) {
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<TripManager>(context, listen: false)
          .approve_single_trips(id)
          .then((_) {
        // Navigator.pop(context);
        Provider.of<AppStateManager>(context, listen: false).gotoHome();
      }).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green[300],
            content: const Text(
              'THE TRIP IS APPROVED',
              style: TextStyle(fontFamily: 'GE-medium'),
            ),
            duration: const Duration(seconds: 3),
          ),
        ),
      );
    } catch (e) {
      const errorMessage = 'Try again later';
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Something went wrong',
          style: TextStyle(fontFamily: 'GE-Bold'),
        ),
        content: Text(
          message,
          style: const TextStyle(fontFamily: 'AraHamah1964R-Bold'),
        ),
        actions: <Widget>[
          Center(
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(kbackgroundColor1)),
              // color: kbackgroundColor1,
              child: const Text(
                'OK',
                style: TextStyle(fontFamily: 'GE-medium', color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return _isLoading
        ? const CircularProgressIndicator()
        : Column(
            children: [
              const Title(
                text: 'Tires inspection',
              ),
              ItemCheckList(
                image: 'assets/images/tyre.png',
                column: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Tire pressure',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.tirepressure
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Wear',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.wear
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Wall Damage',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.walldamage
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Dust Caps',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.dust
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/spare.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Spare ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.spare
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/jack.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * .5,
                          child: const Text(
                            'Jack, wheel Spanner, tools',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GE-medium',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                        widget.jack
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/reflector.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * .35,
                          child: const Text(
                            'RoadLights Reflectors',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'GE-medium',
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Spacer(),
                        widget.roadside
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/flashlight.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'flash lights',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.flash
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              const Title(
                text: 'Under the Bonnet inspection',
              ),
              ItemCheckList(
                image: 'assets/images/engineoil.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Engine Oil Level',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.engine
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Brake Oil',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.brake
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Gear Oil',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.gear
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Clutch Oil',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.clutch
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/washerfluid.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Washer Fluild',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.washer
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/radiator.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Radiator',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.radiator
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/battery.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Battery Charged',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.battery
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Terminals',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.terminals
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/car.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Belts',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.belts
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Fans',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.fans
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'AC Compressor',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.ac
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Rubber Hoses',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.rubber
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Leakage',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.leakage
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              const Title(text: 'Internal Checks'),
              ItemCheckList(
                image: 'assets/images/liscence.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Driver License ',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.driver
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Vehicle License',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.vehicle
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Passes / Permits',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.passes
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/fuel.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Fuel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.fuel
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/scaba.jpg',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'SCABA',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.scaba
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/fire.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Extinguishers',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.extinguishers
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/kit.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'First Aid Kit',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.first
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/seatbelt.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Seat Belts',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.seat
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/water.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Drinking Water',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.drinking
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              const Title(
                text: 'External Checks',
              ),
              ItemCheckList(
                image: 'assets/images/lights.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Head Lights',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.head
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Back Lights',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.back
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Side Lights',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.side
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Interior Lights',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.interior
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Warning Lights',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.warning
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Brake Lights',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.brakelights
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/turn.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Turn Indicators',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.turn
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/reverselights.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Reverse Lights',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.reverse
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/wipers.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'WindScreen Wipers',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.windscreen
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/hose.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Air Hoses',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.air
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Couplings',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.couplings
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/winch.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Winch',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.winch
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/horn.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Horn',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.horn
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/securedload.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Secured Load',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.secured
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/clean.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Vehicle Clean',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.clean
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              ItemCheckList(
                image: 'assets/images/mirrors.png',
                column: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Left',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.left
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                    Row(
                      children: [
                        const Text(
                          'Right',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'GE-medium',
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        widget.right
                            ? const Icon(Icons.done, color: Colors.green)
                            : const Icon(Icons.cancel, color: Colors.red)
                      ],
                    ),
                  ],
                ),
              ),
              const Title(
                text: 'notes',
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerLeft,
                child: Text(widget.notes),
              ),
              if (widget.isadmin && !widget.isapproved)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 100,
                    child: TextButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(2),
                          backgroundColor:
                              MaterialStateProperty.all(kbuttonColor2)),
                      onPressed: () => _approveTrip(widget.tripid, context),
                      child: const Text(
                        'APPROVE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'GE-Bold',
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
              !widget.closed
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 100,
                        child: TextButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(2),
                              backgroundColor:
                                  MaterialStateProperty.all(kbuttonColor2)),
                          onPressed: () => _closeTrip(widget.tripid, context),
                          child: const Text(
                            'CLOSE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                fontFamily: 'GE-Bold',
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        child: Text(
                          'THE TRIP IS CLOSED',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'AraHamah1964R-Regular',
                            color: senergyColorb,
                          ),
                        ),
                      ),
                    ),
            ],
          );
  }
}

class Title extends StatelessWidget {
  const Title({
    Key? key,
    this.text,
  }) : super(key: key);
  final text;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'AraHamah1964R-Regular',
            color: senergyColorg,
          ),
        ),
      ),
    );
  }
}

class ItemCheckList extends StatelessWidget {
  const ItemCheckList({
    Key? key,
    this.column,
    this.image,
  }) : super(key: key);
  final column;
  final image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: Material(
        elevation: 1,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          decoration: const BoxDecoration(
            color: kbackgroundColor2,
          ),
          child: ListTile(
            title: column,
            leading: Image.asset(
              image,
              fit: BoxFit.fill,
              // width: double.infinity,
            ),
            // trailing: const Icon(Icons.done, color: Colors.green),
            // 'assets/images/tyre.png'
          ),
        ),
      ),
    );
  }
}
