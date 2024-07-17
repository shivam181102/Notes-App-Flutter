import 'package:flutter/material.dart';
import 'package:notes/global/common/colorpalet.dart';

// ignore: must_be_immutable
class SearchBarComp extends StatefulWidget {
  bool viewStyle;
  final viewStyleChange;
  SearchBarComp(
      {super.key,
      required GlobalKey<ScaffoldState> scaffoldKey,
      required this.viewStyle,
      required this.viewStyleChange})
      : _scaffoldKey = scaffoldKey;
  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  State<SearchBarComp> createState() => _SearchBarCompState();
}

class _SearchBarCompState extends State<SearchBarComp> {
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
              decoration: InputDecoration(
                  filled: true,
                  fillColor: mid(),
                  contentPadding: const EdgeInsets.all(0),
                  hintText: "Search Your Notes",
                  hintStyle: TextStyle(color: light()),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () {
                        widget._scaffoldKey.currentState?.openDrawer();
                      },
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(
                          Icons.menu,
                          color: light(),
                        ),
                      ),
                    ),
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
                                color: light(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: IconButton(
                              onPressed: () {
                                print("account");
                              },
                              icon: Icon(
                                Icons.account_circle,
                                size: 25,
                                color: light(),
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
}
