import 'package:flutter/material.dart';
import 'package:notes/global/common/colorpalet.dart';
import 'package:notes/global/models/colorDrawerModel.dart';

class Colordrawer extends StatefulWidget {
  final updateColor;
  Colordrawer({
    this.updateColor,
    super.key,
  });

  @override
  State<Colordrawer> createState() => _ColordrawerState();
}

class _ColordrawerState extends State<Colordrawer> {
  late Colordrawermodel _colordrawermodel;
  late List<ColorClass> colorlist;
  @override
  void initState() {
    // TODO: implement initState
    _colordrawermodel = Colordrawermodel(updateFun: colorchange);
    colorlist = _colordrawermodel.getColor();
    super.initState();
  }

  void colorchange(Color change) {
    widget.updateColor(change);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Colour",
              style: TextStyle(color: light, fontSize: 25),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 50,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(
                        width: 15,
                      ),
                  itemCount: colorlist.length,
                  itemBuilder: (context, index) {
                    final res = colorlist[index];
                    return GestureDetector(
                      onTap: () {
                        _colordrawermodel.updateSelected(res.id);
                      },
                      child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: res.clo,
                              border: res.selected
                                  ? Border.all(color: light, width: 3)
                                  : null,
                              borderRadius: BorderRadius.circular(50)),
                          child: res.selected
                              ? Icon(
                                  Icons.check,
                                  color: light,
                                )
                              : null),
                    );
                  }),
            )
          ],
        ));
  }
}
