import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/constants.dart';
import 'package:senergy/managers/auth_manager.dart';
import 'package:senergy/managers/trip_text_manager.dart';

import '../../managers/Har_report_requ.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import '../../managers/har_text_manager.dart';
import 'package:image_picker/image_picker.dart';

class HarForm extends StatefulWidget {
  const HarForm({Key? key, this.size}) : super(key: key);
  final size;
  @override
  State<HarForm> createState() => _HarFormState();
}

class _HarFormState extends State<HarForm> {
  Map<String, dynamic> _register_data = {};
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();

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

  String? eventDate;

  var _image;
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      Provider.of<HarTextManager>(context, listen: false)
          .set_har_report_img(_image);
    } else {
      print('No image selected.');
    }
  }

  var title_controller;
  var description_controller;
  bool isinit = true;
  @override
  void didChangeDependencies() {
    print(Provider.of<HarTextManager>(context, listen: false).event_date);
    // MediaQuery.of(context)
    if (isinit) {
      title_controller = TextEditingController(
          text: Provider.of<TripTextManager>(context, listen: false)
              .tripdata['title']);
      description_controller = TextEditingController(
          text: Provider.of<TripTextManager>(context, listen: false)
              .tripdata['content']);
      eventDate =
          Provider.of<HarTextManager>(context, listen: false).event_date;
    }
    isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<Auth_manager>(
        builder: (context, authManager, child) => Column(
          children: [
            Consumer<HarReport_Manager>(
              builder: (context, reportManager, child) => Container(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    'Reporter Name',
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'GE-medium',
                      color: senergyColorg,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  authManager.username!,
                  style: const TextStyle(
                    fontSize: 25,
                    fontFamily: 'AraHamah1964R-Regular',
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const Divider(),
            Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Container(
                  alignment: Alignment.centerRight,
                  // width: 150,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: InkWell(
                    onTap: () {
                      DatePicker.showDateTimePicker(context,
                          showTitleActions: true,
                          onChanged: (date) {}, onConfirm: (date) {
                        Provider.of<HarTextManager>(context, listen: false)
                            .set_event_date(
                                date
                                    .toString()
                                    .substring(0, date.toString().length - 7)
                                    .replaceAll(RegExp(' '), ' , '),
                                date);
                      }, currentTime: DateTime.now());
                    },
                    child: Consumer<HarTextManager>(
                      builder: (context, harTextmanager, child) => Row(
                        children: [
                          const Text(
                            'EVENT DATE',
                            style: TextStyle(fontFamily: 'GE-light'),
                          ),
                          const Spacer(),
                          harTextmanager.event_date == ''
                              ? const Icon(Icons.add_circle_outline_outlined)
                              : Text(harTextmanager.event_date)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Divider(),
            Container(
              alignment: Alignment.topLeft,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'GE-medium',
                    color: senergyColorg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            build_edit_field(
              item: 'title',
              hint: 'Report Title',
              controller: title_controller,
              inputType: TextInputType.name,
              focus: focus1,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  'Report Description',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'GE-medium',
                    color: senergyColorg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            build_edit_field_area(
              item: 'content',
              hint: 'Report Description',
              controller: description_controller,
              inputType: TextInputType.number,
              focus: focus2,
            ),
            Container(
              width: 150,
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: senergyColorg, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  getImage().then((value) => setState(() {}));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Add Image'),
                    Spacer(),
                    Icon(Icons.image_outlined),
                  ],
                ),
              ),
            ),
            Consumer<HarTextManager>(
                builder: ((context, hattextmanager, child) =>
                    hattextmanager.har_report_img != null
                        ? const Text('Image Added')
                        : const Text('No Image Added')))

            // Container(
            //   width: 150,
            //   alignment: Alignment.center,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       primary: senergyColorg, // background
            //       onPrimary: Colors.white, // foreground
            //     ),
            //     onPressed: () {
            //       Provider.of<HarReport_Manager>(context, listen: false)
            //           .add_HAR(file: _image);
            //     },
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Text('TEST'),
            //         Spacer(),
            //         Icon(Icons.image_outlined),
            //       ],
            //     ),
            //   ),
            // )
          ],
        ),
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

  Center build_edit_field_area({
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
        // height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey),
        ),
        child: TextFormField(
          // maxLength: 6,
          minLines: 8,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          focusNode: focus,
          textInputAction: TextInputAction.next,
          onSaved: (value) {
            _register_data[item] = value!;
          },
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
}
