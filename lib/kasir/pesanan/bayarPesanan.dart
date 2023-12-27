import 'package:chasier/bloc/blocPenjualan.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/komponen/customPrimaryButton.dart';
import 'package:chasier/komponen/customSecondaryButton.dart';
import 'package:chasier/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

final formatter = new NumberFormat("#,###", "id_ID");

class BayarPesanan extends StatefulWidget {
  final int id;
  final String name;
  final int tot;
  final String tanggal;
  final int subtotal;
  final int ppn;
  BayarPesanan(
      {required this.name,
      required this.tot,
      required this.subtotal,
      required this.ppn,
      required this.id,
      required this.tanggal});
  @override
  _BayarPesananState createState() => _BayarPesananState();
}

class _BayarPesananState extends State<BayarPesanan> {
  late String hitung;
  late int kembali;
  late int total;
  double diskon = 0;
  late int totalBayar;
  late int idPenjualan;
  late int subtotal;
  late int ppn;
  @override
  void initState() {
    hitung = "0";
    kembali = 0;
    subtotal = widget.subtotal;
    total = widget.tot;
    diskon = 0;
    totalBayar = widget.tot;
    ppn = widget.ppn;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      backgroundColor: warnaPrimer,
      title: Text(widget.name.toUpperCase(),
          style: TextStyle(
              fontSize: 24, color: warnaTitle, fontWeight: FontWeight.bold)),
      centerTitle: true,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: warnaTitle,
        ),
      ),
      elevation: 0,
    );

    return Scaffold(
      backgroundColor:
          theme == "dark" ? warnaBackgroundDark : warnaBackgroundLight,
      appBar: appBar,
      body: OrientationBuilder(
        builder: (BuildContext context, Orientation orientation) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: buildTotal()),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: buildPPN()),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          buildDiskon(),
                          SizedBox(
                            height: 10,
                          ),
                          buildTotalBayar(),
                          SizedBox(
                            height: 10,
                          ),
                          buildBayar(),
                          SizedBox(
                            height: 10,
                          ),
                          buildKembali(),
                        ],
                      ),
                    ),
                  ),
                ),
                VerticalDivider(
                  color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                  thickness: 2,
                ),
                Expanded(child: buildHitung())
                //decoration: BoxDecoration(color: Colors.red),
              ],
            ),
          );
        },
      ),
    );
  }

  Container buildHitung() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: aTombol("1")),
                Expanded(child: aTombol("2")),
                Expanded(child: aTombol("3")),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: aTombol("4")),
                Expanded(child: aTombol("5")),
                Expanded(child: aTombol("6")),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: aTombol("7")),
                Expanded(child: aTombol("8")),
                Expanded(child: aTombol("9")),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: aTombol("000")),
                Expanded(child: aTombol("0")),
                Expanded(child: aTombol("C")),
              ],
            ),
          ),
          Material(
              borderRadius: BorderRadius.circular(5),
              color: warnaSekunder,
              child: InkWell(
                  onTap: () {
                    if (int.parse(hitung) >= totalBayar) {
                      PenjualanBloc penjualanBloc =
                          BlocProvider.of<PenjualanBloc>(context);
                      penjualanBloc.add(PenjualanBayar(
                          idPenjualan: widget.id,
                          diskon: diskon.toInt(),
                          total: totalBayar));
                      showMyDialog(context);
                    }
                  },
                  child: Container(
                      height: 50,
                      child: Center(
                          child: Text("Bayar",
                              style: TextStyle(
                                  color: warnaTitle, fontSize: 20))))))
        ],
      ),
    );
  }

  Container aTombol(String name) {
    return Container(
      child: Material(
        color: Colors.transparent,
        borderOnForeground: true,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        //color: theme=="dark"?warnaSekunderDark:warnaSekunderLight,
        child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            splashColor: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
            // borderSide: BorderSide(color: border_color),
            // shape: new RoundedRectangleBorder(
            //     borderRadius: new BorderRadius.circular(10.0)),
            onTap: () {
              if (hitung == "" || hitung == "0" && name != "C") {
                setState(() {
                  hitung = name;
                });
              } else if (name == "C") {
                setState(() {
                  hitung = "0";
                  kembali = 0;
                });
              } else if (hitung != "" || hitung != "0") {
                setState(() {
                  hitung = hitung + name;
                  if (int.parse(hitung) > totalBayar) {
                    kembali = int.parse(hitung) - totalBayar;
                  } else {
                    kembali = 0;
                  }
                });
              }
            },
            child: Center(
              child: Text(
                name,
                style: TextStyle(fontSize: 30, color: warnaTeks),
              ),
            )),
      ),
    );
  }

  Container buildBayar() {
    double tinggiWidget = 50;

    return Container(
      height: tinggiWidget,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: warnaPrimer),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Bayar",
            style: TextStyle(fontSize: 20, color: warnaTeks),
          ),
          Text(formatter.format(int.parse(hitung)),
              style: TextStyle(fontSize: 20, color: warnaTeks))
        ],
      ),
    );
  }

  Container buildKembali() {
    double tinggiWidget = 50;

    return Container(
      height: tinggiWidget,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          border: Border.all(color: warnaPrimer),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Kembali",
            style: TextStyle(fontSize: 20, color: warnaTeks),
          ),
          Text(formatter.format(kembali),
              style: TextStyle(fontSize: 20, color: warnaTeks))
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    TextEditingController jumlahController = TextEditingController();

    // set up the AlertDialog
    Dialog diskon2 = Dialog(
        child: Card(
      child: SingleChildScrollView(
        child: Container(
          height: 200,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Center(
                  child: Text(
                    "DISKON",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: warnaPrimer),
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  onChanged: (text) {
                    if (text.isNotEmpty && text != " ") {
                      var jdiskon = int.parse(text) / 100 * subtotal;

                      jumlahController.text = jdiskon.toString();
                    }
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefix: Text("% "),
                      hintText: "Persen"),
                  //controller: persenController,
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    border: Border.all(color: warnaPrimer),
                    borderRadius: BorderRadius.circular(5)),
                child: TextField(
                  controller: jumlahController,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: "Nominal"),
                  //controller: jumlahController,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Expanded(
                        child: CustomSecondaryButton(
                            title: "Batal",
                            onpress: () {
                              Navigator.pop(context);
                            })),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: CustomPrimaryButton(
                            title: "OK",
                            onpress: () {
                              setState(() {
                                diskon = double.parse(jumlahController.text);
                                totalBayar = subtotal + ppn - diskon.toInt();
                              });
                              Navigator.pop(context);
                            }))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return diskon2;
      },
    );
  }

  Container buildDiskon() {
    double tinggiWidget = 50;
    return Container(
      height: tinggiWidget,
      //padding: EdgeInsets.symmetric(horizontal: 16),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              showAlertDialog(context);
            },
            child: CircleAvatar(
                backgroundColor: warnaPrimer,
                child: Icon(Icons.add, color: warnaTitle)),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              height: tinggiWidget,
              decoration: BoxDecoration(
                  border: Border.all(color: warnaPrimer),
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Diskon ",
                    style: TextStyle(fontSize: 20, color: warnaTeks),
                  ),
                  Text(formatter.format(diskon),
                      style: TextStyle(fontSize: 20, color: warnaTeks)),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildTotal() {
    double tinggiWidget = 50;
    return Container(
      height: tinggiWidget,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [warnaPrimer, warnaSekunder]),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total ",
            style: TextStyle(fontSize: 20, color: warnaTitle),
          ),
          Text(formatter.format(subtotal),
              style: TextStyle(
                  fontSize: 20,
                  color: theme == "dark" ? warnaTitleDark : warnaTitleLight))
        ],
      ),
    );
  }

  Container buildPPN() {
    double tinggiWidget = 50;
    return Container(
      height: tinggiWidget,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [warnaPrimer, warnaSekunder]),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "PPN ",
            style: TextStyle(fontSize: 20, color: warnaTitle),
          ),
          Text(formatter.format(ppn),
              style: TextStyle(
                  fontSize: 20,
                  color: theme == "dark" ? warnaTitleDark : warnaTitleLight))
        ],
      ),
    );
  }

  Container buildTotalBayar() {
    double tinggiWidget = 50;
    return Container(
      height: tinggiWidget,
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [warnaPrimer, warnaSekunder]),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Total Bayar",
            style: TextStyle(fontSize: 20, color: warnaTitle),
          ),
          Text(formatter.format(totalBayar),
              style: TextStyle(fontSize: 20, color: warnaTitle))
        ],
      ),
    );
  }

  void showMyDialog(BuildContext contexts) {
    showDialog<void>(
        context: contexts,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Card(
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: BlocBuilder<PenjualanBloc, PenjualanState>(
                      builder: (context, state) {
                    if (state is PenjualanKosong) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: theme == "dark"
                                ? warnaPrimerDark
                                : warnaPrimerLight,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Loading"),
                        ],
                      );
                    } else if (state is PenjualanError) {
                      PenjualanError penjualanError = state;
                      Future.delayed(new Duration(seconds: 1), () {
                        Navigator.pop(context);
                        FocusScope.of(context).unfocus();
                        Fluttertoast.showToast(msg: penjualanError.message);
                      });
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: theme == "dark"
                                ? warnaPrimerDark
                                : warnaPrimerLight,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Error"),
                        ],
                      );
                    } else {
                      Future.delayed(new Duration(seconds: 1), () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StatusPage(
                                  priceType: "cash",
                                  bayar: int.parse(hitung),
                                  kembali: kembali,
                                  id: widget.id,
                                  name: widget.name,
                                  tanggal: widget.tanggal,
                                  total: totalBayar)),
                        );
                      });
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(
                            color: theme == "dark"
                                ? warnaPrimerDark
                                : warnaPrimerLight,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Loading"),
                        ],
                      );
                    }
                  })),
            ),
          );
        });
  }

  SnackBar snackBar(String mesg) {
    return SnackBar(
      content: Text(mesg),
    );
  }
}
