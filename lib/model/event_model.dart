// ignore_for_file: public_member_api_docs, sort_constructors_first

//-----Comment model-----------------//
import 'package:flutter/material.dart';

class EventModel with ChangeNotifier {
  final String description;
  final String image;
  final String location;
  final String time;
  final String title;
  final String docId;
  final int reminder;

  EventModel({
    required this.docId,
    required this.reminder,
    required this.description,
    required this.image,
    required this.location,
    required this.time,
    required this.title,
  });

  EventModel.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        image = json['image'],
        reminder = json['reminders'] ?? 0,
        docId = json['doc_id'] ?? "",
        location = json['location'],
        time = json['time'],
        title = json['title'];

  Map<String, dynamic> toJson() => {
        'description': description,
        'location': location,
        'image': image,
        'doc_id': docId,
        'title': title,
        'time': time,
        'reminders': reminder
      };
}
