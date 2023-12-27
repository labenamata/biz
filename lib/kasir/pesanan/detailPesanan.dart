import 'package:chasier/bloc/blocDetail.dart';
import 'package:chasier/bloc/blocPenjualan.dart';
import 'package:chasier/bloc/blocTemp.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/kasir/pesanan/bayarPesanan.dart';
import 'package:chasier/komponen/customPrimaryButton.dart';
import 'package:chasier/komponen/customSecondaryButton.dart';
import 'package:chasier/menu/menuList.dart';
import 'package:chasier/model/modelPenjualan.dart';
import 'package:chasier/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

final formatter = new NumberFormat("#,###", "id_ID");

class DetailPesanan extends StatelessWidget {
  final int id;
  final int total;
  final int subtotal;
  final int ppn;
  final String meja;
  final String tanggal;
  final String name;
  DetailPesanan(
      {required this.total,
      required this.subtotal,
      required this.ppn,
      required this.meja,
      required this.tanggal,
      required this.id,
      required this.name});
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [Expanded(child: buildList(context))],
                ),
              ),
              VerticalDivider(
                color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                thickness: 1,
                width: 20,
              ),
              Expanded(
                  child: Column(
                children: [
                  buildTotal(),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  Spacer(),
                  CustomPrimaryButton(
                      title: "Tambah Pesanan",
                      onpress: () {
                        TempBloc penjualanData =
                            BlocProvider.of<TempBloc>(context);
                        penjualanData.add(EmptyTemp());
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MenuList(1, "tambah", name, id)),
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  BlocBuilder<DetailPenjualanBloc, DetailState>(
                      builder: (context, state) {
                    if (state is DetailLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: warnaPrimer,
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
                    } else {
                      DetailLoaded detailLoaded = state as DetailLoaded;
                      return FutureBuilder<ParsingPenjualan>(
                          future: detailLoaded.detailPenjualan,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return CustomPrimaryButton(
                                  title: "Belum Ada Produk",
                                  onpress: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (context) => BayarPesanan(
                                    //             name: name,
                                    //             tot: total,
                                    //             id: id,
                                    //             tanggal: tanggal)));
                                  });
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            } else {
                              return CustomPrimaryButton(
                                  title: "Konfirmasi Pesanan",
                                  onpress: () {
                                    if (snapshot
                                            .data!.dataPenjualan[0].priceType ==
                                        "cash") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BayarPesanan(
                                                      name: snapshot.data!
                                                          .dataPenjualan[0].name
                                                          .toUpperCase(),
                                                      subtotal: snapshot
                                                          .data!
                                                          .dataPenjualan[0]
                                                          .subtotal,
                                                      ppn: snapshot.data!
                                                          .dataPenjualan[0].ppn,
                                                      tot: snapshot
                                                          .data!
                                                          .dataPenjualan[0]
                                                          .total,
                                                      id: snapshot.data!
                                                          .dataPenjualan[0].id,
                                                      tanggal: tanggal)));
                                    } else {
                                      PenjualanBloc penjualanBloc =
                                          BlocProvider.of<PenjualanBloc>(
                                              context);
                                      penjualanBloc.add(PenjualanBayar(
                                          idPenjualan: snapshot
                                              .data!.dataPenjualan[0].id,
                                          diskon: 0,
                                          total: snapshot
                                              .data!.dataPenjualan[0].total));
                                      Future.delayed(new Duration(seconds: 1),
                                          () {
                                        //Navigator.pop(context);
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => StatusPage(
                                                  priceType: snapshot
                                                      .data!
                                                      .dataPenjualan[0]
                                                      .priceType,
                                                  bayar: snapshot.data!
                                                      .dataPenjualan[0].total,
                                                  kembali: 0,
                                                  id: snapshot.data!
                                                      .dataPenjualan[0].id,
                                                  name: name,
                                                  tanggal: tanggal,
                                                  total: snapshot.data!
                                                      .dataPenjualan[0].total)),
                                        );
                                      });
                                    }
                                  });
                            }
                          });
                    }
                  })
                ],
              )),
            ],
          ),
        );
      },
    );
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

  showAlertDialog(BuildContext context, int idPenjualan, int idDetail) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        DetailPenjualanBloc detailPenjualan =
            BlocProvider.of<DetailPenjualanBloc>(context);
        detailPenjualan.add(DetailHapus(idPenjualan, idDetail));
        Navigator.pop(context);
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Konfirmasi"),
      content: Text("Yakin Akan Menghapus Pesanan ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showEditNote(
      BuildContext context, int idPenjualan, int idDetail, String name) {
    TextEditingController noteController = TextEditingController();
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              child: Card(
                child: SingleChildScrollView(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      height: 200,
                      width: 400,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(name,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              //Text("Note : "),
                              Expanded(
                                child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: warnaPrimer,
                                        ),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: TextField(
                                        controller: noteController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Note"))),
                              ),
                            ],
                          ),
                          SizedBox(
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: CustomPrimaryButton(
                                          title: "OK",
                                          onpress: () {
                                            if (noteController.text.isEmpty ||
                                                noteController.text == " ") {
                                              Navigator.pop(context);
                                            } else {
                                              DetailPenjualanBloc
                                                  detailPenjualan = BlocProvider
                                                      .of<DetailPenjualanBloc>(
                                                          context);
                                              detailPenjualan.add(
                                                  DetailUpdateNote(
                                                      penjualanId: idPenjualan,
                                                      detailId: idDetail,
                                                      note:
                                                          noteController.text));
                                              Navigator.pop(context);
                                            }
                                          })),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: CustomSecondaryButton(
                                          title: "Batal",
                                          onpress: () {
                                            Navigator.pop(context);
                                          })),
                                ],
                              ))
                        ],
                      )),
                ),
              ));
        });
  }

  Container buildPesanan(
      {int? idDetail,
      String? nama,
      int? harga,
      int? jumlah,
      int? total,
      BuildContext? context,
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
                            jumlah!.toString() +
                                " x " +
                                formatter.format(harga),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(color: warnaTeks),
                          )
                        ],
                      ),
                    ),
                    //Spacer(),
                    Text(
                      formatter.format(total),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          color:
                              theme == "dark" ? warnaTeksDark : warnaTeksLight),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () {
                          showAlertDialog(context!, id, idDetail!);
                        },
                        child: SizedBox(
                            height: 100,
                            width: 50,
                            child: Container(
                              color: warnaPrimer,
                              child: Icon(Icons.delete, color: warnaTitle),
                            ))),
                    GestureDetector(
                        onTap: () {
                          showEditNote(context!, id, idDetail!, nama);
                          //showAlertDialog(context!, id, idDetail!);
                        },
                        child: SizedBox(
                            height: 100,
                            width: 50,
                            child: Container(
                              color: warnaSekunder,
                              child: Icon(Icons.edit, color: warnaTitle),
                            ))),
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

  Container buildList(BuildContext context) {
    return Container(child: BlocBuilder<DetailPenjualanBloc, DetailState>(
        builder: (context, state) {
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
                return ListView.builder(
                  itemCount:
                      snapshot.data!.dataPenjualan[0].groupDetails.length,
                  itemBuilder: (BuildContext context, int index) {
                    return buildPesanan(
                        context: context,
                        idDetail: snapshot
                            .data!.dataPenjualan[0].detailPenjualan[index].id,
                        nama: snapshot.data!.dataPenjualan[0]
                            .detailPenjualan[index].menu.name
                            .toUpperCase(),
                        harga: snapshot.data!.dataPenjualan[0]
                            .detailPenjualan[index].menu.price,
                        jumlah: snapshot.data!.dataPenjualan[0]
                            .detailPenjualan[index].qty == 0 ? 1 :snapshot.data!.dataPenjualan[0]
                            .detailPenjualan[index].qty,
                        total: snapshot.data!.dataPenjualan[0]
                            .detailPenjualan[index].menu.price,
                        note: snapshot
                            .data!.dataPenjualan[0].detailPenjualan[index].note,
                        variant: snapshot.data!.dataPenjualan[0]
                            .detailPenjualan[index].varian.name,
                        isTakeaway: snapshot.data!.dataPenjualan[0]
                            .detailPenjualan[index].isTakeaway);
                  },
                );
              }
            });
      }
    }));
  }

  Container buildTotal() {
    return Container(
        height: 160,
        decoration: BoxDecoration(
            border: Border.all(color: warnaPrimer),
            borderRadius: BorderRadius.circular(5)),
        child: BlocBuilder<DetailPenjualanBloc, DetailState>(
            builder: (context, state) {
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
          } else {
            DetailLoaded detailLoaded = state as DetailLoaded;
            return FutureBuilder<ParsingPenjualan>(
                future: detailLoaded.detailPenjualan,
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
                    return Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.,
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 34,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  snapshot.data!.dataPenjualan[0].table.name,
                                  style: TextStyle(color: warnaTeks),
                                ),
                                Text(tanggal,
                                    style: TextStyle(color: warnaTeks))
                              ],
                            )),
                        Divider(
                          color: warnaPrimer,
                        ),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              //color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal",
                                style:
                                    TextStyle(color: warnaTeks, fontSize: 20),
                              ),
                              Text(
                                  formatter.format(
                                      snapshot.data!.dataPenjualan[0].subtotal),
                                  style:
                                      TextStyle(color: warnaTeks, fontSize: 20))
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              //color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "PPN",
                                style:
                                    TextStyle(color: warnaTeks, fontSize: 20),
                              ),
                              Text(
                                  formatter.format(
                                      snapshot.data!.dataPenjualan[0].ppn),
                                  style:
                                      TextStyle(color: warnaTeks, fontSize: 20))
                            ],
                          ),
                        )),
                        Expanded(
                            child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              //color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: TextStyle(
                                    color: warnaTeks,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  formatter.format(
                                      snapshot.data!.dataPenjualan[0].total),
                                  style: TextStyle(
                                      color: warnaTeks,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ))
                      ],
                    );
                  }
                });
          }
        }));
  }
}
