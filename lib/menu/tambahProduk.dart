import 'package:chasier/bloc/blocTemp.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/model/modelMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final formatter = new NumberFormat("#,###", "id_ID");

class TambahProduk extends StatefulWidget {
  TambahProduk({
    required this.priceId,
    required this.context,
    required this.id,
    required this.name,
    required this.price,
    required this.variant,
    required this.stok,
  });

  final int priceId;
  final BuildContext context;
  final int id;
  final String name;
  final int price;
  final int stok;
  final List<Varian> variant;

  @override
  _TambahProdukState createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  late int jumlah;
  int _varian = 1;

  bool takeaway = false;
  TextEditingController noteController = TextEditingController();
  @override
  void initState() {
    jumlah = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        //height: 200,
        width: 500,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.name.toUpperCase(),
                        style: TextStyle(fontSize: 16),
                      ),
                      Text("IDR " + formatter.format(widget.price),
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: comboVarian()),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: jumlahProduk(),
                    ),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: noteProduk()),
                buildTombolOk(context)
              ]),
        ),
      ),
    );
  }

  Container buildTombolOk(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "Batal",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )))),
          SizedBox(
            width: 16,
          ),
          Expanded(
              child: Container(
                  decoration: BoxDecoration(
                      color: warnaSekunder,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          TempBloc tempBloc =
                              BlocProvider.of<TempBloc>(context);
                          tempBloc.add(TempAdd(
                              id: widget.id,
                              isTakeaway: widget.priceId != 1
                                  ? 1
                                  : takeaway
                                      ? 1
                                      : 0,
                              varianId: widget.variant.isNotEmpty ? _varian : 0,
                              varian: widget.variant.isNotEmpty
                                  ? widget.variant[_varian - 1].name
                                  : "",
                              name: widget.name,
                              price: widget.price,
                              qty: jumlah,
                              note: noteController.text));
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Text(
                            "OK",
                            style: TextStyle(color: warnaTitle),
                          ),
                        ),
                      )))),
        ],
      ),
    );
  }

  Row noteProduk() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: warnaPrimer),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: TextField(
              controller: noteController,
              cursorColor: warnaTeks,
              style: TextStyle(color: warnaTeks),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Note",
                hintStyle: TextStyle(color: warnaTeks.withOpacity(0.3)),
              ),
            ),
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text("Takeaway")),
        Checkbox(
          checkColor: Colors.white,
          value: takeaway,
          onChanged: (bool? value) {
            setState(() {
              takeaway = value!;
            });
          },
        )
      ],
    );
  }

  Container jumlahProduk() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: warnaPrimer),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      height: 50,
      // decoration:
      //     BoxDecoration(color: surface_color.withOpacity(0.2)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
                height: 50,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      splashColor: warnaPrimer,
                      onTap: () {
                        setState(() {
                          if (jumlah > 1) {
                            jumlah--;
                          }
                        });
                      },
                      child: Icon(
                        Icons.remove,
                        //color: Colors.,
                      )),
                )),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: Text(jumlah.toString(),
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
          Expanded(
            child: Container(
                height: 50,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      splashColor: warnaPrimer,
                      onTap: () {
                        setState(() {
                          if (jumlah < widget.stok) {
                            jumlah++;
                          }
                        });
                      },
                      child: Icon(
                        Icons.add,
                        //color: text_color,
                      )),
                )),
          ),
        ],
      ),
    );
  }

  Container comboVarian() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: warnaPrimer),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          hint: Text("Varian", style: TextStyle(color: Colors.black)),
          style: TextStyle(color: Colors.black),
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
          value: _varian,
          items: widget.variant.map((value) {
            return DropdownMenuItem(
              child: Text(value.name),
              value: value.id,
            );
          }).toList(),
          onChanged: (int? value) {
            setState(() {
              _varian = value!;
            });
          },
        ),
      ),
    );
  }
}
