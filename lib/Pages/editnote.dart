import 'package:flutter/material.dart';
import 'package:notes/global/common/colorpalet.dart';

class Editnote extends StatefulWidget {
  const Editnote({super.key});

  @override
  State<Editnote> createState() => _EditnoteState();
}

class _EditnoteState extends State<Editnote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark(),
      appBar: AppBar(
        backgroundColor: mid(),
        iconTheme: IconThemeData(color: light()),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.push_pin),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.notification_add_outlined),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.archive_outlined),
          ),
          SizedBox(
            width: 10,
          )
        ],
      ),
      body: Expanded(
          child: Column(
        children: [
          TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
          )
        ],
      )),
    );
  }
}
