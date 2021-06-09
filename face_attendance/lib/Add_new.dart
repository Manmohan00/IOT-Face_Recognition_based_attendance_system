import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class Add_new extends StatefulWidget {
  @override
  _Add_newState createState() => _Add_newState();
}

class _Add_newState extends State<Add_new> {
  String dropvalue = 'Employee';
  TextEditingController data = TextEditingController();
  String name;
  File imagepath ;
  bool done = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("New Entry"),
        centerTitle: true,
        titleSpacing: 2.0,
      ),
      body: Builder(
        builder:(context) => done ?  Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.purple,
            valueColor:  AlwaysStoppedAnimation<Color>(Colors.yellow),
          ),
        ) : Center(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.all(15.0),
                    width: MediaQuery.of(context).size.height / 100 * 40,
                    child: TextField(
                      controller: data,
                      decoration: InputDecoration(
                        fillColor: Colors.deepPurple,
                          labelText: "Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0))),
                      onChanged: (data){
                        name = data;
                      },
                    ),
                  ),
                  Container(
                      child: DropdownButton<String>(
                        dropdownColor: Colors.grey[200],
                    value: dropvalue,
                    onChanged: (String newValue) {
                      setState(() {
                        dropvalue = newValue;
                      });
                    },
                    items: <String>['Employee', 'Customer']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
                  Container(
                    margin: EdgeInsets.only(top : 20.0),
                    child: MaterialButton(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.yellow,
                      ),
                      color: Colors.deepPurple,
                      elevation: 0.5,
                      onPressed: () async{
                        File image = await getcameraimage(name, dropvalue);
                          setState(() {
                           imagepath = image;
                          });
                      },
                    ),
                  ),
                  Icon(Icons.upload_rounded,
                    color: Colors.purple[300],
                    size: 30,),
                  imagepath == null ? Text("Click a close up image of the person's face") : Image.file(imagepath,
                      height: MediaQuery.of(context).size.height /100 * 20,
                      width: MediaQuery.of(context).size.width/100 * 80),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
                    child: MaterialButton(
                      minWidth: MediaQuery.of(context).size.width / 100 * 50,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      padding: EdgeInsets.all(10.0),
                      elevation: 3.0,
                      child: Icon(
                        Icons.done_outline_outlined,
                        color: Colors.yellow,
                      ),
                      color: Colors.deepPurpleAccent,
                      onPressed: () async{
                        if (name == null){
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Please add a Name"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.purple,
                            duration: Duration(seconds: 3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: BorderSide(
                                width: 2,
                                color: Colors.black38
                              )
                            ),
                          ),);
                        }
                        else if(imagepath == null){
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text("Please add an Image"),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.purple,
                            duration: Duration(seconds: 3),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(
                                    width: 2,
                                    color: Colors.black38
                                )
                            ),
                          ),);
                        }
                        else {
                          setState(() {
                            done = true;
                          });
                         String success = await uploadData(name, dropvalue, imagepath);
                          setState(() {
                            done = false;
                            data.clear();
                            dropvalue = 'Employee';
                            imagepath = null;
                          });
                         Scaffold.of(context).showSnackBar(SnackBar(
                           content: Text(success),
                           behavior: SnackBarBehavior.floating,
                           backgroundColor: Colors.black38,
                           duration: Duration(seconds: 3),
                           shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(20.0),
                               side: BorderSide(
                                   width: 2,
                                   color: Colors.black38
                               )
                           ),
                         ),);
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> uploadData(name, field, imagepath) async{
String ImageName = name + "_" + field;
String imageurl = await uploadImage(name, field, imagepath, ImageName);
await FirebaseFirestore.instance.collection('$field').add({
  'Name' : ImageName,
  'image' : imageurl,
});
return "Data Added!";

}

Future<String> uploadImage(name, field, imagepath, ImageName) async {
  String uploadedFileURL;
  var storageReference = FirebaseStorage.instance
      .ref()
      .child('$field/$ImageName');
  await storageReference.putFile(imagepath);
  await storageReference.getDownloadURL().then((fileURL) {
     uploadedFileURL = fileURL;
  });
  return uploadedFileURL;
}

Future<File> getcameraimage(name, field) async{
  String Filename = name + "_" + field;
  PickedFile pickedFile;
  pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
  String dir = (await getApplicationDocumentsDirectory()).path;
  String NewFileName = "$dir/$Filename.jpg";
  File image = await File(pickedFile.path).copy(NewFileName);
    if (image != null) {
     return image;
   }
}