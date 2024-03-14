import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import 'package:pakistan_solar_market/screens/myDrawer.dart';
import 'package:pakistan_solar_market/screens/user_posts.dart';



class AddAdminPostScreen extends StatefulWidget {
  const AddAdminPostScreen({super.key});

  @override
  State<AddAdminPostScreen> createState() => _AddAdminPostScreenState();
}

class _AddAdminPostScreenState extends State<AddAdminPostScreen>
    with SingleTickerProviderStateMixin {
  String _noselected = 'No item selected';

  String _selectedValue = '';

  String _selectedValue2 = '';
  String? day;
  String? month;
  String? year;

  Map<String, List<String>> _DropdownValues = {
    'Longi Himo 5': ['555', '560'],
    'Longi Himo 6': ['570', '575', '580', '585'],
    'Jinko P-Type': ['550', '555'],
    'Jinko N-Type': ['575', '580'],
    'Jinko N-Type Bi-Facial': ['580', '575'],
    'JA': ['545', '550', '555'],
    'JA Bi-Facial': ['545', '550', '555'],
    'Canadian P-type': ['550', '555'],
    'Canadian N-type Bi-Facial Topcon': ['570', '575'],
  };

  User? user = FirebaseAuth.instance.currentUser;

  String subcategoryPrefix = '';

  String invertersubcategoryPrefix = '';

  String _selectedSize = '';

  String _selectedLocation = '';
  final TextEditingController userNameController = TextEditingController();

  TextEditingController numberController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final TextEditingController soldController = TextEditingController();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late List<String> _availability;
  late String _selectedValue3;
  late DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    _availability = ["Ready Stock", "Availability"];
    _selectedValue3 = "";
    _selectedDate = null;
  }

  var _type = ["Buyer", "Seller"];

  var _size = ["Cont", "Pallets"];

  var _locations = ["Ex-LHR", "EX-KHI", "EX-FSD", "EX-GWJ", "EX-MULTA"];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Row(
            children: [
              MyDrawer(),
              Expanded(
                child: BuildPanelData(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BuildPanelData() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text("Add Admin Post", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontSize: 19),),
              ],
            ),
            SizedBox(height: 15,),

            ListTile(title: Padding(
              padding: const EdgeInsets.only(left: 100),
              child: Text("Name", style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),),
            ),

            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10, left: 100, right: 100),
              child: TextFormField(
                controller: userNameController,
                decoration: InputDecoration(
                  hintText: "Enter Your Name",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ),
            SizedBox(height: 15,),



            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      "TYPE",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Container(
                        height: 60,
                        child: DropdownButtonFormField<String>(
                          items: _type.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Row(
                                children: <Widget>[
                                  Text(category),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedValue2 = newValue!;
                            });
                          },
                          value: _selectedValue2.isNotEmpty
                              ? _selectedValue2
                              : null,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: 'Select Type',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                    child: ListTile(
                  title: Text(
                    "NAME",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Container(
                    width: 290,
                    height: 55,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        TextFormField(
                          controller: TextEditingController(
                            text: '$_noselected | $_selectedValue',
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText:
                                'Enter your text', // Optional placeholder text

                            // You can add other InputDecoration properties here
                          ),
                        ),
                        Positioned(
                          right: 10,
                          child: DropdownButton<String>(
                            underline: Container(
                              height: 0,
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _noselected =
                                      newValue; // Update selected Subcategory
                                  _selectedValue = _DropdownValues[newValue] !=
                                              null &&
                                          _DropdownValues[newValue]!.isNotEmpty
                                      ? _DropdownValues[newValue]![0]
                                      : '';
                                });
                              }
                            },
                            items: _DropdownValues.keys.map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      _noselected =
                                          item; // Update selected Subcategory on tap
                                    });

                                    if (_noselected.isNotEmpty) {
                                      Navigator.pop(context);
                                    }

                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 200,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              children: _DropdownValues[item]!
                                                  .map((String value) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ListTile(
                                                    title: Text(value),
                                                    onTap: () {
                                                      setState(() {
                                                        _selectedValue = value;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),

            SizedBox(
              height: 5,
            ),

            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'NUMBER',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Container(
                        height: 60,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: numberController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: ' Enter No',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      'SIZE',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 60,
                        child: DropdownButtonFormField<String>(
                          items: _size.map((String size) {
                            return DropdownMenuItem<String>(
                              value: size,
                              child: Row(
                                children: <Widget>[
                                  Text(size),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSize = newValue!;
                            });
                          },
                          value:
                              _selectedSize.isNotEmpty ? _selectedSize : null,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: 'Select Size',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'PRICE IN RS',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10),
                      child: Container(
                        height: 60,
                        child: TextFormField(
                          controller: priceController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            hintText: 'Enter Price',
                          ),
                          validator: (value) {
                            if (double.tryParse(value!) == null ||
                                double.parse(value) <= 45) {
                              return 'Price should be a number greater than 45';
                            }
                            return null;
                          },
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      'LOCATION',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        height: 60,
                        child: DropdownButtonFormField<String>(
                          items: _locations.map((String category) {
                            return DropdownMenuItem<String>(
                              value: category,
                              child: Row(
                                children: <Widget>[
                                  Text(category),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedLocation = newValue!;
                            });
                          },
                          value: _selectedLocation.isNotEmpty
                              ? _selectedLocation
                              : null,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: ' Locations',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),

            Row(
              children: [
                Expanded(
                    child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "AVAILABILITY",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Container(
                      height: 70,
                      width: 290,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            items: _availability.map((String category) {
                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _selectedValue3 = newValue!;
                                if (_selectedValue3 == "Availability") {
                                  _showDatePicker(context);
                                }
                              });
                            },
                            value: _selectedValue3.isNotEmpty
                                ? _selectedValue3
                                : null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding:
                                  EdgeInsets.fromLTRB(10, 20, 10, 20),
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Select Availability',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
                Expanded(
                    child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text("Enter Sold",
                      style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                    child: Container(
                      height: 70,
                      width: 290,
                  child: TextFormField(
                        controller: soldController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),

                ))
              ],
            ),

            SizedBox(
              height: 15,
            ),
            _selectedDate != null
                ? Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      _getFormattedDate(_selectedDate!),
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  )
                : Container(), // Show the selected date separately
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  child: MaterialButton(
                      color: Colors.green,
                      // Inside the onPressed method of the MaterialButton
                      onPressed: () {
                        postingData();
                      },
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  String _getFormattedDate(DateTime date) {
    day = _getTwoDigitFormat(date.day);
    month = _getTwoDigitFormat(date.month);
    year = date.year
        .toString()
        .substring(2); // Extract last two digits of the year

    return "$day:$month:$year";
  }

  String _getTwoDigitFormat(int value) {
    return value.toString().padLeft(2, '0');
  }
  var random = Random();

  String generateCustomId() {
    const String chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    const int idLength = 20; // You can adjust the length as needed
    String customId = '';

    for (int i = 0; i < idLength; i++) {
      customId += chars[Random().nextInt(chars.length)];
    }

    return customId;
  }

  void postingData() {
    bool isSold = soldController.text.toLowerCase() == 'true';

    String phoneNumber = "+923114376818";

    String customId = generateCustomId();

    String subCatValue =
        '$_noselected | $_selectedValue';
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yy-MM-dd').format(now);
    String formattedTime = DateFormat('HH:mm').format(now);

    FirebaseFirestore.instance
        .collection('posts')
        .doc(phoneNumber)
        .collection('userPanelPosts')
        .doc(customId)
        .set({
      'Available': _selectedDate != null ? '${day}-${month}-${year}' :  _selectedValue3,
      'Location': _selectedLocation,
      'Name': userNameController.text,
      'Number': numberController.text,
      'Price': priceController.text,
      'Size': _selectedSize,
      'mainDocId': customId,
      'phoneno': phoneNumber,
      'SubCategories': subCatValue,
      'Type': _selectedValue2,
      'posted_at': formattedDate,
      'posted_time': formattedTime,
      'sold': isSold,



    }).then((_) {

      ProgressDialog progressDialog = ProgressDialog(
        context,
        title: const Text(
          'Adding Post',
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => UserPostsList()));

      });

      var snackBar = SnackBar(content: Text('Add Post'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

    }).catchError((error) {
      throw error.toString();
    });
  }
}
