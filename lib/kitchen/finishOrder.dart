import 'package:chasier/bloc/blocOrderFinish.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/model/modelPenjualan.dart';
import 'package:chasier/printPesanan.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:chasier/pengaturan.dart' as pengaturan;

class FinishOrder extends StatefulWidget {
  FinishOrder({Key? key}) : super(key: key);

  @override
  _FinishOrderState createState() => _FinishOrderState();
}

class _FinishOrderState extends State<FinishOrder> {
  bool isChek = true;
  List<int> selectedList = [];
  DateTime selectedDate = DateTime.now();
  var formatTanggal = DateFormat('yyyy/MM/dd');
  TextEditingController _dateController = TextEditingController();

  void initState() {
    var searchDate = formatTanggal.format(DateTime.now());
    _dateController.text = DateFormat("dd-MMM-yyyy").format(DateTime.now());
    OrderFinishBloc penjualanData = BlocProvider.of<OrderFinishBloc>(context);
    penjualanData.add(OrderFinishRefresh("paid", 1, "", searchDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    OrderFinishBloc penjualanData = BlocProvider.of<OrderFinishBloc>(context);
    var searchDate = formatTanggal.format(DateTime.now());
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: RefreshIndicator(
          color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
          onRefresh: () async {
            setState(() {
              selectedList = [];
            });
            return penjualanData.add(OrderFinishRefresh(
                "paid", 1, "", formatTanggal.format(selectedDate)));
          },
          child: Column(
            children: [
              buildDate(),
              SizedBox(height: 16),
              BlocBuilder<OrderFinishBloc, OrderFinishState>(
                  builder: (context, state) {
                if (state is OrderFinishLoading) {
                  return Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (state is OrderFinishError) {
                  OrderFinishError penjualanError = state;
                  Fluttertoast.showToast(msg: penjualanError.message);
                  return Container(
                    child: Center(
                      child: Icon(Icons.error_outline_rounded),
                    ),
                  );
                } else {
                  OrderFinishLoaded penjualanLoaded =
                      state as OrderFinishLoaded;
                  return FutureBuilder<ParsingPenjualan>(
                      future: penjualanLoaded.penjualan,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                              child: CircularProgressIndicator(
                            color: theme == "dark"
                                ? warnaPrimerDark
                                : warnaPrimerLight,
                          ));
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        } else {
                          return Expanded(
                              child: buildDaftarPesanan(snapshot, context));
                        }
                      });
                }
              }),
            ],
          ),
        ));
  }

  bool cekStatus(int value) {
    if (value == 0) {
      return false;
    } else {
      return true;
    }
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
      OrderFinishBloc penjualanData = BlocProvider.of<OrderFinishBloc>(context);
      penjualanData
          .add(OrderFinishRefresh("paid", 1, "", formatTanggal.format(picked)));

      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat("dd-MMM-yyyy").format(selectedDate);
      });
    }
  }

  void cetakPrinter(int id) async {
    Future<ParsingPenjualan> penjualan;

    var printer = pengaturan.printerBluetooth;
    var printer2 = pengaturan.printerBluetooth2;
    PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
    BluetoothManager bluetoothManager = BluetoothManager.instance;
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
        bluetoothManager.state.listen((event) async {
          PrinterBluetoothManager _printerManager2 = PrinterBluetoothManager();
          if (printer2.name != "test" && printer2.name != "") {
            _printerManager2.selectPrinter(printer2);
            const PaperSize paper = PaperSize.mm58;
            if (event == 0) {
              final PosPrintResult res2 = await _printerManager2.printTicket(
                  await printPesanan(paper: paper, dataPenjualan: penjualan));
              Fluttertoast.showToast(msg: res2.msg);
            }
          }
        });
        //Fluttertoast.showToast(msg: res.msg);
      }
    }

    //return Text(res.msg);
  }

  Container buildDaftarPesanan(
      AsyncSnapshot<ParsingPenjualan> snapshot, BuildContext context) {
    var formatWaktu = DateFormat('HH:mm');
    //OrderFinishBloc penjualanData = BlocProvider.of<OrderFinishBloc>(context);

    return Container(
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(
          height: 16,
        ),
        //physics: NeverScrollableScrollPhysics(),
        //shrinkWrap: true,
        itemCount: snapshot.data!.dataPenjualan.length,
        itemBuilder: (context, index) {
          return Container(
            //height: 103,
            decoration: BoxDecoration(
                //color: theme == "dark" ? warnaLightDark.withOpacity(0.4) : warnaPrimerLight.withOpacity(0.5),
                border: Border.all(
                    color:
                        theme == "dark" ? warnaPrimerDark : warnaPrimerLight),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
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
                                snapshot.data!.dataPenjualan[index].table.name
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
                              formatWaktu.format(DateTime.parse(
                                  snapshot.data!.dataPenjualan[index].time)),
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

                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ListView.builder(
                            // separatorBuilder: (context, index) => Divider(
                            //       thickness: 2,
                            //     ),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot
                                .data!.dataPenjualan[index].groupDetails.length,
                            itemBuilder: (context, indexs) {
                              return ListTile(
                                dense: true,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data!.dataPenjualan[index]
                                          .groupDetails[indexs].menu.name
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: theme == "dark"
                                              ? warnaTeksDark
                                              : warnaTeksLight),
                                    ),
                                    Text(
                                      "Variant :" +
                                          snapshot.data!.dataPenjualan[index]
                                              .groupDetails[indexs].varian.name,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: theme == "dark"
                                              ? warnaTeksDark
                                              : warnaTeksLight),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: warnaPrimer,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Center(
                                        child: Text(
                                      snapshot.data!.dataPenjualan[index]
                                          .groupDetails[indexs].qty
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: theme == "dark"
                                              ? warnaTitleDark
                                              : warnaTitleLight),
                                    ))),
                                subtitle: Text(
                                  "Note : " +
                                      snapshot.data!.dataPenjualan[index]
                                          .groupDetails[indexs].note,
                                  style: TextStyle(
                                      color: theme == "dark"
                                          ? warnaTeksDark
                                          : warnaTeksLight),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Material(
                        color: warnaSekunder,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Konfirmasi"),
                                  content: Text("Cetak Kembali Pesanan ?"),
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
                                            .data!.dataPenjualan[index].id);

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
                        )),
                  )
                  //)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
