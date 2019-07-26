import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/config/api.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool pass = true;
  String errorMessage = ""; 
  String successMessage = ""; 

  // String usernameValue = "";
  // String passwordValue = "";

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();


  field(Icon prefixIco, TextEditingController textControl, String placeHold){
    return  Container(
      padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient:
                LinearGradient(colors: [Colors.white54, Colors.white70])),
        child: TextField(
          controller: textControl,
          decoration: InputDecoration(
              border: InputBorder.none,
              icon: prefixIco,
              hintText: placeHold),
      ),
    );
  }

  _password(){
    return Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient:
                      LinearGradient(colors: [Colors.white54, Colors.white70])),
              child: TextField(
                controller: password,
                obscureText: pass,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.https),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye),
                      onPressed: () {
                        var m = pass == true ? false : true;
                        setState(() {
                          pass = m;
                        });
                      },
                    ),
                    hintText: "Password"),
              ),
            );
  }


  Api api = Api();

  _register() async{
    final res = await http.post(api.register, body: {
      "first_name" : firstName.text,
      "last_name" : lastName.text,
      "email" : email.text,
      "phone" : phone.text
    });

    final jsonData = jsonDecode(res.body);

    if (jsonData['status'] == 0) {
      setState(() {
        errorMessage = jsonData['message'];
        successMessage = "";
      });
    } else {
      setState(() {
        successMessage = jsonData['message'];
        errorMessage = "";
      });
    }
    
  }



  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white60,
        ),
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Center(child: Text(errorMessage,style: TextStyle(color: Colors.red))),
            Center(child: Text(successMessage,style: TextStyle(color: Colors.white))),
            SizedBox(height: 15.0),
            field(Icon(Icons.person), firstName, "First Name"),
            SizedBox(height: 15.0),
            field(Icon(Icons.person), lastName, "Last Name"),
            SizedBox(height: 15.0),
            field(Icon(Icons.mail), email, "Email"),
            SizedBox(height: 15.0),
            field(Icon(Icons.phone), phone, "Phone"),
            // _password(),
            SizedBox(height: 15.0),
            MaterialButton(
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: _register,
              color: Colors.teal,
              highlightColor: Colors.pink,
              splashColor: Colors.pinkAccent,
              child: Text("REGISTER", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 15.0),
          ],
        ),
    );
  }
}