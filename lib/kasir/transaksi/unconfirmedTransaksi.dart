import 'package:chasier/bloc/blocDetail.dart';
import 'package:chasier/bloc/blocPenjualan.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/kasir/pesanan/kelolaPesanan.dart';
import 'package:chasier/komponen/customPrimaryButton.dart';
import 'package:chasier/model/modelPenjualan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final formatter = new NumberFormat("#,###", "id_ID");

class UnconfirmedTransaksi extends StatefulWidget {
  const UnconfirmedTransaksi({Key? key}) : super(key: key);

  @override
  _UnconfirmedTransaksiState createState() => _UnconfirmedTransaksiState();
}

class _UnconfirmedTransaksiState extends State<UnconfirmedTransaksi> {
  late Future<ParsingPenjualan> futurePenjualan;

  @override
  void initState() {
    PenjualanBloc penjualanData = BlocProvider.of<PenjualanBloc>(context);
    penjualanData.add(PenjualanRefresh("unpaid", 0, ""));
    DetailPenjualanBloc detailBloc =
        BlocProvider.of<DetailPenjualanBloc>(context);
    detailBloc.add(DetailUni());
    super.initState();
    //futurePenjualan = ParsingPenjualan.getPenjualan();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
      onRefresh: () async {
        PenjualanBloc penjualanData = BlocProvider.of<PenjualanBloc>(context);

        return penjualanData.add(PenjualanRefresh("unpaid", 0, ""));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            buildCari(),
            SizedBox(
              height: 10,
            ),
            BlocBuilder<PenjualanBloc, PenjualanState>(
                builder: (context, state) {
              if (state is PenjualanKosong) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is PenjualanError) {
                PenjualanError penjualanError = state;
                Future.delayed(Duration(seconds: 1), () {
                  return ScaffoldMessenger.of(context)
                      .showSnackBar(snackBar(penjualanError.message));
                });
                return Center(
                  child: Icon(Icons.error),
                );
              } else {
                PenjualanLoaded penjualanLoaded = state as PenjualanLoaded;
                return FutureBuilder<ParsingPenjualan>(
                    future: penjualanLoaded.penjualan,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Expanded(
                            child: Center(
                                child: CircularProgressIndicator(
                          color: theme == "dark"
                              ? warnaPrimerDark
                              : warnaPrimerLight,
                        )));
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      } else {
                        var newFormat = DateFormat("dd-MMM-yyyy HH:mm");

                        return Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                            itemCount: snapshot.data!.dataPenjualan.length,
                            itemBuilder: (BuildContext context, int index) {
                              var date = DateTime.parse(snapshot
                                  .data!.dataPenjualan[index].time
                                  .toString());
                              var tanggal = newFormat.format(date);
                              return pesanan(
                                id: snapshot.data!.dataPenjualan[index].id,
                                nama: snapshot.data!.dataPenjualan[index].name
                                    .toUpperCase(),
                                meja: snapshot
                                    .data!.dataPenjualan[index].table.name,
                                total:
                                    snapshot.data!.dataPenjualan[index].total,
                                tanggal: tanggal,
                                ppn: snapshot.data!.dataPenjualan[index].ppn,
                                subtotal: snapshot
                                    .data!.dataPenjualan[index].subtotal,
                              );
                            },
                          ),
                        );
                      }

                      // By default, show a loading spinner.
                    });
              }
            }),
          ],
        ),
      ),
    );
  }

  SnackBar snackBar(String mesg) {
    return SnackBar(
      content: Text(mesg),
    );
  }

  Container buildCari() {
    TextEditingController cariController = TextEditingController();
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 16),
      height: 47,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: theme == "dark"
                          ? warnaLightDark.withOpacity(0.4)
                          : warnaPrimerLight),
                  borderRadius: BorderRadius.circular(5)),
              child: TextField(
                controller: cariController,
                cursorColor:
                    theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                style: TextStyle(
                    color: theme == "dark" ? warnaTeksDark : warnaTeksLight),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nama",
                    hintStyle: TextStyle(
                        color: theme == "dark"
                            ? warnaTeksDark
                            : warnaTeksLight.withOpacity(0.3)),
                    prefixIcon: Icon(
                      Icons.search,
                      color:
                          theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                    )),
              ),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          SizedBox(
              width: 100,
              child: CustomPrimaryButton(
                  title: "Cari",
                  onpress: () {
                    PenjualanBloc penjualanData =
                        BlocProvider.of<PenjualanBloc>(context);
                    penjualanData.add(
                        PenjualanRefresh("unpaid", 0, cariController.text));
                  })),
        ],
      ),
    );
  }

  Widget pesanan(
      {required int id,
      required String nama,
      required String meja,
      required int total,
      required int subtotal,
      required int ppn,
      required String tanggal}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
        onTap: () {
          DetailPenjualanBloc detailBloc =
              BlocProvider.of<DetailPenjualanBloc>(context);
          detailBloc.add(DetailCari(id));
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => KelolaPesanan(
                        id: id,
                        name: nama,
                        meja: meja,
                        total: total,
                        subtotal: subtotal,
                        ppn: ppn,
                        tanggal: tanggal,
                      )));
        },
        child: Container(
          height: 66,
          //margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              // color: theme == "dark"
              //     ? warnaLightDark.withOpacity(0.4)
              //     : warnaPrimerLight,
              border: Border.all(color: warnaPrimer),
              borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    nama,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: warnaTeks),
                  ),
                  Row(
                    children: [
                      Text(
                        meja,
                        style: TextStyle(fontSize: 14, color: warnaTeks),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: warnaPrimer),
                        child: Text(
                          tanggal,
                          style: TextStyle(fontSize: 12, color: warnaTitle),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Text(
                "IDR " + formatter.format(total),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: warnaTeks),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
