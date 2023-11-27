import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "A university Club for students passionate about programming & software development.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            ListTile(
                onTap: () async {
                  Uri link = Uri.parse("http://csec-astu.com/");
                  await launchUrl(link);
                },
                leading: const Icon(Icons.link),
                title: const Text(
                  "CSEC-ASTU",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                )),
            ListTile(
                onTap: () async {
                  Uri link = Uri.parse("https://t.me/csec_devs");
                  await launchUrl(link);
                },
                leading: const Icon(Icons.telegram_rounded),
                title: const Text(
                  "CSEC-ASTU",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                )),
            ListTile(
                onTap: () async {
                  Uri link = Uri.parse("astu.dev@astu.edu.et");
                  await launchUrl(link);
                },
                leading: const Icon(Icons.email),
                title: const Text(
                  "CSEC-ASTU",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                )),
            // ListTile(leading: Icon(Icons.link),title: Text("CSEC-ASTU",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),)),
          ]),
    );
  }
}
