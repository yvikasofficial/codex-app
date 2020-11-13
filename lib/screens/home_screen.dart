import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codex/providers/notification_proivder.dart';
import 'package:codex/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AuthenticationProvider>(context);
    return LoadingWidget(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            RaisedButton(
              onPressed: () => provider.logOut(context),
              child: Text("Log Out"),
            ),
          ],
        ),
        body: FutureBuilder(
            future: FirebaseFirestore.instance.collection("devices").get(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Container(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () => _hadleSendNotification(
                        snapshot.data.docs[index]['uid']),
                    title: Text(snapshot.data.docs[index]['uid']),
                    leading: Icon(Icons.supervised_user_circle),
                  );
                },
              );
            }),
      ),
    );
  }

  _hadleSendNotification(String uid) async {
    setState(() {
      _isLoading = true;
    });
    NotificationProvider _notifiProvider = NotificationProvider();
    await _notifiProvider.sendNotificationToUser(
        uid, "Hay this is test heading", "This is test message");
    setState(() {
      _isLoading = false;
    });
  }
}
