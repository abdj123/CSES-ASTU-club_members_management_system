import 'package:club_members_management_system/admin/edit_event.dart';
import 'package:club_members_management_system/provider/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared_preferance/shared_preference.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> getEvents() async {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    await eventProvider.getEvent();
  }

  late bool isAdmin;

  Future<void> _initPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    task = _prefs.getStringList(
            'tasks_${DateTime.now().year}_${DateTime.now().month}_${DateTime.now().day}') ??
        [];
  }

  late SharedPreferences _prefs;
  late List<String> task = [];

  @override
  void initState() {
    isAdmin = UserPreferences.getRole() ?? false;

    getEvents();
    super.initState();
    _initPreferences();
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          title: Image.asset(
            "assets/csec.jpg",
            width: 65,
            height: 45,
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: eventProvider.events
                    .map((item) => GestureDetector(
                          onTap: () {
                            isAdmin
                                ? Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditEvent(event: item),
                                  ))
                                : Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Discription(event: item),
                                  ));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5.0),
                            child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                                child: Stack(
                                  children: <Widget>[
                                    Image.network(item.image,
                                        fit: BoxFit.cover, width: 1000.0),
                                    Positioned(
                                      bottom: 0.0,
                                      left: 0.0,
                                      right: 0.0,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(200, 0, 0, 0),
                                              Color.fromARGB(0, 0, 0, 0)
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 20.0),
                                        child: Text(
                                          item.title,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ))
                    .toList()
                // imageSliders,
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isAdmin
                      ? const Text(
                          "Welcome back admin",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        )
                      : const Text(
                          "Your today's focus",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                  Visibility(
                    visible: !isAdmin,
                    child: Container(
                      height: 78,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          color: Colors.grey[400]),
                      child: task.isEmpty
                          ? const Center(child: Text("no Tasks"))
                          : Center(
                              child: Text(
                              task.last,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0, top: 8),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 228,
                        crossAxisSpacing: 22.0,
                        mainAxisSpacing: 20.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: eventProvider.events.length,
                      itemBuilder: (context, index) {
                        final item = eventProvider.events[index];
                        return GestureDetector(
                          onTap: () {
                            isAdmin
                                ? Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EditEvent(event: item),
                                  ))
                                : Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        Discription(event: item),
                                  ));
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade400,
                                      blurRadius: 0.5,
                                      offset: const Offset(0, 3.6),
                                    ),
                                  ],
                                  color: const Color(0xffF8F8F8),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: ClipRRect(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(15)),
                                        child: FadeInImage(
                                          placeholderFit: BoxFit.fill,
                                          height: 115,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          placeholder: const AssetImage(
                                              "assets/csec.jpg"),
                                          image: NetworkImage(
                                            item.image,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0, bottom: 2),
                                            child: Text(
                                              item.title,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.timer_sharp),
                                              Text(
                                                item.time,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 3, bottom: 8),
                                            child: Row(
                                              children: [
                                                const Icon(Icons.location_on),
                                                Text(
                                                  item.location,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
