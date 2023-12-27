import 'package:chasier/constans.dart';
import 'package:flutter/material.dart';

class NewOrder extends StatefulWidget {
  NewOrder({Key? key}) : super(key: key);

  @override
  _NewOrderState createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  bool pesanan1 = false;
  bool pesanan2 = false;
  bool pesanan3 = false;

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
                            "#101 Meja : 5",
                            style: TextStyle(
                                color: theme == "dark"
                                    ? warnaTitleDark
                                    : warnaTitleLight),
                          ),
                          Spacer(),
                          Icon(Icons.alarm,
                              color: theme == "dark"
                                  ? warnaTitleDark
                                  : warnaTitleLight),
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
                        CheckboxListTile(
                          dense: true,
                          activeColor: theme == "dark"
                              ? warnaPrimerDark
                              : warnaPrimerLight,
                          title: Text(
                            "Es teh",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          value: pesanan1,
                          onChanged: (bool? value) {
                            setState(() {
                              pesanan1 = value!;
                            });
                          },
                          secondary: Text("2"),
                          subtitle: Text("jangan manis manis"),
                        ),
                        CheckboxListTile(
                          dense: true,
                          activeColor: theme == "dark"
                              ? warnaPrimerDark
                              : warnaPrimerLight,
                          title: Text(
                            "Es jeruk",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          value: pesanan2,
                          onChanged: (bool? value) {
                            setState(() {
                              pesanan2 = value!;
                            });
                          },
                          secondary: Text("2"),
                          subtitle: Text("1 manis,1 tidak"),
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
                            "#102 Meja : 2",
                            style: TextStyle(
                                color: theme == "dark"
                                    ? warnaTitleDark
                                    : warnaTitleLight),
                          ),
                          Spacer(),
                          Icon(Icons.alarm,
                              color: theme == "dark"
                                  ? warnaTitleDark
                                  : warnaTitleLight),
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
                        CheckboxListTile(
                          dense: true,
                          activeColor: theme == "dark"
                              ? warnaPrimerDark
                              : warnaPrimerLight,
                          title: Text(
                            "Teh Hangat",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          value: pesanan3,
                          onChanged: (bool? value) {
                            setState(() {
                              pesanan3 = value!;
                            });
                          },
                          secondary: Text("2"),
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

  Container buildList(int noorder, int meja, String jam) {
    return Container(
      //height: 103,
      margin: EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight),
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
                      "#$noorder Meja : $meja",
                      style: TextStyle(
                          color: theme == "dark"
                              ? warnaTitleDark
                              : warnaTitleLight),
                    ),
                    Spacer(),
                    Icon(Icons.alarm,
                        color:
                            theme == "dark" ? warnaTitleDark : warnaTitleLight),
                    Text(jam,
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
                  CheckboxListTile(
                    dense: true,
                    activeColor:
                        theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                    title: Text(
                      "Nasi Goreng",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    value: pesanan1,
                    onChanged: (bool? value) {
                      setState(() {
                        pesanan1 = value!;
                      });
                    },
                    secondary: Text("2"),
                    subtitle: Text("1 pedes,1 tidak"),
                  ),
                  CheckboxListTile(
                    dense: true,
                    activeColor:
                        theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                    title: Text(
                      "Mie Goreng",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    value: pesanan2,
                    onChanged: (bool? value) {
                      setState(() {
                        pesanan2 = value!;
                      });
                    },
                    secondary: Text("2"),
                    subtitle: Text("1 pedes,1 tidak"),
                  ),
                ],
              ),
            )
            //)
          ],
        ),
      ),
    );
  }

  CheckboxListTile buildCheckPesanan(
      String produk, int jumlah, String note, bool ischeked) {
    return CheckboxListTile(
      dense: true,
      title: Text(
        produk,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      ),
      value: ischeked,
      onChanged: (bool? value) {
        setState(() {
          ischeked = value!;
        });
      },
      secondary: Text(jumlah.toString()),
      subtitle: Text(note),
    );
  }
}
