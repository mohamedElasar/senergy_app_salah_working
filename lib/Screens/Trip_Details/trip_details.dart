import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Navigation/screens.dart';
import 'package:senergy/Screens/Trip_Details/trip_checklist.dart';
import 'package:senergy/Screens/Trip_Details/trip_form.dart';
import 'package:senergy/managers/app_state_manager.dart';
import 'package:senergy/managers/trip_manager.dart';
import 'package:senergy/managers/trip_text_manager.dart';

import '../../constants.dart';

class TripDetails extends StatefulWidget {
  const TripDetails({Key? key}) : super(key: key);
  static MaterialPage page() {
    return MaterialPage(
      name: Senergy_Screens.tripdetails,
      key: ValueKey(Senergy_Screens.tripdetails),
      child: const TripDetails(),
    );
  }

  @override
  State<TripDetails> createState() => _TripDetailsState();
}

class _TripDetailsState extends State<TripDetails> {
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
        TripForm(size: size),
        TripCheckList(size: size),
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
          icon: new Icon(Icons.text_fields), label: 'Details'),
      BottomNavigationBarItem(
        icon: new Icon(Icons.car_repair),
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
        await Provider.of<TripManager>(context, listen: false)
            .get_cars()
            .then((value) =>
                Provider.of<TripManager>(context, listen: false).get_purposes())
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (e) {
        print(e);
      }
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
              'NEW TRIP',
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
                  .gototripdetails(false);
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
