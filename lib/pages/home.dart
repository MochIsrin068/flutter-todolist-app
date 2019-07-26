import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/config/api.dart';
import 'package:todolist/main.dart';
import 'package:todolist/pages/activity/activites.dart';
import 'package:todolist/pages/activity/completeActivies.dart';
import 'package:todolist/pages/edit.dart';

class Home extends StatefulWidget {
  final String id, email, fullName;

  Home({this.id, this.email, this.fullName});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  Api api = Api();
  TabController controller;
  bool checkStatus = false;
  List<bool> listCheckStatus = List();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String msg = "";

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  _field(String hint, TextEditingController textController, Icon fieldIcon){
    return  Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        // gradient:LinearGradient(colors: [Colors.teal, Colors.cyanAccent]),
      ),
      child: TextField(
          controller: textController,
          decoration: InputDecoration(
              // border: InputBorder.none,
              icon: fieldIcon,
              hintText: hint
          ),
      ),
    );
  }


  _insert() async{
    final res = await http.post(api.create, body: {
      "title" : titleController.text,
      "description" : descController.text,
      "date" : DateTime.now().toString(),
      "user_id" : widget.id
    });

    final jsonData = jsonDecode(res.body);
    if(jsonData['status'] == 1){
      titleController.clear();
      descController.clear();
      Navigator.of(context).pop();
    }else{
      setState(() {
        msg = jsonData['message'];
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: ListView(
          children: <Widget>[
            Container(
              height: 180.0,
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pink, Colors.pinkAccent],
                )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Selamat Datang", style: 
                        TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white, textBaseline: TextBaseline.alphabetic
                        )),

                      Text("${widget.fullName}", style: 
                        TextStyle(
                          fontSize: 18.0, color: Colors.white
                        )),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.exit_to_app, color: Colors.white,),
                    onPressed: () => Navigator.of(context).pop()
                  )
                ],
              )
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              child: TabBar(
                indicatorColor: Colors.teal,
                labelColor: Colors.grey,
                controller: controller,
                tabs: <Widget>[
                  Tab(text: "Activity"),
                  Tab(text: "Complete Activity"),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0),
              color: Colors.grey[200],
              height: MediaQuery.of(context).size.height - 400.0,
              padding: EdgeInsets.only(top:10.0),
              child: TabBarView(
                controller: controller,
                children: <Widget>[
                  Activities(id: widget.id),
                  CompleteActivities(id: widget.id)
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => showDialog(
          context: context,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)
            ),
            title: Container(
                child: Center(child: Text("Add Your Activity", style: TextStyle())),
                margin: EdgeInsets.only(top: 15.0),
                padding: EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))
                ),
            ),
            titlePadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              MaterialButton(
                color: Colors.teal,
                textColor: Colors.white,
                onPressed: _insert,
                child: Text("Simpan"),
              ),
              MaterialButton(
                color: Colors.pink,
                textColor: Colors.white,
                onPressed: (){
                  titleController.clear();
                  descController.clear();
                  return Navigator.of(context).pop();
                },
                child: Text("Batal"),
              ),
              SizedBox(width: 10.0,)
            ],
            content: Container(
              width: 500.0,
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Text(msg),
                  _field("Title", titleController, Icon(Icons.title)),
                  SizedBox(height: 20.0),
                  _field("Description", descController, Icon(Icons.description)),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          )
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}