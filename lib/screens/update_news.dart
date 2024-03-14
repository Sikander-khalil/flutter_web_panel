import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';
import 'package:pakistan_solar_market/screens/myDrawer.dart';
import 'package:pakistan_solar_market/screens/show_news.dart';

class UpdateNews extends StatefulWidget {
  final String title;
  final String description;
  final String confirmDate;

  UpdateNews({
    required this.title,
    required this.description,
    required this.confirmDate,
  });

  @override
  _UpdateNewsState createState() => _UpdateNewsState();
}

class _UpdateNewsState extends State<UpdateNews> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('Blog');

  @override
  void initState() {
    super.initState();

    titleController.text = widget.title;
    descriptionController.text = widget.description;
    dateController.text = widget.confirmDate;
  }

  void _updateNews() {
    _databaseReference
        .orderByChild('newsTitle')
        .equalTo(widget.title)
        .once()
        .then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.snapshot.value as Map;
        var key = values.keys.first;
        _databaseReference.child(key).update({
          'newsTitle': titleController.text,
          'newsDescription': descriptionController.text,
          'date': dateController.text,
        }).then((_) {
          ProgressDialog progressDialog = ProgressDialog(
            context,
            title: const Text(
              'Updating News',
              style: TextStyle(color: Colors.black),
            ),
            message: const Text(
              'Please wait',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor: Colors.white,
          );
          progressDialog.show();

          Future.delayed(Duration(seconds: 2), (){

            progressDialog.dismiss();
            Navigator.push(context, MaterialPageRoute(builder: (context) => BlogScreen()));

          });
          var snackBar = SnackBar(content: Text('Update News'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }).catchError((error) {
          print("Error updating news: $error");
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MyDrawer(),

          Padding(
            padding: const EdgeInsets.only(left: 90, right: 50),
            child: Column(

              children: [
                SizedBox(height: 30),
                Text(
                  "Update News",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "News Title",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    Container(
                        width: 400,
                      margin: EdgeInsets.only(left: 90),
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: 'Enter News Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "News Description",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    Container(
                      width: 400,
                      margin: EdgeInsets.only(left: 40),
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Enter Title Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "News Date",
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                    Container(
                      width: 400,
                      margin: EdgeInsets.only(left: 90),
                      child: TextFormField(
                        controller: dateController,
                        decoration: InputDecoration(
                          hintText: 'Pick Date',
                          border: OutlineInputBorder(),
                        ),
                        onTap: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2015),
                            lastDate: DateTime(2025),
                          ).then((selectedDate) {
                            if (selectedDate != null) {
                              dateController.text =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter date.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: _updateNews,
                  child: Text(
                    'Update News',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
