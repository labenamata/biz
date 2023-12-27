import 'package:chasier/constans.dart';
import 'package:flutter/material.dart';

class FinishOrder extends StatefulWidget {
  FinishOrder({Key? key}) : super(key: key);

  @override
  _FinishOrderState createState() => _FinishOrderState();
}

class _FinishOrderState extends State<FinishOrder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListView(
        children: [
          Container(
            //height: 103,
            margin: EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          theme == "dark" ? warnaPrimerDark : warnaPrimerLight),
                  color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 34,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "#99 Meja : 5",
                            style: TextStyle(
                                color: theme == "dark"
                                    ? warnaTitleDark
                                    : warnaTitleLight),
                          ),
                          Spacer(),
                          Icon(
                            Icons.alarm,
                            color: theme == "dark"
                                ? warnaTitleDark
                                : warnaTitleLight,
                          ),
                          Text("10:00",
                              style: TextStyle(
                                  color: theme == "dark"
                                      ? warnaTitleDark
                                      : warnaTitleLight))
                        ],
                      )),
                  //Expanded(
                  //child:
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListTile(
                          dense: true,
                          title: Text(
                            "Es Teh",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          leading: Text("2"),
                          subtitle: Text("Jangan Manis2"),
                        ),
                      ],
                    ),
                  )
                  //)
                ],
              ),
            ),
          ),
          Container(
            //height: 103,
            margin: EdgeInsets.only(bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color:
                          theme == "dark" ? warnaPrimerDark : warnaPrimerLight),
                  color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                  borderRadius: BorderRadius.circular(5)),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 34,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "#100 Meja : 2",
                            style: TextStyle(
                                color: theme == "dark"
                                    ? warnaTitleDark
                                    : warnaTitleLight),
                          ),
                          Spacer(),
                          Icon(
                            Icons.alarm,
                            color: theme == "dark"
                                ? warnaTitleDark
                                : warnaTitleLight,
                          ),
                          Text("11:00",
                              style: TextStyle(
                                  color: theme == "dark"
                                      ? warnaTitleDark
                                      : warnaTitleLight))
                        ],
                      )),
                  //Expanded(
                  //child:
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListTile(
                          dense: true,
                          title: Text(
                            "Es Jeruk",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          leading: Text("2"),
                          subtitle: Text(""),
                        ),
                      ],
                    ),
                  )
                  //)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
