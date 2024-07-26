import 'package:flutter/material.dart';
import 'package:notes/global/common/colorpalet.dart';

class AddDrawer extends StatefulWidget {
  const AddDrawer({super.key});

  @override
  State<AddDrawer> createState() => _AddDrawerState();
}

class _AddDrawerState extends State<AddDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.camera_alt_outlined,
              color: light,
            ),
            title: Text(
              'Take photo',
              style: TextStyle(color: light),
            ),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.image_outlined,
              color: light,
            ),
            title: Text(
              "Add image",
              style: TextStyle(color: light),
            ),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.brush_outlined,
              color: light,
            ),
            title: Text(
              'Drawing',
              style: TextStyle(color: light),
            ),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.mic_none_outlined,
              color: light,
            ),
            title: Text(
              'Recording',
              style: TextStyle(color: light),
            ),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.check_box_outlined,
              color: light,
            ),
            title: Text(
              'Tick boxes',
              style: TextStyle(color: light),
            ),
            onTap: () {
              // Handle the action here
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
