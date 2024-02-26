import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'package:pakistan_solar_market/screens/myDrawer.dart';

class UpdateCompanyProfileScreen extends StatefulWidget {
  final String phoneNumber;
  final Map<String, dynamic> companyData;

  UpdateCompanyProfileScreen(
      {required this.phoneNumber, required this.companyData});

  @override
  _UpdateCompanyProfileScreenState createState() =>
      _UpdateCompanyProfileScreenState();
}

class _UpdateCompanyProfileScreenState
    extends State<UpdateCompanyProfileScreen> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController companyLocationController =
      TextEditingController();

  static List<String> approved = [
    "true",
    "false",
  ];
  late String _currentSelectedValue;
  final TextEditingController companyNTNController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();

  Uint8List? depositImage;

  Uint8List? frontImage;

  Uint8List? backImage;

  Future<void> _pickImageForDeposit() async {
    try {
      final pickedFile = await ImagePickerWeb.getImageInfo;

      if (pickedFile != null) {
        setState(() {
          depositImage = pickedFile.data;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _pickImageForFront() async {
    try {
      final pickedFile = await ImagePickerWeb.getImageInfo;

      if (pickedFile != null) {
        setState(() {
          frontImage = pickedFile.data;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _pickImageForback() async {
    try {
      final pickedFile = await ImagePickerWeb.getImageInfo;

      if (pickedFile != null) {
        setState(() {
          backImage = pickedFile.data;
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _uploadImageForDeposit() async {
    if (depositImage != null) {
      await uploadFilefordeposit(depositImage!);
    }
  }

  Future<void> _uploadImageForFront() async {
    if (frontImage != null) {
      await uploadFileForfront(frontImage!);
    }
  }

  Future<void> _uploadImageForback() async {
    if (backImage != null) {
      await uploadFileForback(backImage!);
    }
  }


  Future<void> uploadFilefordeposit(Uint8List fileBytes) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference = storage.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putData(fileBytes);
      TaskSnapshot storageTaskSnapshot = await uploadTask;
     String  depositImageUrl = await storageTaskSnapshot.ref.getDownloadURL();

      await updateCompanyProfile(depositImageUrl, 'deposit_slip');

      print('Deposit Slip Uploaded');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadFileForfront(Uint8List fileBytes) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference = storage.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putData(fileBytes);
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String frontImageUrl = await storageTaskSnapshot.ref.getDownloadURL();

      await updateCompanyProfile(frontImageUrl, 'cnic_front_image');

      print('CNIC Front Image Uploaded');
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> uploadFileForback(Uint8List fileBytes) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference = storage.ref().child('images/$fileName');
      UploadTask uploadTask = storageReference.putData(fileBytes);
      TaskSnapshot storageTaskSnapshot = await uploadTask;
      String backImageUrl = await storageTaskSnapshot.ref.getDownloadURL();

      await updateCompanyProfile(backImageUrl, 'cnic_back_image');

      print('CNIC Back Image Uploaded');
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();

    companyNameController.text = widget.companyData['company_name'];
    accountNumberController.text = widget.companyData['account_number'];
    bankNameController.text = widget.companyData['bank_name'];
    companyLocationController.text = widget.companyData['company_location'];
    companyNTNController.text = widget.companyData['company_ntn'];
    ibanController.text = widget.companyData['iban'];
    _currentSelectedValue = widget.companyData['verified'].toString();

  }

  Future<void> updateCompanyData() async {
    CollectionReference profileCollections =
    FirebaseFirestore.instance.collection('userprofileverification');

    Map<String, dynamic> updateData = {
      'company_name': companyNameController.text,
      'account_number': accountNumberController.text,
      'bank_name': bankNameController.text,
      'company_location': companyLocationController.text,
      'company_ntn': companyNTNController.text,
      'iban': ibanController.text,
      'verified': (_currentSelectedValue == "true"),
    };




    try {
      await profileCollections.doc(widget.phoneNumber).update(updateData);
      print('Profile Updated');

      var snackBar = SnackBar(content: Text('Profile Update'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      print('Error updating data: $error');
      // Handle error
    }
  }

  Future<void> updateCompanyProfile(String imageUrl, String imageType) async {
    CollectionReference profileCollections =
    FirebaseFirestore.instance.collection('userprofileverification');

    Map<String, dynamic> updateData = {

    };


    if (imageType == 'deposit_slip') {
      updateData['deposit_slip'] = imageUrl;
    } else if (imageType == 'cnic_front_image') {
      updateData['cnic_front_image'] = imageUrl;
    } else if (imageType == 'cnic_back_image') {
      updateData['cnic_back_image'] = imageUrl;
    }

    try {
      await profileCollections.doc(widget.phoneNumber).update(updateData);
      print('Profile Updated');

      var snackBar = SnackBar(content: Text('Profile Update'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      print('Error updating data: $error');
      // Handle error
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            MyDrawer(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        "Update Profile",
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Text("Company Name", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),

                          Container(
                            width: 400,
                            margin: EdgeInsets.only(left: 10),
                            child: TextFormField(
                              controller: companyNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Text("Account Number",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          SizedBox(
                            width: 400,
                            child: TextFormField(

                              controller: accountNumberController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Bank Name",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),

                          Container(
                            width: 400,
                            margin: EdgeInsets.only(left: 40),
                            child: TextFormField(
                              controller: bankNameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Company Location",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            width: 400,
                            margin: EdgeInsets.only(right: 2),
                            child: TextFormField(
                              controller: companyLocationController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Company NTN",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            width: 400,
                            margin: EdgeInsets.only(left: 20),
                            child: TextFormField(
                              controller: companyNTNController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("IBAN",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            width: 400,
                            margin: EdgeInsets.only(left: 80),
                            child: TextFormField(
                              controller: ibanController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Verified", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                          Container(
                            width: 300,

                            child: FormField<String>(
                              builder: (FormFieldState<String> state) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                    hintText: 'Please select expense',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                                  ),
                                  isEmpty: _currentSelectedValue == '',
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _currentSelectedValue,
                                      isDense: true,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _currentSelectedValue = newValue!;
                                          state.didChange(newValue);
                                        });
                                      },
                                      items: approved.map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      style: TextStyle(color: Colors.black), // Set the text color
                                      dropdownColor: Colors.white, // Set the dropdown background color
                                      iconEnabledColor: Colors.black, // Set the dropdown icon color
                                      focusColor: Colors.white, // Set the background color when selected
                                    ),
                                  ),
                                );
                              },
                            ),


                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Deposit Slip",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                          ),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 70),
                                child: depositImage != null
                                    ? Image.memory(
                                        depositImage!,
                                        width: 50,
                                        height: 50,
                                      )
                                    : Image.network(
                                        widget.companyData['deposit_slip'],
                                        width: 50,
                                        height: 50,
                                      ),
                              ),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _pickImageForDeposit();
                                  },
                                  child: CircleAvatar(
                                      radius: 20, child: Icon(Icons.image)),
                                ),
                              )
                            ],
                          ),
                          Container(),
                       Container(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "CNIC Front Image",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                          ),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: frontImage != null
                                      ? Image.memory(
                                          frontImage!,
                                          width: 50,
                                          height: 50,
                                        )
                                      : Image.network(
                                          widget
                                              .companyData['cnic_front_image'],
                                          width: 50,
                                          height: 50,
                                        )),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _pickImageForFront();
                                  },
                                  child: CircleAvatar(
                                      radius: 20, child: Icon(Icons.image)),
                                ),
                              )
                            ],
                          ),
                          Container(),
                          Container(),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "CNIC Back Image",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
                          ),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: backImage != null
                                      ? Image.memory(
                                          backImage!,
                                          width: 50,
                                          height: 50,
                                        )
                                      : Image.network(
                                          widget.companyData['cnic_back_image'],
                                          width: 50,
                                          height: 50,
                                        )),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    _pickImageForback();
                                  },
                                  child: CircleAvatar(
                                      radius: 20, child: Icon(Icons.image)),
                                ),
                              )
                            ],
                          ),
                          Container(),
                          Container(),
                        ],
                      ),
                      SizedBox(height: 15,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                       await updateCompanyData();
                          updateCompanyProfile;
                          await _uploadImageForDeposit();
                          await _uploadImageForback();
                          await _uploadImageForFront();
                        },
                        child: Text(
                          'Update',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
