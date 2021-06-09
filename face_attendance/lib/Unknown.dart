import 'Showimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Unknown extends StatefulWidget {
  @override
  _UnknownState createState() => _UnknownState();
}

class _UnknownState extends State<Unknown> {
  var now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Unknown').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueGrey,
                  ));
            return Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0))),
              child: GridView.builder(
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
  if(document.data()['image'] != null) {
    return Container(
      alignment: Alignment.center,
      child: Image.network(document.data()['image'],
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 100 * 30,
      width: MediaQuery.of(context).size.width / 100 * 50,),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15)),
    );
  }
}
