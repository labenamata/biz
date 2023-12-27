import 'package:chasier/bloc/blocDetail.dart';
import 'package:chasier/bloc/blocTotalPenjualan.dart';
import 'package:chasier/kasir/transaksi/pesananSelesai.dart';
import 'package:chasier/model/modelTotalPenjualan.dart';
import 'package:flutter/material.dart';
import 'package:chasier/constans.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ConfirmedTransaksi extends StatefulWidget {
  ConfirmedTransaksi({Key? key}) : super(key: key);

  @override
  _ConfirmedTransaksiState createState() => _ConfirmedTransaksiState();
}

class _ConfirmedTransaksiState extends State<ConfirmedTransaksi> {
  final formatNumber = new NumberFormat("#,###", "id_ID");
  DateTime selectedDate = DateTime.now();
  var formatTanggal = DateFormat('yyyy/MM/dd');
  TextEditingController _dateController = TextEditingController();
  @override
  void initState() {
    initializeDateFormatting();
    //var formatTanggal = DateFormat('yyyy/MM/dd');
    var searchDate = formatTanggal.format(DateTime.now());
    _dateController.text = DateFormat("dd-MMM-yyyy").format(DateTime.now());
    TotalPenjualanBloc penjualanData =
        BlocProvider.of<TotalPenjualanBloc>(context);

    penjualanData.add(GetTotalPenjualan(searchDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [buildDate(), buildReport()],
              ),
            ),
            VerticalDivider(
              width: 10,
              color: warnaPrimer,
            ),
            Expanded(child: PesananSelesai())
          ],
        ));
  }

  SnackBar snackBar(String mesg) {
    return SnackBar(
      content: Text(mesg),
    );
  }

  Widget buildReport() {
    return BlocBuilder<TotalPenjualanBloc, TotalPenjualanState>(
        builder: (context, state) {
      if (state is TotalPenjualanLoading) {
        return Expanded(
          child: Center(
            child: CircularProgressIndicator(
              color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
            ),
          ),
        );
      } else if (state is TotalPenjualanError) {
        TotalPenjualanError totalPenjualanError = state;
        Future.delayed(Duration(seconds: 1), () {
          Fluttertoast.showToast(msg: totalPenjualanError.message);
        });
        return Expanded(
          child: Center(
            child: Icon(Icons.error),
          ),
        );
      } else {
        TotalPenjualanLoaded penjualanLoaded = state as TotalPenjualanLoaded;
        return FutureBuilder<ParsingTotalPenjualan>(
            future: penjualanLoaded.data,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                    child: CircularProgressIndicator(
                  color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                ));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return Expanded(
                  child: Column(
                    //mainAxisSize: MainAxisSize.max,
                    children: [
                      total(snapshot.data!.total),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.penjualan.length,
                          itemBuilder: (BuildContext context, int index) {
                            return pesanan(
                                snapshot.data!.penjualan[index].id,
                                snapshot.data!.penjualan[index].name
                                    .toUpperCase(),
                                snapshot.data!.penjualan[index].table.id,
                                snapshot.data!.penjualan[index].total
                                    .toString());
                          },
                        ),
                      ),
                    ],
                  ),
                );

                // By default, show a loading spinner.
              }
            });
      }
    });
  }

  Widget buildDate() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _selectDate(context);
        },
        child: Container(
          //padding: EdgeInsets.symmetric(horizontal: 16),
          height: 47,
          decoration: BoxDecoration(
              border: Border.all(
                  color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight),
              borderRadius: BorderRadius.circular(5)),
          child: TextField(
            style: TextStyle(
                color: theme == "dark"
                    ? warnaTeksDark
                    : warnaTeksLight.withOpacity(0.4)),
            controller: _dateController,
            enabled: false,
            decoration: InputDecoration(
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.calendar_today,
                  color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
                )),
          ),
        ),
      ),
    );
  }

  Future _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null) {
      TotalPenjualanBloc penjualanData =
          BlocProvider.of<TotalPenjualanBloc>(context);

      penjualanData.add(GetTotalPenjualan(formatTanggal.format(picked)));
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat("dd-MMM-yyyy").format(selectedDate);
      });
    }
  }

  Container total(int total) {
    return Container(
        height: 66,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [warnaPrimer, warnaSekunder]),
            borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Total Penjualan",
              style: TextStyle(
                  fontSize: 16,
                  color: theme == "dark" ? warnaTitleDark : warnaTitleLight),
            ),
            Text(
              "IDR " + formatNumber.format(total),
              style: TextStyle(
                  fontSize: 16,
                  color: theme == "dark" ? warnaTitleDark : warnaTitleLight),
            ),
          ],
        ));
  }

  Material pesanan(int id, String nama, int meja, String total) {
    return Material(
      child: InkWell(
        splashColor: warnaPrimer,
        onTap: () {
          DetailPenjualanBloc detailBloc =
              BlocProvider.of<DetailPenjualanBloc>(context);
          detailBloc.add(DetailCari(id));
        },
        child: Container(
          height: 66,
          margin: EdgeInsets.only(top: 10),
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
                        color:
                            theme == "dark" ? warnaTeksDark : warnaTeksLight),
                  ),
                  Text(
                    "Meja : " + meja.toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color:
                            theme == "dark" ? warnaTeksDark : warnaTeksLight),
                  ),
                ],
              ),
              Text(
                "IDR " + formatNumber.format(int.parse(total)),
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme == "dark" ? warnaTeksDark : warnaTeksLight),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
