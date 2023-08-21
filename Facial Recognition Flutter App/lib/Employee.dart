import 'Showimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Select_month.dart';
import 'package:intl/intl.dart';

class Employee extends StatefulWidget {
  @override
  _EmployeeState createState() => _EmployeeState();
}

class _EmployeeState extends State<Employee> {
  var now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Employee').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.blueGrey,
              ));
            return Container(
              margin: EdgeInsets.only(top: 10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0))),
              child:GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 150,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) =>
                      _buildListTile(context, snapshot.data.docs[index])),
            );
          }),
    );
  }
}

Widget _buildListTile(BuildContext context, DocumentSnapshot document) {
  String now = DateFormat("MMMM").format(DateTime.now());
  String firebaseName = document.data()['Name'];
  var Name = firebaseName.split("_");
  return Container(
    width: MediaQuery.of(context).size.width / 100 * 50,
    height: MediaQuery.of(context).size.height / 100 * 20,
    child: GestureDetector(
      onTap: (){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Select_Month('Employee', Name[0]
            )));
      },
      child: Stack(
        children: [
          Image.network(
            document.data()['image'],
            width: MediaQuery.of(context).size.width / 100 * 50,
            height: MediaQuery.of(context).size.height / 100 * 11,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              Name[0],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
