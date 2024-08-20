import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/Providers/NoteProvider.dart';
import 'package:notes/Providers/SelectionProvider.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/common/toast.dart';
import 'package:notes/global/models/NotesModel.dart';
import 'package:provider/provider.dart';

class Notesgridviewcomponent extends StatefulWidget {
  final String routename;
  final List<NotesModel> snapData;

  Notesgridviewcomponent({
    super.key,
    required this.snapData,
    required this.routename,
  });

  @override
  State<Notesgridviewcomponent> createState() => _NotesgridviewcomponentState();
}

class _NotesgridviewcomponentState extends State<Notesgridviewcomponent> {
  

  @override
  Widget build(BuildContext context) {
    final _noteProvider = Provider.of<Noteprovider>(context, listen: true);
    final _SelectionProvider = Provider.of<Selectionprovider>(context, listen: true);
    
    return MasonryGridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(10),
      itemCount: widget.snapData.length,
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _noteProvider.gridViewFormat ? 2 : 1,
      ),
      itemBuilder: (context, index) {
        final note = widget.snapData[index];
        return GestureDetector(
          onTap: () {
            if (_SelectionProvider.selectedNotes.isNotEmpty) {
              log(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;");
                if (_SelectionProvider.selectedNotes.contains(note)) {
                  _SelectionProvider.removeSelected(note);
                } else {
                  _SelectionProvider.addSelected(note);
                }
             
            } else if(note.deleted == false){
              Navigator.pushNamed(context, 'editnote', arguments: {
                "note": note,
                "routename": widget.routename
              });
            }else{
              showToast(message: "Cannot Edit Deleted Note", color: Colors.red);
            }
          },
          onLongPress: () {
            
              if (_SelectionProvider.selectedNotes.contains(note)) {
                _SelectionProvider.removeSelected(note);
              } else {
                _SelectionProvider.addSelected(note);
              }
           
          },
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Stack(
              children: [
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: note.color,
                    border: _SelectionProvider.selectedNotes.contains(note)
                        ? Border.all(color: light, width: 1)
                        : Border.all(color: mid2, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.title,
                        style: TextStyle(color: light, fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Text(
                        note.body,
                        style: TextStyle(color: light),
                      ),
                    ],
                  ),
                ),
                if (_SelectionProvider.selectedNotes.contains(note))
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: light,
                      ),
                      margin: EdgeInsets.all(5),
                      child: Icon(Icons.check, color: dark, weight: 100),
                    ),
                    top: -5,
                    left: -5,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
