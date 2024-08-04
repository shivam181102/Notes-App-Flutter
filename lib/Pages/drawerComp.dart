// ignore_for_file: file_names, unused_import, must_be_immutable

import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/common/toast.dart';

class Drawercomp extends StatefulWidget {
  Widget? currentPage;
  int? selectedIndex;
  final setIndex;
  Drawercomp({super.key, this.currentPage, this.selectedIndex, this.setIndex});

  @override
  State<Drawercomp> createState() => _DrawercompState();
}

class _DrawercompState extends State<Drawercomp> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: mid,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              "Google Keep",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w400),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          _drawerItem(1, Icons.lightbulb_outline_rounded, 'Notes'),
          _drawerItem(2, Icons.notifications, 'Reminders'),
          _drawerItem(4, Icons.add, 'Create New Label'),
          _drawerItem(3, Icons.archive, 'Archive'),
          _drawerItem(5, Icons.delete_forever_outlined, 'Deleted'),
          _drawerItem(6, Icons.settings, 'Settings'),
          _drawerItem(7, Icons.help_outline, 'Help & feedback'),
          _drawerItem(8, Icons.logout, 'Logout'),
        ],
      ),
    );
  }

  ListTile _drawerItem(int index, IconData icon, String title) {
    bool isSelected = index == widget.selectedIndex;
    return ListTile(
      selected: isSelected,
      selectedTileColor: mid2,
      leading: Icon(
        icon,
        color: isSelected ? light2 : light,
      ),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? light2 : light),
      ),
      onTap: () async {
        widget.setIndex(index);
        setState(() {
          widget.currentPage = null;
          Navigator.pop(context);
        });
        if (title == 'Logout') {
          _signout(context);
          Navigator.popAndPushNamed(context, 'login');
        }
      },
    );
  }

  Future<void> _signout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
