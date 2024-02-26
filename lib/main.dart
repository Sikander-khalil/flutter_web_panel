import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';

import 'package:image_picker_web/image_picker_web.dart';
import 'package:pakistan_solar_market/screens/dasboard_screen.dart';
import 'package:pakistan_solar_market/screens/login_screens.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:pakistan_solar_market/screens/add_china_rate.dart';
import 'package:pakistan_solar_market/screens/add_news.dart';
import 'package:pakistan_solar_market/screens/china_screen.dart';
import 'package:pakistan_solar_market/screens/company_verifications.dart';
import 'package:pakistan_solar_market/screens/myDrawer.dart';
import 'package:pakistan_solar_market/screens/update_news.dart';
import 'package:pakistan_solar_market/screens/user_posts.dart';

const showSnackBar = false;
const expandChildrenOnReady = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyC12obJrFHH2Pw_iCjYj0N5ovEi50BwPGE',
    appId: '1:514346852169:web:6197bb7feb4475cebd4498',
    messagingSenderId: '514346852169',
    projectId: 'paksolarmarkt',
    authDomain: 'paksolarmarkt.firebaseapp.com',
    databaseURL: 'https://paksolarmarkt-default-rtdb.firebaseio.com',
    // IMPORTANT!
    storageBucket: 'paksolarmarkt.appspot.com',
    measurementId: 'G-F75N5S1JWG',
  ));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {PointerDeviceKind.mouse},
      ),
      title: 'Pakistan Solar Market',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
       home: isLoggedIn ? DashboardScreen() : LoginScreen(),

     // home: UserPostsList(),

    );
  }
}






