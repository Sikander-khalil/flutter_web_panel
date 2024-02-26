import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pakistan_solar_market/screens/myDrawer.dart';

class AddChina extends StatefulWidget {
  @override
  _AddChinaState createState() => _AddChinaState();
}

class _AddChinaState extends State<AddChina> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Row(

        children: [
          MyDrawer(),
          Expanded(child: Center(
            child:  Column(
              children: [
                SizedBox(height: 40,),
                Text("Add China Rates", style: TextStyle(color: Colors.black, fontSize: 26),),
                SizedBox(height: 40,),
                Padding(
                  padding: const EdgeInsets.only(left: 90, right: 90),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Enter China Name', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 40.0),
                Padding(
                  padding: const EdgeInsets.only(left: 90, right: 90),
                  child: TextField(
                    controller: priceController,
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(labelText: 'Enter China Rtaes', border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(height: 50.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    addData();
                  },
                  child: Text('Add', style: TextStyle(color: Colors.white, fontSize: 20),),
                ),
              ],
            ),
          ))
        ],
      )
    );
  }

  void addData() {
    DatabaseReference databaseReference =
    FirebaseDatabase.instance.reference().child('chinaRate');

    String? newKey = databaseReference.push().key;

    databaseReference.child(newKey!).set({
      'Name': nameController.text,
      'Price': double.parse(priceController.text),
    }).then((_) {
      var snackBar =
      SnackBar(content: Text('Adding Rates'));
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBar);

      if (mounted) {
        setState(() {
          // Update the state if the widget is still mounted
          // You can add any other logic you need here
        });
      }
    });
  }

}
