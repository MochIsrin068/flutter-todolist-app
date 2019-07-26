import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/config/api.dart';
import 'package:todolist/pages/edit.dart';

class Activities extends StatefulWidget {
  final String id;
  Activities({this.id});

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  Api api =  Api();
  List<bool> listCheckStatus = List();
  String msg = "";
  
  Future getActivity() async{
    final res = await http.get(api.activity+"/${widget.id}");
    final jsonData = jsonDecode(res.body);
    return jsonData;
  }

  _complete(String id) async{
    final res = await http.post(api.complete, body:{
      "id" : id
    }); 

    final jsonData = jsonDecode(res.body);
    if(jsonData['status'] == 1){
      setState(() {
        msg = jsonData['message'];
      });
    }else{
      setState(() {
        msg = jsonData['message'];
      });
    }
  }

  _delete(String id) async{
    final res = await http.post(api.delete, body:{
      "id" : id
    });

    final jsonData = jsonDecode(res.body);

    if(jsonData['status'] == 1){
      setState(() {
        msg = jsonData['message'];
      });
    }else{
      setState(() {
        msg = jsonData['message'];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getActivity(),
      builder: (context, snap){
        if(snap.hasData){
          List list = snap.data;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (c,i){
              listCheckStatus.add(false);
              // print(listCheckStatus);
              return ListTile(
                onTap: (){
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))
                    ),
                    context: context,
                    builder: (c) => Container(
                      padding: EdgeInsets.all(20.0),
                      height: 200.0,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(list[i]['title'], style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
                          Divider(),
                          Text(list[i]['date'], style: TextStyle(fontSize: 14.0)),
                          SizedBox(height: 15.0),
                          Text(list[i]['description'], style: TextStyle(fontSize: 16.0)),
                        ],
                      ),
                    )
                  );
                },
                leading: CircleAvatar(backgroundColor: Colors.amber, child: Text("${i+1}", style: TextStyle(color: Colors.white))),
                title: Text(list[i]['title']),
                subtitle: Text(list[i]['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Checkbox(
                      onChanged: (e){
                        setState(() {
                          listCheckStatus[i] = e;
                        });
                        if(listCheckStatus[i] == true){
                          _complete(list[i]['id']);
                          // listCheckStatus.removeAt(i);
                        }
                      },
                      value: listCheckStatus[i],
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => Edit(
                            title: list[i]['title'],
                            desc: list[i]['description'],
                            date: list[i]['date'],
                            id: list[i]['id'],
                          )
                        ));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _delete(list[i]['id']),
                    )
                  ],
                )
              );
            },
          );
        }else{
          return Center(child:CircularProgressIndicator());
        } 
      },
    );

  }
}