import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_members_management_system/model/event_model.dart';
import 'package:flutter/material.dart';

class EventProvider with ChangeNotifier {
  List<EventModel> events = [];
  int userCount = 0;
  String task = "";
  Future getEvent() async {
    events.clear();

    EventModel event;

    FirebaseFirestore.instance
        .collection('events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        event = EventModel.fromJson(doc.data() as Map<String, dynamic>);
        events.add(event);
      }

      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((QuerySnapshot querySnapshot) {
        userCount = querySnapshot.docs.length;
      });

      notifyListeners();
    });
  }
}
