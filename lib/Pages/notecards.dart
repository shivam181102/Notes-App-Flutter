import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/global/common/colorpalet.dart';

class Notecards extends StatefulWidget {
  bool viewStyle;
  Notecards({super.key, required this.viewStyle});

  @override
  State<Notecards> createState() => _NotecardsState();
}

class _NotecardsState extends State<Notecards> {
  List<dynamic>? _data;
  @override
  void initState() {
    super.initState();
    loadJson();
  }

  Future<void> loadJson() async {
    final response = await rootBundle.loadString('lib/global/common/data.json');
    final data = await json.decode(response);
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return masgrid();
  }

  Widget masgrid() {
    return _data == null
        ? const Center(child: CircularProgressIndicator())
        : MasonryGridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: _data?.length,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.viewStyle ? 2 : 1),
            itemBuilder: (context, index) {
              final profile = _data?[index];
              return Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      border: Border.all(color: mid2(), width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  // height: (index + 1) * 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile['name'],
                        style: TextStyle(
                            color: light(),
                            fontWeight: FontWeight.w700,
                            fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        profile['phone'].toString(),
                        style: TextStyle(color: light()),
                      ),
                      SizedBox(height: 8),
                      Text(
                        profile['address'],
                        style: TextStyle(color: light()),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Age: ${profile['age'].toString()}",
                        style: TextStyle(color: light()),
                      )
                    ],
                  ),
                ),
              );
            });
  }
}
