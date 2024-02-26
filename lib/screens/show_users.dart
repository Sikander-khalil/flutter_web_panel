import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'myDrawer.dart';

class ShowUsers extends StatefulWidget {
  const ShowUsers({Key? key}) : super(key: key);

  @override
  State<ShowUsers> createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers> {
  late Future<List<Map<String, dynamic>>> futureUserList;

  @override
  void initState() {
    super.initState();
    futureUserList = fetchUser();
  }

  Future<List<Map<String, dynamic>>> fetchUser() async {
    CollectionReference usersCollection =
    FirebaseFirestore.instance.collection('users');

    QuerySnapshot usersSnapshot = await usersCollection.get();

    List<Map<String, dynamic>> userList = [];

    usersSnapshot.docs.forEach((doc) {
      Map<String, dynamic>? userData = doc.data() as Map<String, dynamic>?;

      if (userData != null) {
        userList.add({
          'fullName': userData['fullName'],
          'image': userData['image'],
          'phone': userData['phone'],
        });
      }
    });

    return userList;
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Text(
                            "Total Users",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: MediaQuery.of(context).size.height,
                            child: FutureBuilder<List<Map<String, dynamic>>>(
                              future: futureUserList,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                    child: Text('No data available.'),
                                  );
                                } else {
                                  return ListView.builder(
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                if (snapshot.data![index]
                                                ['image'] !=
                                                    null &&
                                                    snapshot.data![index]
                                                    ['image'] !=
                                                        '')
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    margin: EdgeInsets.symmetric(
                                                        vertical: 10.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            '${snapshot.data![index]['image']}'),
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
                                                if (snapshot.data![index]
                                                ['fullName'] !=
                                                    null &&
                                                    snapshot.data![index]
                                                    ['fullName'] !=
                                                        '')
                                                  Text(
                                                    snapshot.data![index]
                                                    ['fullName'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18),
                                                  )
                                                else
                                                  Text("No Name"),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                if (snapshot.data![index]['phone'] !=
                                                    null &&
                                                    snapshot.data![index]
                                                    ['phone'] !=
                                                        '')
                                                  Text(
                                                    snapshot.data![index]['phone'],
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 18),
                                                  )
                                                else
                                                  Text("No Phone number"),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
