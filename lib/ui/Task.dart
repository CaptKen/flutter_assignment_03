import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Task extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TaskState();
  }
}

class TaskState extends State<Task> {
  Firestore _store = Firestore();
  Widget listData() {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data.documents.length != 0) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return CheckboxListTile(
                title: Text(
                    snapshot.data.documents.elementAt(index).data['title']),
                value:
                    snapshot.data.documents.elementAt(index).data['done'] != 0,
                onChanged: (bool value) {
                  setState(() {
                    _store
                        .collection('todo')
                        .document(
                            snapshot.data.documents.elementAt(index).documentID)
                        .setData({
                      'title': snapshot.data.documents
                          .elementAt(index)
                          .data['title'],
                      'done': 1
                    });
                  });
                },
              );
            },
          );
        } else {
          return Center(child: Text('No data found...', style: TextStyle(fontSize: 30)));
        }
      },
      stream: _store.collection('todo').where('done', isEqualTo: 0).snapshots(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Todo"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.pushNamed(context, "add");
              },
            )
          ],
        ),
        body: listData());
  }
}