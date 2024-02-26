import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pakistan_solar_market/screens/myDrawer.dart';
import 'package:pakistan_solar_market/screens/update_company_profile.dart';

class CompanyVerifications extends StatefulWidget {
  @override
  _CompanyVerificationsState createState() => _CompanyVerificationsState();
}

class _CompanyVerificationsState extends State<CompanyVerifications> {
  List<String> phoneNumbers = [];
  List<Map<String, dynamic>> companyDataList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCompanyData();
  }

  Future<void> fetchCompanyData() async {
    CollectionReference profileCollections =
        FirebaseFirestore.instance.collection('userprofileverification');

    try {
      QuerySnapshot profileSnapshot = await profileCollections.get();

      for (QueryDocumentSnapshot postDoc in profileSnapshot.docs) {
        Map<String, dynamic> data = postDoc.data() as Map<String, dynamic>;

        String phoneNumber = postDoc.id;
        print(phoneNumber);
        phoneNumbers.add(phoneNumber);

        companyDataList.add(data);
      }
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Row(
        children: [
          MyDrawer(),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Company Profile",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height -
                              kToolbarHeight,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: companyDataList.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> companyData =
                                    companyDataList[index];

                                String phoneNumber = phoneNumbers[index];

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 50, right: 50),
                                      child: Card(
                                        color: Color(0xff034d17),
                                        elevation: 5,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20, right: 20, top: 20),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Text(
                                                    "Phone Number: ${phoneNumber}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    "Company Name: ${companyData['company_name']}",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 20),
                                                  ),

                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Account Number: ${companyData['account_number']}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  "Bank Name: ${companyData['bank_name']}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),


                                            SizedBox(
                                              height: 15,
                                            ),
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                             children: [
                                               Text(
                                                 "Company Location: ${companyData['company_location']}",
                                                 style: TextStyle(
                                                     color: Colors.white,
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 20),
                                               ),
                                               Text(
                                                 "Company NTN: ${companyData['company_ntn']}",
                                                 style: TextStyle(
                                                     color: Colors.white,
                                                     fontWeight: FontWeight.bold,
                                                     fontSize: 20),
                                               ),
                                             ],
                                           ),
                                            SizedBox(
                                              height: 15,
                                            ),


                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [

                                                Text(
                                                  "IBAN: ${companyData['iban']}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  "Verified: ${companyData['verified']}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),

                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "CNIC BACK IMAGE",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          ),
                                                  child: Image.network(
                                                    companyData[
                                                        'cnic_back_image'],
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "CNIC Front IMAGE",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20,
                                                          right: 20,
                                                          ),
                                                  child: Image.network(
                                                    companyData[
                                                        'cnic_front_image'],
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Deposit Slip",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 40),
                                                  child: Image.network(
                                                    companyData['deposit_slip'],
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateCompanyProfileScreen(
                                                      phoneNumber: phoneNumber,
                                                      companyData: companyDataList[
                                                          index], // Pass a single companyData Map
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Text("Edit",
                                                  style: TextStyle(
                                                          color: Colors.amber)),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                )
        ],
      ),
    ));
  }
}
