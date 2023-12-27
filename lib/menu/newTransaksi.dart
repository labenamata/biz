import 'package:chasier/bloc/blocDetail.dart';
import 'package:chasier/bloc/blocTemp.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/komponen/customPrimaryButton.dart';
import 'package:chasier/menu/saveTransaksi.dart';
import 'package:chasier/model/modelTemp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final formatter = new NumberFormat("#,###", "id_ID");

class NewTransaksi extends StatefulWidget {
  final int priceId;
  final String status;
  final int id;
  NewTransaksi({
    required this.priceId,
    required this.status,
    required this.id,
  });

  @override
  _NewTransaksiState createState() => _NewTransaksiState();
}

class _NewTransaksiState extends State<NewTransaksi> {
  @override
  void initState() {
    TempBloc penjualanData = BlocProvider.of<TempBloc>(context);
    penjualanData.add(GetTemp());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: BlocBuilder<TempBloc, TempState>(builder: (context, state) {
            if (state is TempLoading) {
              return Center(child: Text("Belum Ada Transaksi"));
            } else {
              TempLoaded tempLoaded = state as TempLoaded;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FutureBuilder<List<TempModel>>(
                        future: tempLoaded.data,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: Text("Belum Ada Transaksi"));
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          } else {
                            return Expanded(
                              child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: warnaPrimer))),
                                    //color: Colors.grey,
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        iconTakeaway(
                                            snapshot.data![index].isTakeaway),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                snapshot.data![index].name,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(snapshot.data![index].qty
                                                      .toString() +
                                                  " x " +
                                                  formatter.format(snapshot
                                                      .data![index].price)),
                                              Text("Varian : " +
                                                  snapshot.data![index].varian),
                                              Text("Note : " +
                                                  snapshot.data![index].note),
                                            ],
                                          ),
                                        ),
                                        Text(
                                            formatter.format(
                                                snapshot.data![index].total),
                                            style: TextStyle(fontSize: 16)),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            TempBloc tempBloc =
                                                BlocProvider.of<TempBloc>(
                                                    context);
                                            tempBloc.add(HapusTemp(
                                                menuId: snapshot
                                                    .data![index].menuId));
                                          },
                                          child: SizedBox(
                                              height: 100,
                                              width: 50,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: warnaPrimer),
                                                child: Center(
                                                    child: Icon(Icons.delete,
                                                        color: Colors.white)),
                                              )),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );

                            // By default, show a loading spinner.

                          }
                        }),
                    Divider(
                      color: warnaPrimer,
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          Text(
                            formatter.format(tempLoaded.total),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ]);
            }
          }),
        ),
        CustomPrimaryButton(
            title: "Simpan",
            onpress: () {
              if (widget.status == "baru") {
                showDialog<void>(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return SaveTransaksi(priceId: widget.priceId);
                    });
              } else {
                DetailPenjualanBloc detailBloc =
                    BlocProvider.of<DetailPenjualanBloc>(context);
                detailBloc.add(TambahPesanan(widget.id));
                Navigator.pop(context);
              }
            })
      ],
    ));
  }

  Container iconTakeaway(int status) {
    if (status == 1) {
      return Container(
        child: Icon(Icons.shopping_basket_outlined),
      );
    } else {
      return Container(
        child: Icon(Icons.dining),
      );
    }
  }
}
