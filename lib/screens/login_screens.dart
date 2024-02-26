import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pakistan_solar_market/screens/dasboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userName = 'admin_pakistan_solar_market.pk';
  String password = '12345678';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getfromLogin();
  }

  // void getfromLogin() async {
  //   DatabaseReference databaseReference =
  //       FirebaseDatabase.instance.reference().child('adminlogin');
  //
  //   databaseReference.once().then((DatabaseEvent snapshot) {
  //     if (snapshot.snapshot.value != null) {
  //       Map<dynamic, dynamic> values = snapshot.snapshot.value as Map;
  //
  //       userName =
  //           values['userName'] != null ? values['userName'].toString() : '';
  //       password =
  //           values['password'] != null ? values['password'].toString() : '';
  //     }
  //   });
  // }

  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  void _login() async {
    String enteredUserName = userNameController.text.trim();
    String enteredPassword = passController.text.trim();

    if (enteredUserName == userName && enteredPassword == password) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      prefs.setString('userName', enteredUserName); // Store userName

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(userName: enteredUserName),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please Enter Valid userName, Password',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.cover,
                width: 200,
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 200.0, right: 200),
                child: TextFormField(
                  controller: userNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter Your User Name',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 200.0, right: 200),
                child: TextFormField(
                  controller: passController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Enter Your password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 330,
                height: 40,
                child: MaterialButton(
                  color: Colors.green,
                  onPressed: _login,
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
