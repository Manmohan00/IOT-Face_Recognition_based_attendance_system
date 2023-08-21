import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Attendance_status extends StatefulWidget {
  String name;
  String doc_name;
  String Month;
  Attendance_status(this.name, this.doc_name, this.Month);
  @override
  _Attendance_statusState createState() => _Attendance_statusState();
}

class _Attendance_statusState extends State<Attendance_status> {
  String total;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.doc_name)),
      body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child:StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection(widget.name).doc(widget.doc_name).collection('Attendance').where("Month", isEqualTo: widget.Month)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.blueGrey,
                          ));
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) =>
                              _buildList(context, snapshot.data.docs[index])),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.purple,width: 2.0),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
                            ),
                            margin: EdgeInsets.only(top: 2, left: 10, right: 10, bottom: 22),
                            padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height /100 *15,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Total Attendance in ${widget.Month} :",
                                  style: TextStyle(
                                    letterSpacing: 0.8,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.purple
                                  ),),
                                  Text(snapshot.data.docs.length.toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple
                                    ),),
                                ],
                              ),
                          alignment: Alignment.topCenter,),
                          ],
                        );
                      }),
              ),
          ),
          )
    );
  }
}

Widget _buildList(BuildContext context, DocumentSnapshot document) {
  var date = document.data()['Date'].split(',');
  return Card(
    color: Colors.grey[100],
    margin: EdgeInsets.all(5.0),
    elevation: 2.0,
    shadowColor: Colors.grey,
    child: ListTile(
      title: Text(date[0],
      style: TextStyle(
        letterSpacing: 2.0
      ),),
      trailing: Text(date[1],
        style: TextStyle(
            letterSpacing: 2.0
        ),),
      subtitle: Text("Present",
      style: TextStyle(
        color: Colors.green
      ),),
    ),
  );
}
