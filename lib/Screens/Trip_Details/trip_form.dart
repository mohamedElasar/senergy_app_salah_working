import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:senergy/constants.dart';
import 'package:senergy/managers/auth_manager.dart';
import 'package:senergy/managers/trip_text_manager.dart';

import '../../managers/trip_manager.dart';

class TripForm extends StatefulWidget {
  const TripForm({Key? key, this.size}) : super(key: key);
  final size;
  @override
  State<TripForm> createState() => _TripFormState();
}

class _TripFormState extends State<TripForm> {
  Map<String, dynamic> _register_data = {};
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();
  var driver_name_controller = TextEditingController();
  var car_number_controller = TextEditingController();
  var passengers_controller = TextEditingController();
  var from_controller = TextEditingController();
  var to_controller = TextEditingController();
  var phone_controller = TextEditingController();

  List<String> weekdays = [
    'SAT',
    'SUN',
    'MON',
    'TUE',
    'WED',
    'THU',
    'FRI',
  ];
  TimeOfDay _timeStart = TimeOfDay.now();
  TimeOfDay _timeEnd = TimeOfDay.now();

  void _selectTimeStart(context) async {
    final localizations = MaterialLocalizations.of(context);

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeStart,
    );
    if (newTime != null) {
      setState(() {
        _timeStart = newTime;
      });
    }
    Provider.of<TripTextManager>(context, listen: false)
        .setstart_clock(localizations.formatTimeOfDay(newTime!));
  }

  void _selectTimeEnd(context) async {
    final localizations = MaterialLocalizations.of(context);

    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _timeEnd,
    );
    if (newTime != null) {
      setState(() {
        _timeEnd = newTime;
      });
      Provider.of<TripTextManager>(context, listen: false)
          .setend_clock(localizations.formatTimeOfDay(newTime));
    }
  }

  // ignore: prefer_final_fields
  Map<String, dynamic> _data = {'day_start': null, 'day_arrival': null};
  void _modalBottomSheet_cars(BuildContext context, Size size) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Consumer<TripManager>(
                  builder: (context, hartextmanager, child) => Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: senergyColorg,
                    ),
                    child: const Center(
                      child: Text(
                        'Select Vehicle',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'GE-bold',
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Consumer<TripManager>(
                      builder: (_, harmanager, child) {
                        if (harmanager.cars == null ||
                            harmanager.cars!.isEmpty) {
                          return const Center(child: Text('No Locations'));
                        } else {
                          return ListView.builder(
                            itemCount: harmanager.cars!.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Provider.of<TripTextManager>(context,
                                          listen: false)
                                      .set_trip_Car(harmanager.cars![index]);

                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  width: widget.size.width * .9,
                                  child: Center(
                                    child: Text(
                                      harmanager.cars![index].name.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'AraHamah1964R-Bold'),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _modalBottomSheet_purposes(BuildContext context, Size size) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 250.0,
            color: Colors.transparent,
            child: Column(
              children: [
                Consumer<TripManager>(
                  builder: (context, hartextmanager, child) => Container(
                    height: 40,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: senergyColorg,
                    ),
                    child: const Center(
                      child: Text(
                        'Select Purpose',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'GE-bold',
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Consumer<TripManager>(
                      builder: (_, harmanager, child) {
                        if (harmanager.Purposes == null ||
                            harmanager.Purposes!.isEmpty) {
                          return const Center(child: Text('No Locations'));
                        } else {
                          return ListView.builder(
                            itemCount: harmanager.Purposes!.length,
                            itemBuilder: (BuildContext ctxt, int index) {
                              return ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white, // background
                                  onPrimary: Colors.white, // foreground
                                ),
                                onPressed: () {
                                  Provider.of<TripTextManager>(context,
                                          listen: false)
                                      .set_trip_Purpose(
                                          harmanager.Purposes![index]);

                                  Navigator.pop(context);
                                },
                                child: SizedBox(
                                  width: widget.size.width * .9,
                                  child: Center(
                                    child: Text(
                                      harmanager.Purposes![index].name
                                          .toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'AraHamah1964R-Bold'),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final driverName =
        Provider.of<Auth_manager>(context, listen: false).username ?? '';
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                'Driver Name',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'GE-medium',
                  color: senergyColorg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                driverName,
                style: const TextStyle(
                  fontSize: 25,
                  fontFamily: 'AraHamah1964R-Regular',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                'Trip details',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'GE-medium',
                  color: senergyColorg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Consumer<TripTextManager>(
                    builder: (context, triptextManager, child) => Select_widget(
                            context,
                            'Select a Vehicle',
                            triptextManager.trip_Car.name, () {
                          _modalBottomSheet_cars(context, size);
                        })),
                Consumer<TripTextManager>(
                    builder: (context, triptextManager, child) => Select_widget(
                            context,
                            'Select a Purpose',
                            triptextManager.trip_Purpose.name, () {
                          _modalBottomSheet_purposes(context, size);
                        })),
              ],
            ),
          ),

          build_edit_field(
            item: 'phone_number',
            hint: 'Phone Number',
            controller: phone_controller,
            inputType: TextInputType.number,
            focus: focus2,
          ),

          build_edit_field(
            item: 'passengers',
            hint: 'Passengers',
            controller: passengers_controller,
            inputType: TextInputType.name,
            focus: focus4,
          ),
          Center(
            child: SizedBox(
              width: widget.size.width * .9,
              child: Row(
                children: [
                  build_edit_field(
                    item: 'from',
                    hint: 'From',
                    controller: from_controller,
                    inputType: TextInputType.name,
                    focus: focus5,
                    small: true,
                  ),
                  build_edit_field(
                    item: 'to',
                    hint: 'To',
                    controller: to_controller,
                    inputType: TextInputType.name,
                    focus: focus6,
                    small: true,
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                'Start Time',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'GE-medium',
                  color: senergyColorg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 40,
                width: widget.size.width * .9,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        onChanged: (date) {}, onConfirm: (date) {
                      Provider.of<TripTextManager>(context, listen: false)
                          .setStartDateUnix(date);
                    }, currentTime: DateTime.now());
                  },
                  child: Consumer<TripTextManager>(
                    builder: (context, tripTextManager, child) => Row(
                      children: [
                        // const Icon(Icons.add_circle_outline_outlined),
                        // const Spacer(),
                        tripTextManager.StartTimeUnix == null
                            ? const Icon(Icons.add_circle_outline_outlined)
                            : Text(
                                tripTextManager.StartTimeUnix.toString()
                                    .substring(
                                        0,
                                        tripTextManager.StartTimeUnix.toString()
                                                .length -
                                            7)
                                    .replaceAll(RegExp(' '), ' , '),
                                style: const TextStyle(
                                    color: senergyColorg,
                                    fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Text(
                'Expected Arrival Time',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'GE-medium',
                  color: senergyColorg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Container(
                alignment: Alignment.centerRight,
                width: widget.size.width * .9,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        onChanged: (date) {}, onConfirm: (date) {
                      Provider.of<TripTextManager>(context, listen: false)
                          .setEndDateUnix(date);
                    }, currentTime: DateTime.now());
                  },
                  child: Consumer<TripTextManager>(
                    builder: (context, tripTextManager, child) => Row(
                      children: [
                        // const Icon(Icons.add_circle_outline_outlined),
                        // const Spacer(),
                        tripTextManager.EndTimeUnix == null
                            ? const Icon(Icons.add_circle_outline_outlined)
                            : Text(
                                tripTextManager.EndTimeUnix.toString()
                                    .substring(
                                        0,
                                        tripTextManager.EndTimeUnix.toString()
                                                .length -
                                            7)
                                    .replaceAll(RegExp(' '), ' , '),
                                style: const TextStyle(
                                    color: senergyColorg,
                                    fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Container(
          //   alignment: Alignment.topLeft,
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          //     child: Text(
          //       'Start Time',
          //       style: TextStyle(
          //         fontSize: 15,
          //         fontFamily: 'GE-medium',
          //         color: senergyColorg,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          // Center(
          //   child: SizedBox(
          //     width: widget.size.width * .9,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Center(
          //           child: Container(
          //             alignment: Alignment.centerRight,
          //             width: widget.size.width / 3 * .9,
          //             padding: const EdgeInsets.symmetric(horizontal: 20),
          //             height: 40,
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               // borderRadius:
          //               //     BorderRadius.circular(20),
          //               border: Border.all(color: Colors.grey),
          //             ),
          //             child: DropdownButtonHideUnderline(
          //               child: DropdownButton(
          //                 style: const TextStyle(
          //                     fontFamily: 'AraHamah1964R-Bold',
          //                     fontSize: 15,
          //                     color: Colors.black),
          //                 // value: _data[e - 1],
          //                 hint: const Text('Day'),
          //                 value: _data['day_start'],
          //                 isExpanded: true,
          //                 iconSize: 30,
          //                 onChanged: (newval) {
          //                   setState(() {
          //                     _data['day_start'] = newval.toString();
          //                   });
          //                   Provider.of<TripTextManager>(context, listen: false)
          //                       .setstart_time(newval.toString());
          //                 },
          //                 icon: const Icon(Icons.keyboard_arrow_down),
          //                 items: weekdays
          //                     .map((item) => DropdownMenuItem(
          //                           child: Text(item),
          //                           value: item,
          //                         ))
          //                     .toList(),
          //               ),
          //             ),
          //           ),
          //         ),
          //         GestureDetector(
          //           onTap: () => _selectTimeStart(context),
          //           child: Container(
          //             alignment: Alignment.centerRight,
          //             width: widget.size.width / 3 * .9,
          //             padding: const EdgeInsets.symmetric(horizontal: 20),
          //             height: 40,
          //             decoration: BoxDecoration(
          //               color: kbackgroundColor3,
          //               border: Border.all(color: Colors.grey),
          //             ),
          //             child: Text(
          //               _timeStart.format(context),
          //               style: const TextStyle(
          //                   fontSize: 15,
          //                   fontFamily: 'AraHamah1964R-Bold',
          //                   color: Colors.black54),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Container(
          //   alignment: Alignment.topLeft,
          //   child: const Padding(
          //     padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          //     child: Text(
          //       'Expected Arrival Time',
          //       style: TextStyle(
          //         fontSize: 15,
          //         fontFamily: 'GE-medium',
          //         color: senergyColorg,
          //         fontWeight: FontWeight.bold,
          //       ),
          //     ),
          //   ),
          // ),
          // Center(
          //   child: SizedBox(
          //     width: widget.size.width * .9,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Center(
          //           child: Container(
          //             alignment: Alignment.centerRight,
          //             width: widget.size.width / 3 * .9,
          //             padding: const EdgeInsets.symmetric(horizontal: 20),
          //             height: 40,
          //             decoration: BoxDecoration(
          //               color: Colors.white,
          //               // borderRadius:
          //               //     BorderRadius.circular(20),
          //               border: Border.all(color: Colors.grey),
          //             ),
          //             child: DropdownButtonHideUnderline(
          //               child: DropdownButton(
          //                 style: const TextStyle(
          //                     fontFamily: 'AraHamah1964R-Bold',
          //                     fontSize: 15,
          //                     color: Colors.black),
          //                 // value: _data[e - 1],
          //                 hint: const Text('Day'),
          //                 value: _data['day_arrival'],
          //                 isExpanded: true,
          //                 iconSize: 30,
          //                 onChanged: (newval) {
          //                   setState(() {
          //                     _data['day_arrival'] = newval.toString();
          //                   });
          //                   Provider.of<TripTextManager>(context, listen: false)
          //                       .setend_time(newval.toString());
          //                 },
          //                 icon: const Icon(Icons.keyboard_arrow_down),
          //                 items: weekdays
          //                     .map((item) => DropdownMenuItem(
          //                           child: Text(item),
          //                           value: item,
          //                         ))
          //                     .toList(),
          //               ),
          //             ),
          //           ),
          //         ),
          //         GestureDetector(
          //           onTap: () => _selectTimeEnd(context),
          //           child: Container(
          //             alignment: Alignment.centerRight,
          //             width: widget.size.width / 3 * .9,
          //             padding: const EdgeInsets.symmetric(horizontal: 20),
          //             height: 40,
          //             decoration: BoxDecoration(
          //               color: kbackgroundColor3,
          //               border: Border.all(color: Colors.grey),
          //             ),
          //             child: Text(
          //               _timeEnd.format(context),
          //               style: const TextStyle(
          //                   fontSize: 15,
          //                   fontFamily: 'AraHamah1964R-Bold',
          //                   color: Colors.black54),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
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
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
          onChanged: (value) {
            Provider.of<TripTextManager>(context, listen: false)
                .setdata(item, controller.text);
          },
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

  Container Select_widget(BuildContext context, String title, dynamic text,
      VoidCallback modalsheet) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      alignment: Alignment.centerRight,
      width: widget.size.width * .45,
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
        // borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: modalsheet,
        child: Row(
          children: [
            text == null
                ? SizedBox(
                    width: widget.size.width * .3,
                    child: Text(
                      title,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                        fontFamily: 'AraHamah1964R-Regular',
                      ),
                    ),
                  )
                : SizedBox(
                    width: widget.size.width * .3,
                    child: Text(
                      text,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 20,
                        fontFamily: 'AraHamah1964R-Regular',
                      ),
                    ),
                  ),
            Spacer(),
            Icon(Icons.keyboard_arrow_down)
          ],
        ),
      ),
    );
  }
}
