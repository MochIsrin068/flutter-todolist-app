import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/config/api.dart';
import 'package:todolist/pages/home.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool pass = true;
  String errorMessage = ""; 

  // String usernameValue = "";
  // String passwordValue = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  username(){
    return  Container(
      padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient:
                LinearGradient(colors: [Colors.white54, Colors.white70])),
        child: TextField(
          controller: emailController,
          decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.mail),
              hintText: "Email"),
      ),
    );
  }

  password(){
    return Container(
              padding: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient:
                      LinearGradient(colors: [Colors.white54, Colors.white70])),
              child: TextField(
                controller: passwordController,
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

  _login() async{
    final res = await http.post(api.login, body: {
      "identity" : emailController.text,
      "password" : passwordController.text
    });

    final jsonData = jsonDecode(res.body);

    if (jsonData['status'] == 0) {
      setState(() {
        errorMessage = jsonData['message'];
      });
    } else {
      setState(() {
        errorMessage = "";
      });
      emailController.clear();
      passwordController.clear();
      String id = jsonData['user_data']['id'];
      String email = jsonData['user_data']['email'];
      String fullName = jsonData['user_data']['full_name'];
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => Home(
        id: id,
        email: email,
        fullName: fullName,
      )));
    }
    
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white60,
        ),
        padding: EdgeInsets.all(20.0),
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Center(child: Text(errorMessage,style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))),
            SizedBox(height: 15.0),
            username(),
            SizedBox(height: 15.0),
            password(),
            SizedBox(height: 15.0),
            MaterialButton(
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              onPressed: _login,
              color: Colors.teal,
              highlightColor: Colors.pink,
              splashColor: Colors.pinkAccent,
              child: Text("LOGIN", style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 15.0),
            FlatButton(
              onPressed: () {},
              child: Text("Forgot Password ?",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
    );
  }
}