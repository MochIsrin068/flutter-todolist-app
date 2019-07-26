import 'package:flutter/material.dart';
import 'package:todolist/pages/login.dart';
import 'package:todolist/pages/register.dart';

void main(){
  runApp(
    MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    )
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  TabController myTab;

  @override
  void initState() {
    super.initState();
    myTab = TabController(length: 2, vsync: this);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.pink, Colors.pinkAccent])),
        padding: EdgeInsets.all(30.0),
        child: ListView(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 20.0),
                alignment: Alignment.center,
                child: Text("TODO LIST APP", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white))
            ),
            SizedBox(height: 20.0),
            Container(
              child: TabBar(
                indicatorColor: Colors.teal,
                controller: myTab,
                tabs: <Widget>[
                  Tab(text: "Login",),
                  Tab(text: "Register"),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.all(12.0),
              height: MediaQuery.of(context).size.height / 2 + 80,
              child: TabBarView(
                controller: myTab,
                children: <Widget>[
                  Login(),
                  Register()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}