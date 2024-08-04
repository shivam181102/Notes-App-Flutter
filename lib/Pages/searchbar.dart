import 'dart:developer';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/Database/FirebaseStorage/ProfileImageStorage.dart';
import 'package:notes/Providers/NoteProvider.dart';
import 'package:notes/global/common/ImageImport.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/common/drawerButton.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SearchBarComp extends StatefulWidget {
  bool viewStyle;
  final viewStyleChange;

  SearchBarComp(
      {super.key, required this.viewStyle, required this.viewStyleChange});

  @override
  State<SearchBarComp> createState() => _SearchBarCompState();
}

class _SearchBarCompState extends State<SearchBarComp> {
  Uint8List? _profileImage;
  Profileimagestorage _profileimagestorage = Profileimagestorage();
  static String ProfURL = "";
  @override
  void initState() {
    // TODO: implement initState
    if (ProfURL == "") {
      getProfileURL();
    }
    super.initState();
  }

  void getProfileURL() async {
    ProfURL = await _profileimagestorage.getUrl();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 0.0)
            ]),
            child: TextField(
              cursorColor: mid2,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: mid,
                  contentPadding: const EdgeInsets.all(0),
                  hintText: "Search Your Notes",
                  hintStyle: const TextStyle(color: light),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: DrawerbuttonComp(),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: IconButton(
                              onPressed: () {
                                widget.viewStyleChange();
                              },
                              icon: Icon(
                                widget.viewStyle
                                    ? Icons.grid_view
                                    : Icons.table_rows,
                                size: 25,
                                color: light,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: GestureDetector(
                              onTap: ProfileDialogueBox,
                              child: CircleAvatar(
                                child: ProfURL != ''
                                    ? CircleAvatar(
                                        backgroundColor: dark,
                                        backgroundImage: NetworkImage(ProfURL),
                                      )
                                    : const CircleAvatar(
                                        backgroundColor: dark,
                                        child: Icon(
                                          Icons.account_circle_outlined,
                                          color: light,
                                          size: 41,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide.none)),
            ),
          ),
        ],
      ),
    );
  }

  Future ProfileDialogueBox() {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.close,
            color: light,
          ),
        ),
        backgroundColor: mid,
        title: const Text(
          "Profile",
          style: TextStyle(color: light),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ProfURL != ""
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(ProfURL),
                      )
                    : const CircleAvatar(
                        backgroundColor: dark,
                        radius: 64,
                        child: Icon(
                          Icons.account_circle,
                          color: light,
                          size: 64,
                        ),
                      ),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: () {
                          selectImage();
                          Navigator.pop(context);
                          ProfileDialogueBox();
                        },
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: light,
                        )))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(FirebaseAuth.instance.currentUser!.email.toString(),
                style: const TextStyle(color: light)),
          ],
        ),
      ),
    );
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery) ?? _profileImage;
    setState(() {
      _profileImage = img;
    });
    await _profileimagestorage.saveProfile(file: _profileImage!);
    getProfileURL();
  }
}
