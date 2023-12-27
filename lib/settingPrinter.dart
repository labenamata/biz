import 'package:chasier/constans.dart';
import 'package:chasier/model/modelPengaturan.dart';
import 'package:chasier/tesPrint.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'pengaturan.dart' as pengaturan;

class SettingPrinter extends StatefulWidget {
  @override
  _SettingPrinterState createState() => _SettingPrinterState();
}

class _SettingPrinterState extends State<SettingPrinter> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  PrinterBluetoothManager printerManager2 = PrinterBluetoothManager();
  TextEditingController namaController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  TextEditingController teleponController = TextEditingController();
  List<PrinterBluetooth> _devices = [];
  List<PrinterBluetooth> _devices2 = [];
  late int indeks;
  late int indeks2;
  late PrinterBluetooth printer;
  late PrinterBluetooth printer2;
  int stat = 0;
  int stat2 = 0;
  String indek2ada = "belum";

  @override
  void initState() {
    super.initState();
    namaController.text = pengaturan.namaToko;
    alamatController.text = pengaturan.alamat;
    kotaController.text = pengaturan.kota;
    teleponController.text = pengaturan.telepon;

    printer = pengaturan.printerBluetooth;
    printer2 = pengaturan.printerBluetooth2;

    printerManager.scanResults.listen((devices) async {
      // print('UI: Devices found ${devices.length}');
      setState(() {
        _devices = devices;
      });
    });
    printerManager2.scanResults.listen((devices) async {
      // print('UI: Devices found ${devices.length}');
      setState(() {
        _devices2 = devices;
      });
    });
  }

  void _startScanDevices() {
    setState(() {
      _devices = [];
    });
    printerManager.startScan(Duration(seconds: 5));
  }

  void _stopScanDevices() {
    printerManager.stopScan();
  }

  void _startScanDevices2() {
    setState(() {
      _devices2 = [];
    });
    printerManager2.startScan(Duration(seconds: 5));
  }

  void _stopScanDevices2() {
    printerManager2.stopScan();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = {};
    return MaterialApp(
      home: Scaffold(
        backgroundColor:
            theme == "dark" ? warnaBackgroundDark : warnaBackgroundLight,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: theme == "dark"
              ? warnaLightDark.withOpacity(0.2)
              : warnaPrimerLight,
          title: const Text('Setting Printer'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                buildInputSetting(
                    nama: "Nama Toko", controller: namaController),
                buildInputSetting(nama: "Alamat", controller: alamatController),
                buildInputSetting(nama: "Kota", controller: kotaController),
                buildInputSetting(
                    nama: "Telepon", controller: teleponController),
                SizedBox(
                  height: 20,
                ),
                buildPrinter(context),
                SizedBox(
                  height: 20,
                ),
                buildPrinter2(context),
                SizedBox(
                  height: 20,
                ),
                Material(
                  color: warnaSekunder,
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                    onTap: () {
                      data = {
                        'id': 1,
                        'nama': namaController.text,
                        'alamat': alamatController.text,
                        'kota': kotaController.text,
                        'telepon': teleponController.text,
                        'printerName1': _devices.isNotEmpty
                            ? _devices[indeks].name
                            : pengaturan.printerBluetooth.name,
                        'printerAddress1': _devices.isNotEmpty
                            ? _devices[indeks].address
                            : pengaturan.printerBluetooth.address,
                        'printerName2': _devices2.isNotEmpty
                            ? _devices2[indeks2].name
                            : pengaturan.printerBluetooth2.name,
                        'printerAddress2': _devices2.isNotEmpty
                            ? _devices2[indeks2].address
                            : pengaturan.printerBluetooth2.address,
                        'alamatIP': pengaturan.alamatIP
                      };
                      pengaturan.namaToko = namaController.text;
                      pengaturan.alamat = alamatController.text;
                      pengaturan.kota = kotaController.text;
                      pengaturan.telepon = teleponController.text;
                      if (_devices.isNotEmpty) {
                        pengaturan.printerBluetooth = _devices[indeks];
                      }
                      if (_devices2.isNotEmpty) {
                        pengaturan.printerBluetooth2 = _devices2[indeks2];
                      }
                      PengaturanModel.simpanData(data);
                      Navigator.pop(context);
                    },
                    splashColor: warnaPrimer,
                    child: Container(
                        height: 50,
                        child: Center(
                          child: Text("Save",
                              style: TextStyle(
                                color: theme == "dark"
                                    ? warnaTitleDark
                                    : warnaTitleLight,
                              )),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Material buildPrinter(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  _startScanDevices();
                  showMyDialog(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: theme == "dark"
                              ? warnaPrimerDark
                              : warnaPrimerLight),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.print,
                        color: theme == "dark"
                            ? warnaPrimerDark
                            : warnaPrimerLight,
                        size: 25,
                      ),
                      buildTeks(),
                      Icon(
                        Icons.settings_bluetooth,
                        color: theme == "dark"
                            ? warnaPrimerDark
                            : warnaPrimerLight,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                  splashColor: Colors.white,
                  onTap: () async {
                    if (pengaturan.printerBluetooth.name != "test" ||
                        pengaturan.printerBluetooth.name.isEmpty) {
                      PrinterBluetoothManager _printerManager =
                          PrinterBluetoothManager();

                      _printerManager
                          .selectPrinter(pengaturan.printerBluetooth);
                      const PaperSize paper = PaperSize.mm58;
                      final PosPrintResult res = await _printerManager
                          .printTicket(await tesprint(paper: paper));
                      Fluttertoast.showToast(msg: res.msg);
                    } else {
                      Fluttertoast.showToast(msg: "Printer Belum Di Setting");
                    }
                  },
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: warnaPrimer,
                      ),
                      child: Center(
                          child: Text(
                        "Tes Printer",
                        style: TextStyle(color: warnaTitle),
                      )))),
            )
          ],
        ));
  }

  Material buildPrinter2(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  _startScanDevices2();
                  showMyDialog2(context);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  decoration: BoxDecoration(
                      border: Border.all(color: warnaPrimer),
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.print,
                        color: warnaPrimer,
                        size: 25,
                      ),
                      buildTeks2(),
                      Icon(
                        Icons.settings_bluetooth,
                        color: warnaPrimer,
                        size: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                  splashColor: Colors.white,
                  onTap: () async {
                    if (pengaturan.printerBluetooth2.name != "test" ||
                        pengaturan.printerBluetooth2.name.isNotEmpty) {
                      PrinterBluetoothManager _printerManager =
                          PrinterBluetoothManager();

                      _printerManager
                          .selectPrinter(pengaturan.printerBluetooth2);
                      const PaperSize paper = PaperSize.mm58;
                      final PosPrintResult res = await _printerManager
                          .printTicket(await tesprint(paper: paper));
                      Fluttertoast.showToast(msg: res.msg);
                    } else {
                      Fluttertoast.showToast(msg: "Printer Belum Di Setting");
                    }
                  },
                  child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: warnaPrimer,
                      ),
                      child: Center(
                          child: Text(
                        "Tes Printer",
                        style: TextStyle(color: warnaTitle),
                      )))),
            )
          ],
        ));
  }

  Widget buildTeks() {
    if (stat == 0) {
      if (printer.name == "test") {
        return Text("Set Printer",
            style: TextStyle(
                color: theme == "dark" ? warnaTeksDark : warnaTeksLight));
      } else {
        return Text(
          printer.name + "(" + printer.address + ")",
          style: TextStyle(
              color: theme == "dark" ? warnaTeksDark : warnaTeksLight),
        );
      }
    } else {
      if (_devices.isEmpty) {
        return Text("Set Printer",
            style: TextStyle(
                color: theme == "dark" ? warnaTeksDark : warnaTeksLight));
      } else {
        return Text(
            _devices[indeks].name + "(" + _devices[indeks].address + ")",
            style: TextStyle(
                color: theme == "dark" ? warnaTeksDark : warnaTeksLight));
      }
    }
  }

  Widget buildTeks2() {
    if (stat2 == 0) {
      if (printer2.name == "test") {
        return Text("Set Printer 2",
            style: TextStyle(
                color: theme == "dark" ? warnaTeksDark : warnaTeksLight));
      } else {
        return Text(
          printer2.name + "(" + printer2.address + ")",
          style: TextStyle(
              color: theme == "dark" ? warnaTeksDark : warnaTeksLight),
        );
      }
    } else {
      if (_devices2.isEmpty) {
        return Text("Set Printer",
            style: TextStyle(
                color: theme == "dark" ? warnaTeksDark : warnaTeksLight));
      } else {
        return Text(
            _devices2[indeks2].name + "(" + _devices2[indeks2].address + ")",
            style: TextStyle(
                color: theme == "dark" ? warnaTeksDark : warnaTeksLight));
      }
    }
  }

  TextField buildInputSetting({
    required String nama,
    required TextEditingController controller,
  }) {
    return TextField(
      style: TextStyle(color: theme == "dark" ? warnaTeksDark : warnaTeksLight),
      controller: controller,
      decoration: InputDecoration(
          labelText: nama,
          labelStyle: TextStyle(
              color: theme == "dark" ? warnaTeksDark : warnaTeksLight),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight)),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
            color: theme == "dark" ? warnaSekunderDark : warnaSekunderLight,
          ))),
    );
  }

  void showMyDialog(BuildContext context) {
    //LoginBloc loginData = BlocProvider.of<LoginBloc>(context);

    showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Card(
              child: Container(
                height: 200,
                child: StreamBuilder<bool>(
                  stream: printerManager.isScanningStream,
                  initialData: false,
                  builder: (c, snapshot) {
                    if (_devices.isNotEmpty) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: _devices.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () {},
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        setState(() {
                                          stat = 1;
                                          indeks = index;
                                        });
                                        _stopScanDevices();
                                        Navigator.pop(context);
                                      },
                                      subtitle: Text(_devices[index].address),
                                      leading: Icon(
                                        Icons.print_rounded,
                                        color: theme == "dark"
                                            ? warnaPrimerDark
                                            : warnaPrimerLight,
                                      ),
                                      title: Text(_devices[index].name),
                                    ),
                                  ],
                                ));
                          });
                    } else {
                      if (snapshot.data == true) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: theme == "dark"
                                ? warnaPrimerDark
                                : warnaPrimerLight,
                          ),
                        );
                      } else {
                        return Center(
                          child: Text("Device not found"),
                        );
                      }
                    }
                  },
                ),
              ),
            ));
      },
    );
  }

  void showMyDialog2(BuildContext context) {
    //LoginBloc loginData = BlocProvider.of<LoginBloc>(context);

    showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            child: Card(
              child: Container(
                height: 200,
                child: StreamBuilder<bool>(
                  stream: printerManager2.isScanningStream,
                  initialData: false,
                  builder: (c, snapshot) {
                    if (_devices2.isNotEmpty) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: _devices.length,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () {},
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      onTap: () {
                                        setState(() {
                                          stat2 = 1;
                                          indeks2 = index;
                                          //2indek2ada = "ada";
                                        });
                                        _stopScanDevices2();
                                        Navigator.pop(context);
                                      },
                                      subtitle: Text(_devices2[index].address),
                                      leading: Icon(
                                        Icons.print_rounded,
                                        color: theme == "dark"
                                            ? warnaPrimerDark
                                            : warnaPrimerLight,
                                      ),
                                      trailing: Text(index.toString()),
                                      title: Text(_devices2[index].name),
                                    ),
                                  ],
                                ));
                          });
                    } else {
                      if (snapshot.data == true) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: theme == "dark"
                                ? warnaPrimerDark
                                : warnaPrimerLight,
                          ),
                        );
                      } else {
                        return Center(
                          child: Text("Device not found"),
                        );
                      }
                    }
                  },
                ),
              ),
            ));
      },
    );
  }
}
