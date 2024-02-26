import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import 'myDrawer.dart';

class AddNews extends StatefulWidget {
  const AddNews({super.key});

  @override
  State<AddNews> createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {
  bool isExpanded = false;

  TextEditingController newsTitle = TextEditingController();
  TextEditingController descController = TextEditingController();
  final _dateController = TextEditingController();
  final int maxCharacters = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        MyDrawer(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Text(
                      "Add News",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100, right: 100),
                      child: TextFormField(
                        controller: newsTitle,
                        decoration: InputDecoration(
                            hintText: 'Enter News Title',
                            border: OutlineInputBorder()),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter news title.';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100, right: 100),
                      child: Container(
                        height: 150,
                        child: TextField(
                          controller: descController,
                          decoration: InputDecoration(
                            hintText: "Enter Description",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal:
                                    12.0), // Adjust padding inside the border
                          ),
                          keyboardType: TextInputType.multiline,
                          maxLines: 100,
                          maxLength: maxCharacters,
                          onChanged: (text) {
                            if (text.length > maxCharacters) {
                              descController.text =
                                  text.substring(0, maxCharacters);

                              descController.selection =
                                  TextSelection.collapsed(
                                      offset: maxCharacters);
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100, right: 100),
                      child: TextFormField(
                        controller: _dateController,
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
                              _dateController.text =
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
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          String title = newsTitle.text.trim();
                          String description = descController.text.trim();

                          String date = _dateController.text.trim();

                          if (title.isNotEmpty &&
                              description.isNotEmpty &&
                              date.isNotEmpty) {
                            ProgressDialog progressDialog = ProgressDialog(
                              context,
                              title: const Text(
                                'Adding News',
                                style: TextStyle(color: Colors.black),
                              ),
                              message: const Text(
                                'Please wait',
                                style: TextStyle(color: Colors.black),
                              ),
                              backgroundColor: Colors.white,
                            );
                            try {
                              progressDialog.show();

                              String id = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();

                              DatabaseReference databaseReference =
                                  FirebaseDatabase.instance
                                      .reference()
                                      .child('Blog')
                                      .child(id);

                              databaseReference.set({
                                'newsTitle': title,
                                'newsDescription': description,
                                'date': date
                              });

                              progressDialog.dismiss();

                              var snackBar =
                                  SnackBar(content: Text('Adding News'));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              newsTitle.clear();
                              descController.clear();
                              _dateController.clear();
                            } catch (e) {
                              throw e.toString();
                            }
                          }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
