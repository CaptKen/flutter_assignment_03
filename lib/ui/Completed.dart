import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Completed extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CompletedState();
  }
}

class CompletedState extends State<Completed> {
  TextEditingController eCtrl = TextEditingController();
  bool showDialog = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Todo"),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.delete),
              onPressed: () {
                Firestore.instance
                    .collection('todo')
                    .where("done", isEqualTo: 1)
                    .getDocuments()
                    .then((value) {
                  value.documents.forEach((item) {
                    item.reference.delete();
                  });
                });
              }),
        ],
      ),
      body: Center(
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('todo')
              .where('done', isEqualTo: 1)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return buildList(snapshot.data.documents);
            } else {
              return Text("loading...");
            }
          },
        ),
      ),
    );
  }

  Widget buildList(List<DocumentSnapshot> data) {
    return data.length != 0
        ? ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: new BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.pink, width: 0.5))),
                child: CheckboxListTile(
                  title: Text(data.elementAt(index).data["title"]),
                  onChanged: (bool value) {
                    setState(() {
                      Firestore.instance
                          .collection('todo')
                          .document(data.elementAt(index).documentID)
                          .setData({
                        'title': data.elementAt(index).data['title'],
                        'done': 0
                      });
                    });
                  },
                  value: data.elementAt(index).data['done'] == 1,
                ),
              );
            })
        : Center(
            child: Text("No data found...", style: TextStyle(fontSize: 30)));
  }
}
