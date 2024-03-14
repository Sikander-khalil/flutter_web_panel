import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pakistan_solar_market/screens/add_admin_post.dart';
import 'package:pakistan_solar_market/screens/add_china_rate.dart';

import 'package:pakistan_solar_market/screens/china_screen.dart';
import 'package:pakistan_solar_market/screens/company_verifications.dart';
import 'package:pakistan_solar_market/screens/dasboard_screen.dart';
import 'package:pakistan_solar_market/screens/show_news.dart';
import 'package:pakistan_solar_market/screens/show_users.dart';
import 'package:pakistan_solar_market/screens/user_posts.dart';

import 'add_news.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
        extended: true,
        backgroundColor: Colors.black,
        unselectedIconTheme:
            const IconThemeData(color: Colors.white, opacity: 1),
        unselectedLabelTextStyle: const TextStyle(
          color: Colors.white,
        ),
        selectedLabelTextStyle: TextStyle(color: Colors.white),
        selectedIconTheme: IconThemeData(color: Colors.black),
        destinations: [
          NavigationRailDestination(
            icon: InkWell(
                onTap: () {
                  updateIndex(0);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardScreen()));
                },
                child: Icon(Icons.home)),
            label: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()));
              },
              child: Text(
                "Home",
              ),
            ),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.newspaper),
            label: Container(
              width: 150,
              child: PopupSubMenuItem<String>(
                title: 'News',
                items: ['Add News', 'Show News'],
                onSelected: (value) {
                  updateIndex(1);
                  if (value == 'Add News') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddNews()));
                  } else if (value == 'Show News') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => BlogScreen()));
                  }
                },
              ),
            ),
          ),
          NavigationRailDestination(
            icon: InkWell(
                onTap: () {
                  updateIndex(2);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShowUsers()));
                },
                child: Icon(Icons.person)),
            label: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShowUsers()));
                },
                child: Text("Users")),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.price_check),
            label: Container(
              width: 150,
              child: PopupSubMenuItem<String>(
                title: 'China Rates',
                items: ['Add Rates', 'Show Rates'],
                onSelected: (value) {
                  updateIndex(1);
                  if (value == 'Add Rates') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddChina()));
                  } else if (value == 'Show Rates') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ChinaRatesList()));
                  }
                },
              ),
            ),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.post_add),
            label: Container(
              width: 150,
              child: PopupSubMenuItem<String>(
                title: 'User Posts',
                items: ['Add Post', 'Show Posts'],
                onSelected: (value) {
                  updateIndex(4);
                  if (value == 'Add Post') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddAdminPostScreen()));
                  } else if (value == 'Show Posts') {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserPostsList()));
                  }
                },
              ),
            ),
          ),
          NavigationRailDestination(
            icon: InkWell(
                onTap: () {
                  updateIndex(5);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CompanyVerifications()));
                },
                child: Icon(Icons.account_box_outlined)),
            label: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CompanyVerifications()));
              },
              child: Text(
                "Company Profile",
              ),
            ),
          ),
        ],
        selectedIndex: currentIndex);
  }

  void updateIndex(int newIndex) {
    // Method to update the currentIndex and trigger a rebuild
    setState(() {
      currentIndex = newIndex;
    });
  }
}

class PopupSubMenuItem<T> extends PopupMenuEntry<T> {
  const PopupSubMenuItem({
    required this.title,
    required this.items,
    required this.onSelected,
  });

  final String title;
  final List<T> items;
  final Function(T) onSelected;

  @override
  double get height => kMinInteractiveDimension;

  @override
  bool represents(T? value) => false;

  @override
  State createState() => _PopupSubMenuState<T>();
}

class _PopupSubMenuState<T> extends State<PopupSubMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      tooltip: widget.title,
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0, top: 12, bottom: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(color: Colors.white),
              ),
            ),
            Icon(
              Icons.arrow_right,
              size: 24.0,
              color: Colors.white,
            ),
          ],
        ),
      ),

      onSelected: (T value) {

        widget.onSelected.call(value);
      },
      offset: Offset.zero,
      itemBuilder: (BuildContext context) {
        return widget.items
            .map(
              (item) => PopupMenuItem<T>(
                height: 50,
                padding: EdgeInsets.only(left: 50),

                value: item,
                child: Text(item
                    .toString()), //MEthod toString() of class T should be overridden to repesent something meaningful
              ),
            )
            .toList();
      },
    );
  }
}


