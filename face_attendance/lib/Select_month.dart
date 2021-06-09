import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Attendance_status.dart';

class Select_Month extends StatefulWidget {
  String name;
  String doc_name;
  Select_Month(this.name,this.doc_name);
  @override
  _Select_MonthState createState() => _Select_MonthState();
}

class _Select_MonthState extends State<Select_Month> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Month"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Container(
            child: ListView(
              physics: AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Months('January', widget.name, widget.doc_name),
                Months('February', widget.name, widget.doc_name),
                Months('March', widget.name, widget.doc_name),
                Months('April', widget.name, widget.doc_name),
                Months('May', widget.name, widget.doc_name),
                Months('June', widget.name, widget.doc_name),
                Months('July', widget.name, widget.doc_name),
                Months('August', widget.name, widget.doc_name),
                Months('September', widget.name, widget.doc_name),
                Months('October', widget.name, widget.doc_name),
                Months('November', widget.name, widget.doc_name),
                Months('December', widget.name, widget.doc_name),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Months extends StatelessWidget {
  String Month;
  String Name;
  String doc_name;
  Months(this.Month,this.Name,this.doc_name);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2.0, color: Colors.purple[300])
        )
      ),
      child: ListTile(
        title: Text(Month,
        style: TextStyle(
          fontSize: 16,
          letterSpacing: 2.0,
          fontWeight: FontWeight.bold
        ),),
        trailing: Icon(Icons.navigate_next_rounded),
        onTap: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Attendance_status(Name, doc_name, Month
              )));
        },
      ),
    );
  }
}

