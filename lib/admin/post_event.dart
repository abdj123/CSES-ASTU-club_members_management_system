// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostEvent extends StatefulWidget {
  const PostEvent({
    super.key,
  });

  @override
  State<PostEvent> createState() => _PostEventState();
}

class _PostEventState extends State<PostEvent> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  String? token;

  int currentImageIndex = 0;
  List<File> compressedImages = [];

  File? compressedFile;
  late double walletBalance;
  late int freeAds;

  List<TextEditingController> mandatoryDescriptionControllers = [];

  @override
  void dispose() {
    for (var controller in mandatoryDescriptionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> pickImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        compressedFile = File(pickedImage.path);
        // filePath = pickedImage.path; // Update filePath
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Center(
            child: Text("Post Event",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                )),
          )),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 15),
                child: GestureDetector(
                  onTap: () {
                    // pickImage();
                    pickImage();
                  },
                  child: Stack(
                    children: [
                      Container(
                          height: 180,
                          decoration:
                              const BoxDecoration(color: Color(0xfff2f2f2)),
                          child: Center(
                              child: compressedFile != null
                                  ? Image.file(
                                      compressedFile!,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(
                                      Icons.add_photo_alternate_outlined))),
                      Positioned(
                        bottom: 0,
                        right: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            onPressed: () => pickImage(),
                            icon: Icon(
                              Icons.add_a_photo,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text(
                "Add Title",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 3, bottom: 18),
                child: reusabletextField("add title here ...", titleController),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 14, bottom: 4),
                child: Text(
                  "Event Description",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  child: TextFormField(
                    controller: descriptionController,
                    maxLines: 15,
                    minLines: 5,
                    autocorrect: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xffD9D9D9), width: 0.3),
                          borderRadius: BorderRadius.circular(10)),
                      hintText: "add a description here ...",
                    ),
                  ),
                ),
              ),
              const Text(
                "Location",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 3, bottom: 16),
                child: reusabletextField(
                  "add location here ...",
                  locationController,
                ),
              ),
              const Text(
                "Time",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8, top: 3, bottom: 16),
                child: reusabletextField(
                  "add time here ...",
                  timeController,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    final firestore = FirebaseFirestore.instance;

                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    var imageName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    var storageRef = FirebaseStorage.instance
                        .ref()
                        .child('image_banner/$imageName.jpg');
                    var uploadTask = storageRef.putFile(compressedFile!);
                    var downloadUrl =
                        await (await uploadTask).ref.getDownloadURL();

                    CollectionReference ref = firestore.collection("events");

                    String docId = ref.doc().id;

                    firestore.collection("events").doc(docId).set({
                      "title": titleController.text,
                      "description": descriptionController.text,
                      "location": locationController.text,
                      "time": timeController.text,
                      "image": downloadUrl.toString(),
                      "doc_id": docId,
                      "reminders": 0
                    });
                    Navigator.pop(context);
                    titleController.clear();
                    descriptionController.clear();
                    locationController.clear();
                    timeController.clear();
                    compressedFile = null;
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 17, right: 24),
                    child: Container(
                      width: 206,
                      height: 54,
                      decoration: const BoxDecoration(
                          color: Color(0xff1F212D),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: const Center(
                        child: Text(
                          "Post",
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

Container reusabletextField(String hint, TextEditingController controller,
    {TextInputType? type}) {
  return Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 4),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 1, color: const Color(0xffD9D9D9))),
    child: Center(
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsetsDirectional.only(start: 4),
          hintStyle: const TextStyle(color: Color(0xffC1C1C1)),
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    ),
  );
}
