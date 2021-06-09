import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var adminName = TextEditingController();
  var password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Image.asset('lib/cherry.png',
                width:  MediaQuery.of(context).size.width / 100 * 80,
                    height:  MediaQuery.of(context).size.height / 100 * 25),
              Container(
                width:  MediaQuery.of(context).size.width / 100 * 95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.person,
                        size: 40.0,
                        color: Colors.deepPurple,),
                        TextBox(adminName, 'Admin ID', false),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.lock,
                          size: 40.0,
                            color: Colors.deepPurple),
                        TextBox(password, 'Password', true),
                      ],
                    ),

                  ],
                )
              ),
              LoginButton(adminName, password),
            ],
          ),
        ),
      ),
    );
  }
}

class TextBox extends StatefulWidget {
  TextEditingController text;
  String hint;
  bool isPassword;
  TextBox(this.text, this.hint, this.isPassword);
  @override
  _TextBoxState createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(15.0),
        width: MediaQuery.of(context).size.width / 100 * 70,
        child: TextField(
          autofocus: false,
          controller: widget.text,
          obscureText: widget.isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.purple[200],
            labelText: widget.hint,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0)),
          ),
        ),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  TextEditingController adminID;
  TextEditingController password;
  LoginButton(this.adminID, this.password);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 100 * 50,
        margin: EdgeInsets.only(top: 20.0),
        child: RaisedButton(
          padding: EdgeInsets.all(15.0),
          child: Text("Login",
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          onPressed: (){
            bool isCorrect = verify(adminID.text, password.text);
            if (isCorrect == true){
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home()));
              adminID.clear();
              password.clear();
            }
            else{
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Id or Password Incorrect!"),
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
          },
        ),
      ),
    );
  }
}

bool verify(String adminID,String password){
  String ID = 'facerec';
  String pass = 'Face@123';

  if(adminID == ID && password == pass){
    return true;
  }
  else
    {
      return false;
    }
}
