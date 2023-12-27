import 'package:chasier/bloc/blocMenus.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/komponen/customPrimaryButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailMenu extends StatefulWidget {
  final int id;
  final String name;
  final int stok;
  final int visible;
  DetailMenu({
    required this.id,
    required this.name,
    required this.stok,
    required this.visible,
  });

  @override
  _DetailMenuState createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  bool visible = true;
  TextEditingController stokController = TextEditingController();
  @override
  void initState() {
    visible = widget.visible == 1 ? true : false;
    stokController.text = widget.stok.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: Card(
          child: Container(
              height: 250,
              width: 200,
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: warnaPrimer,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Center(
                          child: Text(
                        widget.name.toUpperCase(),
                        style: TextStyle(color: warnaTitle),
                      ))),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(color: warnaPrimer),
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        controller: stokController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: InputBorder.none, prefix: Text("Stock : ")),
                      )),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: warnaPrimer),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      children: [
                        Checkbox(
                            value: visible,
                            onChanged: (value) {
                              setState(() {
                                visible = value!;
                              });
                            }),
                        Text("Tampilkan di Daftar Menu")
                      ],
                    ),
                  ),
                  //Spacer(),
                  SizedBox(
                    height: 50,
                    child: CustomPrimaryButton(
                      title: "Update",
                      onpress: () {
                        MenusBloc menusBloc =
                            BlocProvider.of<MenusBloc>(context);
                        menusBloc.add(UpdateStok(
                            id: widget.id,
                            visible: visible ? 1 : 0,
                            stok: int.parse(stokController.text)));
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              )),
        ));
  }
}
