import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pakistan_solar_market/screens/myDrawer.dart';

class UpdatesChinaRates extends StatefulWidget {
  final String itemKey;
  final Map<String, dynamic> data;

  UpdatesChinaRates({required this.itemKey, required this.data});

  @override
  _UpdatesChinaRatesState createState() => _UpdatesChinaRatesState();
}

class _UpdatesChinaRatesState extends State<UpdatesChinaRates> {
  late TextEditingController nameController;
  late TextEditingController priceController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.data['Name']);
    priceController =
        TextEditingController(text: widget.data['Price'].toString());
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
                SizedBox(height: 40,),
            
                Text("Update Rates", style: TextStyle(color: Colors.black,fontSize: 25),),
                SizedBox(height: 60,),
                Padding(
                  padding: const EdgeInsets.only(left: 100, right: 100),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Enter China Name', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.only(left: 100, right: 100),
                  child: TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Enter China Rates', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 40,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    updateData(widget.itemKey);
                  },
                  child: Text('Update', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }

  void updateData(String key) {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('chinaRate');

    databaseReference.child(key).update({
      'Name': nameController.text,
      'Price': double.parse(priceController.text),
    }).then((value) {
      var snackBar =
      SnackBar(content: Text('Updates Rates'));
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar);

    });


  }
}
