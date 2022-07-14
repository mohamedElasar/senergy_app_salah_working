import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/managers/trip_manager.dart';
import 'package:senergy/managers/trip_text_manager.dart';

import '../../constants.dart';
import '../../httpexception.dart';
import '../../managers/auth_manager.dart';

class TripCheckList extends StatefulWidget {
  const TripCheckList({Key? key, this.size}) : super(key: key);
  final size;

  @override
  State<TripCheckList> createState() => _TripCheckListState();
}

class _TripCheckListState extends State<TripCheckList> {
  Map<String, bool> checklist = {
    'tire pressure': false,
    'wear': false,
    'wall damage': false,
    'dust': false,
    'wheel': false,
    'spare': false,
    'jack': false,
    'roadside': false,
    'flash': false,
    'engine': false,
    'brake': false,
    'gear': false,
    'clutch': false,
    'washer': false,
    'radiator': false,
    'battery': false,
    'terminals': false,
    'belts': false,
    'fans': false,
    'ac': false,
    'rubber': false,
    'leakage': false,
    'driver': false,
    'vehicle': false,
    'passes': false,
    'fuel': false,
    'scaba': false,
    'extinguishers': false,
    'first': false,
    'seat': false,
    'drinking': false,
    'head': false,
    'back': false,
    'side': false,
    'interior': false,
    'warning': false,
    'brakelights': false,
    'turn': false,
    'reverse': false,
    'windscreen': false,
    'air': false,
    'couplings': false,
    'winch': false,
    'horn': false,
    'secured': false,
    'clean': false,
    'left': false,
    'right': false,
  };
  Map<String, dynamic> _register_data = {};
  final focus1 = FocusNode();
  var notes_controller = TextEditingController();
  bool _isinit = true;
  var tripdata;
  String? time_start;
  String? _end_time;
  String? _clock_start;
  String? _end_clock;

  var _StartUnixTime;
  var _endUnixTime;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final localizations = MaterialLocalizations.of(context);
      tripdata = Provider.of<TripTextManager>(context, listen: false).tripdata;
      time_start =
          Provider.of<TripTextManager>(context, listen: false).start_time;
      _end_time = Provider.of<TripTextManager>(context, listen: false).end_time;
      _clock_start =
          Provider.of<TripTextManager>(context, listen: false).start_clock;

      _end_clock =
          Provider.of<TripTextManager>(context, listen: false).end_clock;

      // real
      _StartUnixTime =
          Provider.of<TripTextManager>(context, listen: false).StartTimeUnix;
      _endUnixTime =
          Provider.of<TripTextManager>(context, listen: false).EndTimeUnix;
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  bool _isLoading = false;
  void _submit() async {
    // print('asdasdasd');
    if (_StartUnixTime == null || _endUnixTime == null) {
      _showErrorDialog('you should enter start and arrival time');
      return;
    }
    if (Provider.of<TripTextManager>(context, listen: false).trip_Car.id ==
        null) {
      _showErrorDialog('you should Select Car');
      return;
    }
    if (Provider.of<TripTextManager>(context, listen: false).trip_Purpose.id ==
        null) {
      _showErrorDialog('you should Select trip purpose');
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      print('_StartUnixTime');
      int _startTime = _StartUnixTime.toUtc().millisecondsSinceEpoch;
      int _endTime = _endUnixTime.toUtc().millisecondsSinceEpoch;
      await Provider.of<TripManager>(context, listen: false)
          .add_trip(
            tripdata['phone_number'],
            // tripdata['car_name'],
            tripdata['passengers'],
            tripdata['from'],
            tripdata['to'],
            _clock_start!,
            _end_clock!,
            time_start!,
            _end_time!,
            checklist['tire pressure']!,
            checklist['wear']!,
            checklist['wall damage']!,
            checklist['dust']!,
            checklist['wheel']!,
            checklist['spare']!,
            checklist['jack']!,
            checklist['roadside']!,
            checklist['flash']!,
            checklist['engine']!,
            checklist['brake']!,
            checklist['gear']!,
            checklist['clutch']!,
            checklist['washer']!,
            checklist['radiator']!,
            checklist['battery']!,
            checklist['terminals']!,
            checklist['belts']!,
            checklist['fans']!,
            checklist['ac']!,
            checklist['rubber']!,
            checklist['leakage']!,
            checklist['driver']!,
            checklist['vehicle']!,
            checklist['passes']!,
            checklist['fuel']!,
            checklist['scaba']!,
            checklist['extinguishers']!,
            checklist['first']!,
            checklist['seat']!,
            checklist['drinking']!,
            checklist['head']!,
            checklist['back']!,
            checklist['side']!,
            checklist['interior']!,
            checklist['warning']!,
            checklist['brakelights']!,
            checklist['turn']!,
            checklist['reverse']!,
            checklist['windscreen']!,
            checklist['air']!,
            checklist['couplings']!,
            checklist['winch']!,
            checklist['horn']!,
            checklist['secured']!,
            checklist['clean']!,
            checklist['left']!,
            checklist['right']!,
            notes_controller.text,
            _startTime,
            _endTime,
            Provider.of<TripTextManager>(context, listen: false).trip_Car.id!,
            Provider.of<TripTextManager>(context, listen: false)
                .trip_Purpose
                .id!,
          )
          .then((_) {
            Navigator.pop(context);
          })
          .then(
            (value) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green[300],
                content: const Text(
                  'Your Trip is submitted for approval',
                  style: TextStyle(fontFamily: 'GE-medium'),
                ),
                duration: const Duration(seconds: 3),
              ),
            ),
          )
          .then((value) =>
              Provider.of<TripTextManager>(context, listen: false).clearAll())
          .then(
            (value) => Provider.of<Auth_manager>(context, listen: false)
                .sendNotification('New Trip', 'Need Your Approval'),
          );
    } on HttpException catch (error) {
      // _showErrorDialog(error.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black26,
          content: Text(
            error.toString(),
            style: const TextStyle(fontFamily: 'GE-medium'),
          ),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (error) {
      const errorMessage = 'Try again later';
      _showErrorDialog('Try again later');
    }
    if (!mounted) return;
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

    return !_isLoading
        ? SingleChildScrollView(
            child: Column(
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
                          checklist['tire pressure']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['tire pressure'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['tire pressure'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['wear']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['wear'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['wear'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['wall damage']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['wall damage'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['wall damage'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['dust']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['dust'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['dust'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['spare']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['spare'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['spare'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['jack']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['jack'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['jack'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['roadside']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['roadside'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['roadside'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['flash']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['flash'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['flash'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['engine']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['engine'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['engine'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['brake']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['brake'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['brake'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['gear']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['gear'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['gear'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['clutch']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['clutch'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['clutch'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['washer']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['washer'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['washer'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['radiator']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['radiator'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['radiator'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['battery']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['battery'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['battery'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['terminals']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['terminals'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['terminals'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['belts']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['belts'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['belts'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['fans']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['fans'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['fans'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['ac']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['ac'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['ac'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['rubber']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['rubber'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['rubber'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['leakage']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['leakage'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['leakage'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['driver']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['driver'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['driver'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['vehicle']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['vehicle'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['vehicle'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['passes']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['passes'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['passes'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['fuel']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['fuel'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['fuel'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['scaba']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['scaba'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['scaba'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['extinguishers']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['extinguishers'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['extinguishers'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['first']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['first'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['first'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['seat']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['seat'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['seat'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['drinking']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['drinking'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['drinking'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['head']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['head'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['head'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['back']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['back'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['back'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['side']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['side'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['side'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['interior']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['interior'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['interior'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['warning']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['warning'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['warning'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['brakelights']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['brakelights'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['brakelights'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['turn']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['turn'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['turn'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['reverse']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['reverse'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['reverse'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['windscreen']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['windscreen'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['windscreen'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['air']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['air'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['air'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['couplings']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['couplings'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['couplings'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['winch']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['winch'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['winch'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['horn']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['horn'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['horn'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['secured']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['secured'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['secured'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['clean']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['clean'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['clean'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['left']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['left'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['left'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
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
                          checklist['right']!
                              ? InkWell(
                                  onTap: () => setState(() {
                                    checklist['right'] = false;
                                  }),
                                  child: const Icon(Icons.done,
                                      color: Colors.green),
                                )
                              : InkWell(
                                  onTap: () => setState(() {
                                    checklist['right'] = true;
                                  }),
                                  child: const Icon(Icons.cancel,
                                      color: Colors.red),
                                )
                        ],
                      ),
                    ],
                  ),
                ),
                build_edit_field(
                  item: 'notes',
                  hint: 'Notes',
                  controller: notes_controller,
                  inputType: TextInputType.name,
                  focus: focus1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: widget.size.width * .9,
                    child: TextButton(
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(2),
                          backgroundColor:
                              MaterialStateProperty.all(kbuttonColor3)),
                      onPressed: _submit,
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            fontFamily: 'GE-Bold',
                            color: Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }

  Center build_edit_field({
    required String item,
    required String hint,
    bool small = false,
    required TextEditingController controller,
    required TextInputType inputType,
    Function(String)? validate,
    FocusNode? focus,
  }) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.centerRight,
        width: small ? widget.size.width * .9 / 2 : widget.size.width * .9,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: TextFormField(
          // maxLength: 6,

          focusNode: focus,
          textInputAction: TextInputAction.next,
          onSaved: (value) {
            _register_data[item] = value!;
          },
          keyboardType: inputType,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return '*';
            }
            return null;
          },
          onChanged: (value) {},
          decoration: InputDecoration(
            focusedErrorBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            errorStyle: const TextStyle(
              decoration: TextDecoration.none,
              fontSize: 12,
            ),
            hintText: hint,
            hintStyle: const TextStyle(fontFamily: 'GE-light', fontSize: 15),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
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
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontFamily: 'GE-medium',
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
            color: Colors.white,
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
