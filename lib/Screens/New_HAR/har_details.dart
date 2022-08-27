import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
            ? Center(
                child: LoadingAnimationWidget.twistingDots(
                  leftDotColor: const Color(0xFF1A1A3F),
                  rightDotColor: const Color(0xFFEA3799),
                  size: 50,
                ),
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
