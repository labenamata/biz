import 'package:chasier/bloc/blocPenjualan.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/model/modelPenjualan.dart';
import 'package:chasier/printPesanan.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
//import 'package:chasier/model/modelTotalPenjualan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:chasier/pengaturan.dart' as pengaturan;

class NewOrder extends StatefulWidget {
  NewOrder({Key? key}) : super(key: key);

  @override
  _NewOrderState createState() => _NewOrderState();
}

@override
class _NewOrderState extends State<NewOrder> {
  bool isChek = true;
  List<int> selectedList = [];
  void initState() {
    PenjualanBloc penjualanData = BlocProvider.of<PenjualanBloc>(context);
    penjualanData.add(PenjualanRefresh("paid", 0, ""));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PenjualanBloc penjualanData = BlocProvider.of<PenjualanBloc>(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: BlocBuilder<PenjualanBloc, PenjualanState>(
            builder: (context, state) {
          if (state is PenjualanKosong) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PenjualanError) {
            PenjualanError penjualanError = state;
            Fluttertoast.showToast(msg: penjualanError.message);

            return Container(
              child: Center(
                child: Icon(Icons.error_outline_rounded),
              ),
            );
          } else {
            PenjualanLoaded penjualanLoaded = state as PenjualanLoaded;
            return FutureBuilder<ParsingPenjualan>(
                future: penjualanLoaded.penjualan,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                      color:
                          theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                    ));
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else {
                    return RefreshIndicator(
                        color: theme == "dark"
                            ? warnaPrimerDark
                            : warnaPrimerLight,
                        onRefresh: () async {
                          setState(() {
                            selectedList = [];
                          });
                          return penjualanData.add(OrderRefresh("paid", 0, ""));
                        },
                        child: buildDaftarPesanan(snapshot, context));
                  }
                });
          }
        }));
  }

  bool cekStatus(int value) {
    if (value == 0) {
      return false;
    } else {
      return true;
    }
  }

  void cetakPrinter(int id) async {
    Future<ParsingPenjualan> penjualan;

    var printer = pengaturan.printerBluetooth;
    PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
    List<Penjualan> dataPenjualan = [];

    penjualan = ParsingPenjualan.getDetail(id);

    await penjualan.then((value) {
      dataPenjualan = value.dataPenjualan;
    });

    if (dataPenjualan.isNotEmpty) {
      if (printer.name != "test") {
        _printerManager.selectPrinter(printer);
        const PaperSize paper = PaperSize.mm58;

        //status.then((value) => Fluttertoast.showToast(msg: value));

        final PosPrintResult res = await _printerManager.printTicket(
            await printPesanan(paper: paper, dataPenjualan: penjualan));
        Fluttertoast.showToast(msg: res.msg);
      }
    }

    //return Text(res.msg);
  }

  Container buildDaftarPesanan(
      AsyncSnapshot<ParsingPenjualan> snapshot, BuildContext context) {
    var formatWaktu = DateFormat('HH:mm');
    PenjualanBloc penjualanData = BlocProvider.of<PenjualanBloc>(context);

    return Container(
      child: ListView.builder(
        // separatorBuilder: (context, index) => SizedBox(
        //   height: 16,
        // ),
        //physics: NeverScrollableScrollPhysics(),
        //shrinkWrap: true,
        itemCount: snapshot.data!.dataPenjualan.length,
        itemBuilder: (context, index) {
          if (snapshot.data!.dataPenjualan[index].groupDetails.length != 0) {
            return Dismissible(
              key: ObjectKey(snapshot.data!.dataPenjualan.elementAt(index)),
              onDismissed: (direction) {
                penjualanData.add(UpdateOrder(
                    idPenjualan: snapshot.data!.dataPenjualan[index].id));
                setState(() {
                  snapshot.data!.dataPenjualan.removeAt(index);
                });
              },
              child: Container(
                //height: 103,
                margin: EdgeInsets.only(bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                      //border: Border.all(color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight),
                      //color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [warnaPrimer, warnaSekunder]),
                              //borderRadius: BorderRadius.circular(5),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5))),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "#" +
                                    snapshot.data!.dataPenjualan[index].id
                                        .toString() +
                                    " " +
                                    snapshot
                                        .data!.dataPenjualan[index].table.name
                                        .toString(),
                                style: TextStyle(
                                    color: theme == "dark"
                                        ? warnaTitleDark
                                        : warnaTitleLight),
                              ),
                              Spacer(),
                              Text(
                                  snapshot.data!.dataPenjualan[index].name
                                      .toUpperCase(),
                                  style: TextStyle(
                                      color: theme == "dark"
                                          ? warnaTitleDark
                                          : warnaTitleLight)),
                              Spacer(),
                              Icon(
                                Icons.alarm,
                                color: theme == "dark"
                                    ? warnaTitleDark
                                    : warnaTitleLight,
                              ),
                              Text(
                                  formatWaktu.format(DateTime.parse(snapshot
                                      .data!.dataPenjualan[index].time)),
                                  style: TextStyle(
                                      color: theme == "dark"
                                          ? warnaTitleDark
                                          : warnaTitleLight))
                            ],
                          )),
                      //Expanded(
                      //child:
                      Container(
                        //padding: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            //color: theme == "dark" ? warnaLightDark.withOpacity(0.4) : warnaPrimerLight.withOpacity(0.5),
                            border: Border.all(color: warnaPrimer),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5))),
                        child: Column(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ListView.builder(
                                // separatorBuilder: (context, index) => Divider(
                                //       thickness: 2,
                                //     ),
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.dataPenjualan[index]
                                    .groupDetails.length,
                                itemBuilder: (context, indexs) {
                                  int idDetail = snapshot
                                      .data!
                                      .dataPenjualan[index]
                                      .groupDetails[indexs]
                                      .id;

                                  return CheckboxListTile(
                                    dense: true,
                                    activeColor: warnaPrimer,
                                    checkColor: Colors.white,
                                    selectedTileColor: warnaPrimer,
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.dataPenjualan[index]
                                              .groupDetails[indexs].menu.name
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: warnaTeks),
                                        ),
                                        Text(
                                          "Varian " +
                                              snapshot
                                                  .data!
                                                  .dataPenjualan[index]
                                                  .groupDetails[indexs]
                                                  .varian
                                                  .name,
                                          style: TextStyle(
                                              fontSize: 14,
                                              //fontWeight: FontWeight.bold,
                                              color: warnaTeks),
                                        ),
                                      ],
                                    ),
                                    value: selectedList.contains(idDetail),
                                    onChanged: (value) {
                                      if (value!) {
                                        setState(() {
                                          selectedList.add(idDetail);
                                        });
                                      } else {
                                        setState(() {
                                          selectedList.removeWhere(
                                              (element) => element == idDetail);
                                        });
                                      }
                                    },
                                    secondary: Container(
                                        height: 40,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: snapshot
                                                        .data!
                                                        .dataPenjualan[index]
                                                        .groupDetails[indexs]
                                                        .isTakeaway ==
                                                    0
                                                ? warnaPrimer
                                                : Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                            child: Text(
                                          snapshot.data!.dataPenjualan[index]
                                              .groupDetails[indexs].qty
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: 16, color: warnaTitle),
                                        ))),
                                    subtitle: Text(
                                      "Note : " +
                                          snapshot.data!.dataPenjualan[index]
                                              .groupDetails[indexs].note,
                                      style: TextStyle(color: warnaTeks),
                                    ),
                                  );
                                }),
                            Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: Material(
                                      color: warnaSekunder,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Konfirmasi"),
                                                content: Text(
                                                    "Cetak Kembali Pesanan ?"),
                                                actions: [
                                                  TextButton(
                                                    child: Text("No"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text("Yes"),
                                                    onPressed: () {
                                                      cetakPrinter(snapshot
                                                          .data!
                                                          .dataPenjualan[index]
                                                          .id);

                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 40,
                                          child: Center(
                                            child: Text(
                                              "Cetak Kembali",
                                              style: TextStyle(
                                                  color: theme == "dark"
                                                      ? warnaTitleDark
                                                      : warnaTitleLight),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Material(
                                      color: warnaPrimer,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      child: InkWell(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Konfirmasi"),
                                                content: Text(
                                                    "Pesanan Telah Selesai Semua ?"),
                                                actions: [
                                                  TextButton(
                                                    child: Text("No"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text("Yes"),
                                                    onPressed: () {
                                                      setState(() {
                                                        penjualanData.add(UpdateOrder(
                                                            idPenjualan: snapshot
                                                                .data!
                                                                .dataPenjualan[
                                                                    index]
                                                                .id));
                                                        snapshot
                                                            .data!.dataPenjualan
                                                            .removeAt(index);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 40,
                                          child: Center(
                                            child: Text(
                                              "Finish",
                                              style: TextStyle(
                                                  color: theme == "dark"
                                                      ? warnaTitleDark
                                                      : warnaTitleLight),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                      //)
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
