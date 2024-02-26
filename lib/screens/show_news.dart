import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pakistan_solar_market/screens/update_news.dart';

import 'myDrawer.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    DatabaseEvent snapshot = await databaseReference.child("Blog").once();
    Map<String, dynamic>? dataMap = snapshot.snapshot.value as Map<String, dynamic>?;

    if (dataMap == null) {
      dataList = [];
    } else {
      dataList = [];
      dataMap.forEach((key, value) {
        if (value is Map) {
          dataList.add(Map<String, dynamic>.from(value));
        }
      });
    }

    setState(() {});
  }
  Future<void> _deleteNews(
      String newsTitle, String newsDescription, String date) async {

    DatabaseReference reference = databaseReference;
    DatabaseEvent dataSnapshot = await databaseReference.child("Blog").once();

    if (dataSnapshot.snapshot.value != null) {
      Map<dynamic, dynamic> values = dataSnapshot.snapshot.value as Map;

      String? keyToDelete;

      values.forEach((key, value) {
        if (value['newsTitle'] == newsTitle &&
            value['newsDescription'] == newsDescription &&
            value['date'] == date) {
          keyToDelete = key;
          return;
        }
      });

      if (keyToDelete != null) {
        await reference.child("Blog").child(keyToDelete!).remove().then((_) {
          print('News deleted successfully');
          fetchData().then((_) {
            setState(() {}); // Move setState inside the fetchData callback
          });
        }).catchError((error) {
          print('Error deleting news: $error');
        });
      } else {
        print('News not found');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Row(

          children: [
            MyDrawer(),
            Expanded(
              child: Column(
                children: [

                  SizedBox(height: 10,),
                  Text("Show News", style: TextStyle(color: Colors.black, fontSize: 20),),
                  SizedBox(height: 10,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        String? newsTitle = dataList[index]['newsTitle'];
                        String? newsDescription = dataList[index]['newsDescription'];
                        String? newsDate = dataList[index]['date'];

                        if (newsTitle != null && newsDescription != null && newsDate != null) {
                          return Card(
                            color: Color(0xff034d17),
                            margin: const EdgeInsets.only(top: 20, left: 60, right: 60),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(newsTitle, style: TextStyle(color: Colors.white, fontSize: 20)),
                                    subtitle: Text(newsDescription, style: TextStyle(color: Colors.white,fontSize: 20)),
                                    trailing: Text(newsDate, style: TextStyle(color: Colors.white,fontSize: 20)),

                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(

                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateNews(title: newsTitle, description: newsDescription, confirmDate: newsDate,)));
                                          },
                                          child: Text("Edit", style: TextStyle(color: Colors.amber,fontSize: 16))),
                                      InkWell(
                                          onTap: (){

                                            _deleteNews(newsTitle, newsDescription,newsDate);

                                          },
                                          child: Text("Delete", style: TextStyle(color: Colors.red,fontSize: 16))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {

                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
    );
  }
}