import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Showimage extends StatefulWidget {
  String image;
  Showimage(this.image);

  @override
  _ShowimageState createState() => _ShowimageState();
}

class _ShowimageState extends State<Showimage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent,
      width: MediaQuery.of(context).size.width/100 * 50,
      height: MediaQuery.of(context).size.height/100 * 50,
      child: Image.network('${widget.image}'),
    );
  }
}

