import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Screens/Trip_Details/trip_checklist.dart';
import 'package:senergy/managers/har_text_manager.dart';
import 'package:senergy/managers/trip_manager.dart';
import 'package:senergy/managers/trip_text_manager.dart';

import '../../constants.dart';
import '../../httpexception.dart';
import '../../managers/Har_report_requ.dart';
import '../../managers/auth_manager.dart';
import '../../models/har_models.dart';

class HarChecklist extends StatefulWidget {
  const HarChecklist({Key? key, this.size}) : super(key: key);
  final size;

  @override
  State<HarChecklist> createState() => _HarChecklistState();
}

class _HarChecklistState extends State<HarChecklist> {
  Map<String, bool> checklist = {};
  Map<String, dynamic> _register_data = {};
  final focus1 = FocusNode();
  var notes_controller = TextEditingController();
  bool _isinit = true;
  var tripdata;
  String? time_start;
  String? _end_time;
  String? _clock_start;
  String? _end_clock;

  bool _isLoading = false;

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
                style: TextStyle(
                    fontFamily: 'AraHamah1964R-Regular', color: Colors.black),
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

  bool isinit = true;
  Map<String, dynamic> myMap = {};
  List<Classification_Group> uniquelist = [];
  @override
  void didChangeDependencies() {
    if (isinit) {
      var seen = Set<String>();

      uniquelist = Provider.of<HarReport_Manager>(context)
          .classification_groups!
          .where((e) => seen.add(e.classificationGroup.toString()))
          .toList();

      // seen.forEach((element) {
      //   checklist[element] = false;
      // });

      var allList =
          Provider.of<HarReport_Manager>(context).classification_groups!;
      seen.forEach((element) {
        myMap[element.toString()] = allList
            .where((e) => e.classificationGroup == element.toString())
            .toList();
      });
      myMap.entries.forEach((element) {
        element.value
            .forEach((e) => checklist[e.classificationName.toString()] = false);
      });
      print(checklist);
    }
    isinit = false;
    super.didChangeDependencies();
  }

  void _submit(bool img) async {
    List<String> checklist_list = [];

    checklist.entries.forEach((element) {
      if (element.value == true) {
        checklist_list.add(element.key);
      }
    });
    try {
      if (Provider.of<TripTextManager>(context, listen: false)
              .tripdata['title'] ==
          '') {
        _showErrorDialog('you should enter title');
        return;
      }
      if (Provider.of<TripTextManager>(context, listen: false)
              .tripdata['content'] ==
          '') {
        _showErrorDialog('you should enter description');
        return;
      }
      if (checklist_list.isEmpty) {
        _showErrorDialog('you should choose items from checklist');
        return;
      }
      if (Provider.of<HarTextManager>(context, listen: false).event_dateTime ==
          null) {
        _showErrorDialog('you should select event date');
        return;
      }
      if (Provider.of<HarTextManager>(context, listen: false)
              .har_department
              .id ==
          null) {
        _showErrorDialog('you should select segment');
        return;
      }
      if (Provider.of<HarTextManager>(context, listen: false).har_location.id ==
          null) {
        _showErrorDialog('you should select location');
        return;
      }
      if (Provider.of<HarTextManager>(context, listen: false)
              .har_report_type
              .id ==
          null) {
        _showErrorDialog('you should select report type');
        return;
      }
      if (Provider.of<HarTextManager>(context, listen: false)
              .har_report_type_
              .id ==
          null) {
        _showErrorDialog('you should select event type');
        return;
      }
      if (Provider.of<HarTextManager>(context, listen: false)
              .har_report_likelihood
              .id ==
          null) {
        _showErrorDialog('you should select event Liklihood');
        return;
      }
      if (Provider.of<HarTextManager>(context, listen: false)
              .har_report_category
              .id ==
          null) {
        _showErrorDialog('you should select hazard category');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      img
          ? await Provider.of<HarReport_Manager>(context, listen: false)
              .add_HAR(
              file: Provider.of<HarTextManager>(context, listen: false)
                  .har_report_img,
              eventDate: Provider.of<HarTextManager>(context, listen: false)
                  .event_dateTime
                  .toUtc()
                  .millisecondsSinceEpoch,
              title: Provider.of<TripTextManager>(context, listen: false)
                  .tripdata['title'],
              content: Provider.of<TripTextManager>(context, listen: false)
                  .tripdata['content'],
              locationId: Provider.of<HarTextManager>(context, listen: false)
                  .har_location
                  .id,
              segment: Provider.of<HarTextManager>(context, listen: false)
                  .har_department
                  .id,
              reportType: Provider.of<HarTextManager>(context, listen: false)
                  .har_report_type
                  .id,
              type: Provider.of<HarTextManager>(context, listen: false)
                  .har_report_type_
                  .id,
              likelihood: Provider.of<HarTextManager>(context, listen: false)
                  .har_report_likelihood
                  .id,
              category: Provider.of<HarTextManager>(context, listen: false)
                  .har_report_category
                  .id,
              checklist_list: checklist_list,
              event_severity:
                  Provider.of<HarTextManager>(context, listen: false)
                          .har_report_category
                          .id! *
                      Provider.of<HarTextManager>(context, listen: false)
                          .har_report_likelihood
                          .id!,
            )
              .then((_) {
              Navigator.pop(context);
            }).then((_) {
              Provider.of<HarTextManager>(context, listen: false).clearAll();
              Provider.of<TripTextManager>(context, listen: false).clearAll();
            }).then(
              (value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green[300],
                  content: const Text(
                    'Your REPORT SENT SUCCESSFULLY',
                    style: TextStyle(fontFamily: 'GE-medium'),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              ),
            )
          : await Provider.of<HarReport_Manager>(context, listen: false)
              .add_HAR_withoutImage(
              eventDate: Provider.of<HarTextManager>(context, listen: false)
                  .event_dateTime
                  .toUtc()
                  .millisecondsSinceEpoch,
              title: Provider.of<TripTextManager>(context, listen: false)
                  .tripdata['title'],
              content: Provider.of<TripTextManager>(context, listen: false)
                  .tripdata['content'],
              locationId: Provider.of<HarTextManager>(context, listen: false)
                  .har_location
                  .id,
              segment: Provider.of<HarTextManager>(context, listen: false)
                  .har_department
                  .id,
              reportType: Provider.of<HarTextManager>(context, listen: false)
                  .har_report_type
                  .id,
              type: Provider.of<HarTextManager>(context, listen: false)
                  .har_report_type_
                  .id,
              likelihood: Provider.of<HarTextManager>(context, listen: false)
                  .har_report_likelihood
                  .id,
              category: Provider.of<HarTextManager>(context, listen: false)
                  .har_report_category
                  .id,
              checklist_list: checklist_list,
              event_severity:
                  Provider.of<HarTextManager>(context, listen: false)
                          .har_report_category
                          .id! *
                      Provider.of<HarTextManager>(context, listen: false)
                          .har_report_likelihood
                          .id!,
            )
              .then((_) {
              Navigator.pop(context);
            }).then((_) {
              Provider.of<HarTextManager>(context, listen: false).clearAll();
              Provider.of<TripTextManager>(context, listen: false).clearAll();
            }).then(
              (value) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green[300],
                  content: const Text(
                    'Your REPORT SENT SUCCESSFULLY',
                    style: TextStyle(fontFamily: 'GE-medium'),
                  ),
                  duration: const Duration(seconds: 3),
                ),
              ),
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
      print(error.toString());
      const errorMessage = 'Try again later';
      _showErrorDialog(error.toString());
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return !_isLoading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: size.height * .6,
                child: Consumer<HarReport_Manager>(
                    builder: (context, harReport_manager, child) {
                  return ListView.builder(
                    itemCount: myMap.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        Title(
                          text:
                              uniquelist[index].classificationGroup!.toString(),
                        ),
                        ItemCheckList(
                            // image: 'assets/images/tyre.png',
                            column: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: myMap.entries
                                    .elementAt(index)
                                    .value
                                    .map<Widget>(
                                      (e) => Row(
                                        children: [
                                          Text(
                                            e.classificationName!.toString(),
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily:
                                                  'AraHamah1964R-Regular',
                                              color: Colors.black,
                                            ),
                                          ),
                                          const Spacer(),
                                          checklist[e.classificationName!
                                                  .toString()]!
                                              ? InkWell(
                                                  onTap: () => setState(() {
                                                    checklist[e
                                                        .classificationName!
                                                        .toString()] = false;
                                                  }),
                                                  child: const Icon(
                                                      Icons.check_box,
                                                      color: Colors.blue),
                                                )
                                              : InkWell(
                                                  onTap: () => setState(() {
                                                    checklist[e
                                                        .classificationName!
                                                        .toString()] = true;
                                                  }),
                                                  child: const Icon(
                                                      Icons
                                                          .check_box_outline_blank_outlined,
                                                      color: Colors.grey),
                                                )
                                        ],
                                      ),
                                    )
                                    .toList()))
                      ]);
                    },
                  );
                }),
              ),
              // const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: senergyColorg, // background
                  onPrimary: Colors.white, // foreground
                ),
                onPressed: () {
                  Provider.of<HarTextManager>(context, listen: false)
                              .har_report_img !=
                          null
                      ? _submit(true)
                      : _submit(false);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'AraHamah1964R-Bold'),
                    )
                  ],
                ),
              )
            ],
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
            hintStyle: const TextStyle(fontFamily: 'GE-light', fontSize: 20),
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
    // this.image,
  }) : super(key: key);
  final column;
  // final image;
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
            // leading: Image.asset(
            //   image,
            //   fit: BoxFit.fill,
            //   // width: double.infinity,
            // ),
            // trailing: const Icon(Icons.done, color: Colors.green),
            // 'assets/images/tyre.png'
          ),
        ),
      ),
    );
  }
}
