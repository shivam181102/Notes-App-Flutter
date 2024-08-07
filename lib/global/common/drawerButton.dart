import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notes/Providers/NoteProvider.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:provider/provider.dart';

class DrawerbuttonComp extends StatefulWidget {
  const DrawerbuttonComp({super.key});

  @override
  State<DrawerbuttonComp> createState() => _DrawerbuttonCompState();
}

class _DrawerbuttonCompState extends State<DrawerbuttonComp> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _noteProvider = Provider.of<Noteprovider>(context, listen: true);
    final _notedataProvider = _noteProvider.scaffoldKey;
    return GestureDetector(
      onTap: () {
        
        _notedataProvider.currentState?.openDrawer();
      },
      child: SizedBox(
        width: 20,
        height: 20,
        child: Icon(
          Icons.menu,
          color: light,
        ),
      ),
    );
  }
}
