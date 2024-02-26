import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pakistan_solar_market/screens/login_screens.dart';

import 'myDrawer.dart';

class DashboardScreen extends StatefulWidget {
  final String? userName;

  const DashboardScreen({Key? key, this.userName}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int totalUsers = 0;
  int totalNews = 0;
  late String userName;
  SharedPreferences? prefs;
  bool isExpanded = false;

  int totalUserPanelPosts = 0;
  int totalUserInverterPosts = 0;
  static User? user = FirebaseAuth.instance.currentUser;
  String currentUserId = user?.uid ?? '';
  List<Map<String, dynamic>> userList = [];

  @override
  void initState() {
    super.initState();

    userName = widget.userName.toString();
    // Retrieve stored userName
    getUserName();
    fetchNews();
    fetchUser();
    fetchData();
  }

  void getUserName() async {
    prefs = await SharedPreferences.getInstance();
    String? storedUserName = prefs!.getString('userName');
    if (storedUserName != null) {
      setState(() {
        userName = storedUserName;
        print("This is username: ${userName}");
      });
    }
  }

  String imagePath = '';

  Future<void> fetchNews() async {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('Blog');

    databaseReference.onValue.listen((event) {
      if (event.snapshot.value != null) {
        if (event.snapshot.value is Map) {
          totalNews = (event.snapshot.value as Map).length;
          print('Total News Count: $totalNews');
        }
      } else {
        print('No News Found');
      }
    });
  }

  Future<void> fetchUser() async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');

    QuerySnapshot usersSnapshot =
        await usersCollection.orderBy('fullName', descending: true).get();
    setState(() {
      totalUsers = usersSnapshot.size;
      print("THis is totalUsers: ${totalUsers}");
    });

    usersSnapshot.docs.forEach((doc) {
      Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

      if (userData != null) {
        userList.add({
          'fullName': userData['fullName'],
          'image': userData['image'],
          'phone': userData['phone'],
        });
        userList = userList.take(5).toList();
      }
    });
  }

  Future<void> fetchData() async {
    String userUID = currentUserId;

    if (userUID != null) {
      CollectionReference postsCollection =
          FirebaseFirestore.instance.collection('posts');

      QuerySnapshot postsSnapshot = await postsCollection.get();

      postsSnapshot.docs.forEach((postDoc) async {
        String postID = postDoc.id;

        CollectionReference userPanelPostsCollection =
            postsCollection.doc(postID).collection('userPanelPosts');

        QuerySnapshot userPanelPostsSnapshot =
            await userPanelPostsCollection.get();

        setState(() {
          totalUserPanelPosts += userPanelPostsSnapshot.size;
        });

        CollectionReference userInverterPostsCollection =
            postsCollection.doc(postID).collection('userinverterposts');

        QuerySnapshot userInverterPostsSnapshot =
            await userInverterPostsCollection.get();

        setState(() {
          totalUserInverterPosts += userInverterPostsSnapshot.size;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MyDrawer(),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Admin: ${userName}",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              onPressed: () {
                                prefs!.clear();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()));
                              },
                              icon: Icon(
                                Icons.logout,
                                size: 20,
                              ))
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .2,
                              height: MediaQuery.sizeOf(context).height * .22,
                              child: Card(
                                color: Colors.red,
                                child: Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.account_circle,
                                            size: 20.0,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            "Total Users",
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 16.0,
                                      ),
                                      Text(
                                        totalUsers.toString(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .2,
                              height: MediaQuery.sizeOf(context).height * .22,
                              child: Card(
                                color: Colors.yellow,
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.photo,
                                            size: 20.0,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10.0,
                                          ),
                                          Text(
                                            "Total Posts",
                                            style: TextStyle(
                                              fontSize: 26.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Expanded(
                                        // Move the Expanded here
                                        child: Text(
                                          '${totalUserPanelPosts + totalUserInverterPosts}',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * .2,
                              height: MediaQuery.sizeOf(context).height * .22,
                              child: Card(
                                color: Colors.blue,
                                child: Padding(
                                  padding: EdgeInsets.all(18.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.newspaper,
                                              size: 20.0,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10.0,
                                            ),
                                            Text(
                                              "Total News",
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.0,
                                      ),
                                      Text(
                                        "${totalNews}",
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity * .4,
                      height: 100,
                      child: Card(
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Profile",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                "Name",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              Text(
                                "Phone Number",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.sizeOf(context).height,
                      child: ListView.builder(
                        itemCount: userList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    if (userList[index]['image'] != null &&
                                        userList[index]['image'] != '')
                                      Container(
                                        width: 50,
                                        height: 50,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                '${userList[index]['image']}'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      )
                                    else
                                      Text("No Image"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    if (userList[index]['fullName'] != null &&
                                        userList[index]['fullName'] != '')
                                      Text(
                                        userList[index]['fullName'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      )
                                    else
                                      Text("No Name"),
                                  ],
                                ),
                                Column(
                                  children: [
                                    if (userList[index]['phone'] != null &&
                                        userList[index]['phone'] != '')
                                      Text(
                                        userList[index]['phone'],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      )
                                    else
                                      Text("No Phone number"),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadImage(String imageUrl) {
    try {
      return Image.network(
        imageUrl,
        width: 40,
        height: 40,
      );
    } catch (e) {
      print("Error loading image: $e");
      // Return a placeholder or default image in case of an error
      return Image.network(
          "https://media.istockphoto.com/id/1476002333/photo/handsome-smiling-african-american-guy-standing-near-window-at-home.webp?b=1&s=170667a&w=0&k=20&c=zsERX7Yr3de5qfbDGpLGCwqAg_bfth4-1c9ZzlBqV6o="); // Replace with your placeholder image
    }
  }
}
