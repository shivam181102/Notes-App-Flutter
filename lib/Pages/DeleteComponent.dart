import 'package:flutter/material.dart';
import 'package:notes/Database/SQFlite/noteslocaldatamanager.dart';
import 'package:notes/Pages/notecards.dart';
import 'package:notes/Providers/NoteProvider.dart';
import 'package:notes/Providers/SelectionProvider.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/common/drawerButton.dart';
import 'package:provider/provider.dart';

class Deletecomponent extends StatefulWidget {
  const Deletecomponent({super.key});

  @override
  State<Deletecomponent> createState() => _DeletecomponentState();
}

class _DeletecomponentState extends State<Deletecomponent> {
  NotesLocalDataManager _notesLocalDataManager = NotesLocalDataManager();
  @override
  Widget build(BuildContext context) {
    final _noteProvider = Provider.of<Noteprovider>(context, listen: true);
    return Scaffold(
      endDrawerEnableOpenDragGesture: true,
      backgroundColor: dark,
      appBar: AppBar(
        backgroundColor: dark,
        leading: DrawerbuttonComp(),
        title: Text(
          "Recently Deleted",
          style: TextStyle(color: light),
        ),
        actions: [
          Consumer<Selectionprovider>(builder: (context, value, child) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: IconButton(
                onPressed: () {
                  if (value.selectedNotes.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: dark,
                        title: Text(
                            "These Notes will be deleted parmanently...!!!!\nAre you Sure? ", style: TextStyle(color: light, fontSize: 15),),
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: mid,
                              child: Text("No",style: TextStyle(color: light) ),
                            ),
                            
                            MaterialButton(
                              onPressed: () async{
                               await _notesLocalDataManager
                                    .parmanentdeleteNote(value.selectedNotes);
                                    setState(() {
                                      
                                    });
                                Navigator.pop(context);
                              },
                              color: mid,
                              child: Text("Yes", style: TextStyle(color: light)),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.delete,
                  size: 25,
                  color: light,
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              onPressed: () {
                _noteProvider.toggleGridViewFormat();
              },
              icon: Icon(
                _noteProvider.gridViewFormat
                    ? Icons.grid_view
                    : Icons.table_rows,
                size: 25,
                color: light,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: NotesCardsDisplayComp(
            routeName: "home",
            dataFunction: _notesLocalDataManager.getDeletedData(),
          )),
        ],
      ),
    );
  }
}
