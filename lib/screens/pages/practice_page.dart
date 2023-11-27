import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParcticePage extends StatefulWidget {
  const ParcticePage({super.key});

  @override
  State<ParcticePage> createState() => _ParcticePageState();
}

class _ParcticePageState extends State<ParcticePage> {
  List logoList = [
    "assets/leet_code.png",
    "assets/hacker_rank.png",
    "assets/code_forces.png"
  ];
  List titleList = ["LeetCode", "HackerRank", "Codeforces"];
  List descriptionList = [
    "LeetCode is the best platform to help you enhance your skills, expand your knowledge and prepare for technical interviews.",
    "HackerRank is the market-leading coding test and interview solution for hiring developers.",
    "Codeforces is a website that hosts competitive programming contests."
  ];
  List urlList = [
    "https://leetcode.com/",
    "https://www.hackerrank.com/",
    "https://codeforces.com/"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: ListView.builder(
          itemCount: logoList.length,
          itemBuilder: (context, index) {
            String logo = logoList[index];
            String title = titleList[index];
            String description = descriptionList[index];
            String url = urlList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  title: Text(title,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  subtitle: Text(description),
                  trailing: GestureDetector(
                    onTap: () async {
                      Uri link = Uri.parse(url);
                      await launchUrl(link);
                    },
                    child: Container(
                        width: 100,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 226, 157, 96),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Practice",
                              style: TextStyle(color: Colors.white),
                            ),
                            Icon(
                              Icons.arrow_right,
                              color: Colors.white,
                              size: 24,
                            )
                          ],
                        )),
                  ),
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        logo,
                        width: 80,
                        height: 150,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => VideoPlayScreen(video: video),
                    //     ));
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
