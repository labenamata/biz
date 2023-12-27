import 'dart:async';

import 'package:chasier/bloc/blocPenjualan.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/kitchen/finishOrder.dart';
import 'package:chasier/kitchen/newOrder.dart';
import 'package:chasier/menuSetting.dart';
import 'package:chasier/model/modelPenjualan.dart';
import 'package:chasier/printPesanan.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chasier/pengaturan.dart' as pengaturan;
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class KelolaKitchen extends StatefulWidget {
  final String title;
  final int kategori;

  KelolaKitchen({required this.title, required this.kategori});

  @override
  _KelolaKitchenState createState() => _KelolaKitchenState();
}

class _KelolaKitchenState extends State<KelolaKitchen>
    with SingleTickerProviderStateMixin {
  late TabController tabKitchen;
  final durasi = Duration(seconds: 30);
  late Timer timerLog;

  void initState() {
    tabKitchen = TabController(length: 2, vsync: this);
    tabKitchen.addListener(() {
      FocusScope.of(context).unfocus();
    });
    timerLog = Timer.periodic(durasi, (Timer _) {
      BluetoothManager bluetoothManager = BluetoothManager.instance;
      PenjualanBloc penjualanData = BlocProvider.of<PenjualanBloc>(context);
      penjualanData.add(OrderRefresh("paid", 0, ""));
      bluetoothManager.state.listen((event) async {
        if (event == 0) {
          cetakPrinter();
        }
      });
      cetakPrinter();
    });
    cetakPrinter();
    super.initState();
  }

  @override
  void dispose() {
    timerLog.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          theme == "dark" ? warnaBackgroundDark : warnaBackgroundLight,
      appBar: AppBar(
        iconTheme: IconThemeData(color: warnaTitle),
        backgroundColor: warnaPrimer,
        title: Text(
          widget.title,
          style: TextStyle(
              color: warnaTitle, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,

        //leading: MenuSetting(),
      ),
      drawer: MenuSetting(),
      body: Column(
        children: [
          menu(),
          Expanded(
            child: TabBarView(
                controller: tabKitchen, children: [NewOrder(), FinishOrder()]),
          ),
        ],
      ),
    );
  }

  void cetakPrinter() async {
    Future<ParsingPenjualan> penjualan;
    List<Penjualan> order = [];
    Future<String> status;
    int isThere = 0;
    var printer = pengaturan.printerBluetooth;
    var printer2 = pengaturan.printerBluetooth2;
    BluetoothManager bluetoothManager = BluetoothManager.instance;
    PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
    List<Penjualan> dataPenjualan = [];

    penjualan =
        ParsingPenjualan.cekPrinted(status: "paid", isdone: 0, isprinted: 0);

    await penjualan.then((value) {
      dataPenjualan = value.dataPenjualan;
      order = value.dataPenjualan;
    });

    dataPenjualan.forEach((detail) {
      if (detail.groupDetails.isNotEmpty) {
        isThere++;
      }
    });

    if (dataPenjualan.isNotEmpty) {
      if (isThere != 0) {
        FlutterRingtonePlayer.play(
          android: AndroidSounds.ringtone,
          ios: IosSounds.glass,
          looping: false, // Android only - API >= 28
          volume: 1, // Android only - API >= 28
          asAlarm: false, // Android only - all APIs
        );
        isThere = 0;
      }
      if (printer.name != "test") {
        _printerManager.selectPrinter(printer);
        const PaperSize paper = PaperSize.mm58;

        //status.then((value) => Fluttertoast.showToast(msg: value));

        final PosPrintResult res = await _printerManager.printTicket(
            await printPesanan(paper: paper, dataPenjualan: penjualan));
        if (res.msg == "Success") {
          status = ParsingPenjualan.updatePrinted(penjualan: order);
        }
        bluetoothManager.state.listen((event) async {
          PrinterBluetoothManager _printerManager2 = PrinterBluetoothManager();
          if (printer2.name != "test" && printer2.name != "") {
            _printerManager2.selectPrinter(printer2);
            const PaperSize paper = PaperSize.mm58;
            if (event == 0) {
              final PosPrintResult res2 = await _printerManager2.printTicket(
                  await printPesanan(paper: paper, dataPenjualan: penjualan));
              //Fluttertoast.showToast(msg: res2.msg);
            }
          }
        });
      }
    }

    //return Text(res.msg);
  }

  Widget menu() {
    return Container(
      //decoration: BoxDecoration(color: warnaSekunder.withOpacity(0.2)),
      child: TabBar(
        controller: tabKitchen,
        labelColor: theme == "dark" ? warnaTitleDark : warnaTitleLight,
        indicator: BoxDecoration(
            color: warnaPrimer,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        unselectedLabelColor: warnaPrimer,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 26),
        //indicatorColor: theme == "dark" ? warnaSekunderDark : warnaSekunderLight,
        tabs: [
          Tab(
            text: "New",
          ),
          Tab(
            text: "Finish",
            // text: "Bayar",
          ),
        ],
      ),
    );
  }
}
