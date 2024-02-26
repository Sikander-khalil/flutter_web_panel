import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pakistan_solar_market/screens/myDrawer.dart';
import 'package:pakistan_solar_market/screens/updates_rates.dart';

class ChinaRatesList extends StatefulWidget {
  @override
  _ChinaRatesListState createState() => _ChinaRatesListState();
}

class _ChinaRatesListState extends State<ChinaRatesList> {
  Map<String, dynamic> chinaRates = {};

  @override
  void initState() {
    super.initState();
    fetchChinaRates();
  }

  fetchChinaRates() {
    DatabaseReference databaseReference =
    FirebaseDatabase.instance.reference().child('chinaRate');
    databaseReference.onValue.listen((event) {
      if (this.mounted) {  // Check if the widget is still mounted
        if (event.snapshot.value != null) {
          if (event.snapshot.value is Map) {
            Map<String, dynamic> data =
            event.snapshot.value as Map<String, dynamic>;

            setState(() {
              chinaRates = data;
            });
          }
        }
      }
    });
  }

  void deleteData(String key) {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('chinaRate');

    databaseReference.child(key).remove().then((_) {
      fetchChinaRates();
    });
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
              SizedBox(height: 20,),
              Text("Show Rates", style: TextStyle(color: Colors.black, fontSize: 25),),
              SizedBox(height: 20,),
          
              Expanded(
                child: ListView.builder(
                  itemCount: chinaRates.length,
                  itemBuilder: (context, index) {
                    String key = chinaRates.keys.elementAt(index);
                    Map<String, dynamic> data =
                        chinaRates[key] as Map<String, dynamic>;
                        
                    return Padding(
                      padding: const EdgeInsets.only(left: 40,right: 40),
                      child: Card(
                          color: Color(0xff034d17),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('China Name: ${data['Name']}',
                                        style: TextStyle(color: Colors.white)),
                                    Text('China Rates: ${data['Price']}',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdatesChinaRates(
                                                itemKey: key, data: data),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(color: Colors.amber),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        // Call the deleteData function when the user taps Delete
                                        deleteData(key);
                                      },
                                      child: Text("Delete",
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
