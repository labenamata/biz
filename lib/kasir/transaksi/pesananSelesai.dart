import 'package:chasier/bloc/blocDetail.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/database/pengaturanQuery.dart';
import 'package:chasier/model/modelPenjualan.dart';
import 'package:chasier/print.dart';
import 'package:chasier/printKembali.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:chasier/pengaturan.dart' as pengaturan;

final formatter = new NumberFormat("#,###", "id_ID");

class PesananSelesai extends StatelessWidget {
  const PesananSelesai({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: buildList(),
    );
  }
}

Container buildIcon(int isTakeaway) {
  if (isTakeaway == 0) {
    return Container(
      child: Center(
        child: Icon(Icons.dining),
      ),
    );
  } else {
    return Container(
      child: Center(
        child: Icon(Icons.shopping_basket_outlined),
      ),
    );
  }
}

Container buildPesanan(
    {String? nama,
    int? harga,
    int? jumlah,
    int? total,
    int? isTakeaway,
    String? note,
    String? variant}) {
  return Container(
    margin: EdgeInsets.only(bottom: 10),
    height: 150,
    child: Container(
      decoration: BoxDecoration(
          border: Border.all(color: warnaPrimer),
          borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Container(
              padding: EdgeInsets.only(left: 16),
              height: 100,
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildIcon(isTakeaway!),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          nama!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: warnaTeks),
                        ),
                        Text(
                          "Varian : " + variant!,
                          style: TextStyle(color: warnaTeks),
                        ),
                        Text(
                          jumlah!.toString() + " x " + formatter.format(harga),
                          style: TextStyle(color: warnaTeks),
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  Text(
                    formatter.format(total),
                    style: TextStyle(
                        color:
                            theme == "dark" ? warnaTeksDark : warnaTeksLight),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              )),
          Divider(
            height: 2,
            thickness: 2,
            //color: theme=="dark"?warnaPrimerDark:warnaPrimerLight,
          ),
          Expanded(
            child: Container(
              //width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Note : ",
                    style: TextStyle(fontSize: 12, color: warnaTeks),
                  ),
                  Text(
                    note!,
                    style: TextStyle(fontSize: 12, color: warnaTeks),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

void cetakPrinter({
  required PrinterBluetooth printer,
  required Future<ParsingPenjualan> detailPenjualan,
}) async {
  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();

  _printerManager.selectPrinter(printer);
  const PaperSize paper = PaperSize.mm58;
  final PosPrintResult res = await _printerManager.printTicket(await struk2(
    paper: paper,
    detailPenjualan: detailPenjualan,
  ));
  Fluttertoast.showToast(msg: res.msg);
}

Container buildList() {
  return Container(child:
      BlocBuilder<DetailPenjualanBloc, DetailState>(builder: (context, state) {
    if (state is DetailLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
        ),
      );
    } else if (state is DetailError) {
      Fluttertoast.showToast(
          msg: state.message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return Center(
        child: Icon(Icons.error),
      );
    } else if (state is DetailUn) {
      return Center(
        child: Text("Detail Pesanan"),
      );
    } else {
      DetailLoaded detailLoaded = state as DetailLoaded;
      return FutureBuilder<ParsingPenjualan>(
          future: detailLoaded.detailPenjualan,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
              ));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount:
                          snapshot.data!.dataPenjualan[0].groupDetails.length,
                      itemBuilder: (BuildContext context, int index) {
                        return buildPesanan(
                            nama: snapshot.data!.dataPenjualan[0]
                                .groupDetails[index].menu.name
                                .toUpperCase(),
                            harga: snapshot.data!.dataPenjualan[0]
                                .groupDetails[index].menu.price,
                            jumlah: snapshot.data!.dataPenjualan[0]
                                .groupDetails[index].qty,
                            total: snapshot.data!.dataPenjualan[0]
                                .groupDetails[index].menu.price,
                            note: snapshot.data!.dataPenjualan[0]
                                .groupDetails[index].note,
                            variant: snapshot.data!.dataPenjualan[0]
                                .groupDetails[index].varian.name,
                            isTakeaway: snapshot.data!.dataPenjualan[0]
                                .groupDetails[index].isTakeaway);
                      },
                    ),
                  ),
                  Material(
                    color: warnaSekunder,
                    borderRadius: BorderRadius.circular(5),
                    child: InkWell(
                      splashColor: Colors.white,
                      onTap: () {
                        cetakPrinter(
                            printer: pengaturan.printerBluetooth,
                            detailPenjualan: detailLoaded.detailPenjualan);
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            "Cetak Struk Kembali",
                            style: TextStyle(color: warnaTitle),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          });
    }
  }));
}
