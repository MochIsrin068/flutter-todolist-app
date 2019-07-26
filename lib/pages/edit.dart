import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/config/api.dart';

class Edit extends StatefulWidget {
  String title, desc, date, id;

  Edit({this.title, this.desc, this.date, this.id});

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  Api api = Api();
  String msg = "";
  String titleControl = "";
  String descControl = "";
  String dateControl = "";

  _update() async{
    final res = await http.post(api.edit, body: {
      "title" : titleControl,
      "description" : descControl,
      "date" : widget.date,
      "id" : widget.id
    });

    final jsonData = jsonDecode(res.body);
    if(jsonData['status'] == 1){
      setState(() {
        titleControl = "";
        descControl = "";
        dateControl = "";
      });
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
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.pink, Colors.pinkAccent])
        ),
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 25.0),
              alignment: Alignment.center,
              child: Text("Edit Form", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white)),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient:LinearGradient(colors: [Colors.white54, Colors.white70])),
                  child:TextFormField(
                    onFieldSubmitted: (e){
                      setState(() {
                        titleControl = e;
                      });
                    },
                    initialValue: widget.title,
                    decoration: InputDecoration(  
                      border: InputBorder.none,
                      icon: Icon(Icons.title),
                    ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient:LinearGradient(colors: [Colors.white54, Colors.white70])),
                  child:TextFormField(
                    onFieldSubmitted: (e){
                      setState(() {
                        descControl = e;
                      });
                    },
                    initialValue: widget.desc,
                    decoration: InputDecoration(  
                      border: InputBorder.none,
                      icon: Icon(Icons.description),
                    ),
              ),
            ),
            
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient:LinearGradient(colors: [Colors.white54, Colors.white70])),
                  child:  TextFormField(
                  initialValue: widget.date,
                  readOnly: true,
                  decoration: InputDecoration(  
                    border: InputBorder.none,
                    icon: Icon(Icons.date_range),
                  ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    color: Colors.teal,
                    onPressed: _update,
                    child: Text("Edit", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  SizedBox(width: 15.0),
                  MaterialButton(
                    color: Colors.teal,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text("Batal", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}