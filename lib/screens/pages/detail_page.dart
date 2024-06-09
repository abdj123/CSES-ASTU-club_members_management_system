// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_members_management_system/model/event_model.dart';
import 'package:flutter/material.dart';
// import 'package:device_calendar/device_calendar.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Discription extends StatefulWidget {
  final EventModel event;
  const Discription({super.key, required this.event});

  @override
  State<Discription> createState() => _DiscriptionState();
}

class _DiscriptionState extends State<Discription> {
  Color black = const Color.fromARGB(115, 46, 46, 46);
  Color green = Colors.green;
  Color white = const Color(0xFFFFFFFF);
  void dummy() {}

  DateTimeRange? selectTime =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  Widget build(BuildContext context) {
    var item = widget.event;
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: GestureDetector(
              onTap: () async {
                final firestore = FirebaseFirestore.instance;

                final DateTimeRange? dateTimeRange = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2023),
                    lastDate: DateTime(3000));

                if (dateTimeRange != null) {
                  setState(() {
                    selectTime = dateTimeRange;

                    final Event newEvent = Event(
                        title: item.title,
                        description: item.description,
                        location: item.location,
                        startDate: selectTime!.start,
                        endDate: selectTime!.end
                        // eventDate.add(
                        //   Duration(minutes: 30),
                        // ),
                        );

                    firestore
                        .collection("events")
                        .doc(widget.event.docId)
                        .update({"reminders": widget.event.reminder + 1}).then(
                            (value) {
                      Add2Calendar.addEvent2Cal(newEvent);
                    });
                  });
                }
              },
              child: Container(
                width: 206,
                height: 54,
                decoration: const BoxDecoration(
                    color: Color(0xff1F212D),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        "Set Reminder",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                      color: const Color(0xb3000000),
                      height: 280,
                      width: double.infinity,
                      child: FadeInImage(
                        placeholderFit: BoxFit.fill,
                        height: 280,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: const AssetImage("assets/csec.jpg"),
                        image: NetworkImage(
                          item.image,
                        ),
                      )),
                  Positioned(
                    top: 40,
                    left: 15,
                    right: 15,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        iconButton(
                          white,
                          black,
                          Icons.arrow_back,
                          () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 23,
                        right: 15,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title,
                              // "Gucci Hand Bag",
                              style: const TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.w700,
                              )),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time_rounded,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(item.time,
                                        overflow: TextOverflow.clip,
                                        // "Posted 2 hours ago",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ))
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_pin,
                                      size: 20,
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(item.location,
                                        overflow: TextOverflow.clip,
                                        // "Posted 2 hours ago",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 23, right: 15),
                      child: Column(
                        children: [
                          Text("Description",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 23, right: 15, top: 4),
                      child: Text(
                        item.description,
                        style: const TextStyle(fontSize: 13),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container iconButton(
      Color white, Color black, IconData icon, GestureTapCallback x) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle, color: white),
      child: Center(
        child: IconButton(
          onPressed: x,
          icon: Icon(icon, color: black),
        ),
      ),
    );
  }
}
