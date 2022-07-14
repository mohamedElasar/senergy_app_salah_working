import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Navigation/screens.dart';
import 'package:senergy/Screens/New_HAR/har_form2.dart';
import 'package:senergy/managers/Har_report_requ.dart';
import 'package:senergy/managers/trip_text_manager.dart';
import '../../managers/har_text_manager.dart';
import './har_checklist.dart';
import './har_form.dart';
import 'package:senergy/managers/app_state_manager.dart';

import '../../constants.dart';

class HarDetails extends StatefulWidget {
  const HarDetails({Key? key}) : super(key: key);
  static MaterialPage page() {
    return MaterialPage(
      name: Senergy_Screens.hardetails,
      key: ValueKey(Senergy_Screens.hardetails),
      child: const HarDetails(),
    );
  }

  @override
  State<HarDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<HarDetails> {
  int bottomSelectedIndex = 0;
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  Widget buildPageView(size) {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HarForm(size: size),
        HarForm2(size: size),
        HarChecklist(size: size),
      ],
    );
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          // activeIcon: Icon(
          //   Icons.text_fields,
          //   color: Colors.amber,
          // ),
          icon: new Icon(Icons.text_fields),
          label: 'Details'),
      BottomNavigationBarItem(icon: new Icon(Icons.list), label: 'Drop Down'),
      BottomNavigationBarItem(
        icon: new Icon(Icons.check_box),
        label: 'Check List',
      ),
    ];
  }

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
    Future.delayed(Duration.zero, () async {
      try {
        await Provider.of<HarReport_Manager>(context, listen: false)
            .get_har_report_requirments()
            // .then((_) => Provider.of<HarReport_Manager>(context, listen: false)
            //     .get_har_department())
            // .then((_) => Provider.of<HarReport_Manager>(context, listen: false)
            //     .get_har_likelihood())
            // .then((_) => Provider.of<HarReport_Manager>(context, listen: false)
            //     .get_har_locations())
            // .then((_) => Provider.of<HarReport_Manager>(context, listen: false)
            //     .get_har_report_types_())
            // .then((_) => Provider.of<HarReport_Manager>(context, listen: false)
            //     .get_har_severity())
            // .then((_) => Provider.of<HarReport_Manager>(context, listen: false)
            //     .get_har_types())
            // .then((_) => Provider.of<HarReport_Manager>(context, listen: false)
            //     .get_classificationGroups())
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (e) {}
      if (!mounted) return;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Center(
            child: Text(
              'NEW QHSE',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'AraHamah1964B-Bold',
                  color: senergyColorb),
            ),
          ),
          elevation: 2,
          leading: InkWell(
            onTap: () {
              Provider.of<AppStateManager>(context, listen: false)
                  .gotohardetails(false);
              Provider.of<HarTextManager>(context, listen: false).clearAll();
              Provider.of<TripTextManager>(context, listen: false).clearAll();
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : buildPageView(size),
        bottomNavigationBar: BottomNavigationBar(
          // selectedItemColor: senergyColorg.withOpacity(.5),
          onTap: (index) {
            bottomTapped(index);
          },
          currentIndex: bottomSelectedIndex,
          items: buildBottomNavBarItems(),
        ),
      ),
    );
  }
}






// class TripTopPage extends StatelessWidget {
//   const TripTopPage({Key? key, required this.size}) : super(key: key);
//   final Size size;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       height: size.height * .1,
//       width: size.width,
//       padding: EdgeInsets.symmetric(horizontal: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           InkWell(
//             onTap: () {
//               Provider.of<AppStateManager>(context, listen: false)
//                   .gototripdetails(false);
//             },
//             child: const Icon(
//               Icons.arrow_back,
//               size: 30,
//             ),
//           ),
//           const Text(
//             'NEW TRIP',
//             style: TextStyle(
//                 fontSize: 40,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'AraHamah1964B-Bold',
//                 color: senergyColorb),
//           ),
//           InkWell(
//             onTap: () async {
//               // await showSearch(context: context, delegate: StudentSearch());
//             },
//             child: Row(
//               children: const [
//                 Text(
//                   '',
//                   style: TextStyle(
//                       fontFamily: 'GE-light',
//                       color: Colors.black87,
//                       fontSize: 20),
//                 ),
//                 Text('')
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
