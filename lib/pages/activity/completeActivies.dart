import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todolist/config/api.dart';

class CompleteActivities extends StatefulWidget {
  final String id;
  CompleteActivities({this.id});

  @override
  _CompleteActivitiesState createState() => _CompleteActivitiesState();
}

class _CompleteActivitiesState extends State<CompleteActivities> {

  Api api = Api();

  Future getCompleteActivity() async{
    final res = await http.get(api.completeActivity+"/${widget.id}");
    final jsonData = jsonDecode(res.body);
    return jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getCompleteActivity(),
      builder: (context, snap){
        if(snap.hasData){
          List list = snap.data;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (c,i){
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
                trailing: Text(list[i]['date']),
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