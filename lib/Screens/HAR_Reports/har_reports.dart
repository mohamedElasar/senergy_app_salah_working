import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senergy/Navigation/screens.dart';
import 'package:senergy/constants.dart';
import 'package:senergy/managers/app_state_manager.dart';

import 'har_reports_original.dart';

// ignore: must_be_immutable
class HarReports extends StatefulWidget {
  final bool? isadmin;
  final bool? mine;

  static MaterialPage page({required bool isadmin}) {
    return MaterialPage(
      name: Senergy_Screens.harreports,
      key: ValueKey(Senergy_Screens.mytrips),
      child: HarReports(isadmin: isadmin),
    );
  }

  HarReports({Key? key, this.isadmin, this.mine}) : super(key: key);

  @override
  State<HarReports> createState() => _MyTripsState();
}

class _MyTripsState extends State<HarReports> {
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
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        HarReportsView(mine: true),
        HarReportsView(mine: false),
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

  // List<BottomNavigationBarItem> buildBottomNavBarItems() {
  //   return [
  //     BottomNavigationBarItem(
  //         icon: new Icon(Icons.text_fields), label: 'Details'),
  //     BottomNavigationBarItem(
  //       icon: new Icon(Icons.car_repair),
  //       label: 'Check List',
  //     ),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          title: const Center(
            // child: widget.isadmin!
            //  const Text(
            //       'All Trips',
            //       style: TextStyle(
            //           fontSize: 40,
            //           fontWeight: FontWeight.bold,
            //           fontFamily: 'AraHamah1964B-Bold',
            //           color: senergyColorb),
            //     )
            //   :
            child: Text(
              'HARS',
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
                  .gotomyharReports(false);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: buildPageView(size),
        bottomNavigationBar: BottomNavyBar(
          onItemSelected: (index) {
            bottomTapped(index);
          },
          selectedIndex: bottomSelectedIndex,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                title: Text('MY Reports'),
                icon: Icon(Icons.account_circle_rounded),
                activeColor: senergyColorg),
            BottomNavyBarItem(
                title: Text('All REPORTS'),
                icon: Icon(Icons.format_list_bulleted),
                activeColor: senergyColorb),
          ],
        ),
      ),
    );
  }
}
