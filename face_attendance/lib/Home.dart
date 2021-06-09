import 'Employee.dart';
import 'Customer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Unknown.dart';
import 'Add_new.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.logout,
          color: Colors.white,),
          onPressed: (){
            Navigator.pop(context);
          },),
          elevation: 2.0,
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          title: Text(
            "Attendance",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2.0,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Employee",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Customer",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Unknown",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Employee(),
            Customer(),
            Unknown(),
          ],
        ),
        floatingActionButton: float(),
      ),
    );
  }
}

class float extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  FloatingActionButton(
      child: Icon(
        Icons.cloud_upload_outlined,
        color: Colors.yellow,
      ),
      backgroundColor: Colors.deepPurpleAccent,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Add_new()));
      },
    );
  }
}
