import 'package:chasier/bloc/blocLogin.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/kasir/transaksi/kelolaTransaksi.dart';
import 'package:chasier/kitchen/kelolaKitchen.dart';
import 'package:chasier/komponen/customPrimaryButton.dart';
import 'package:chasier/komponen/customSecondaryButton.dart';
import 'package:chasier/model/modelPengaturan.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'pengaturan.dart' as pengaturan;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController userController = TextEditingController();

  final TextEditingController passController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();

  @override
  void initState() {
    Future<List<PengaturanModel>> setting = PengaturanModel.showData();
    setting.then((value) {
      Map<String, dynamic> printer1 = {
        'name': value[0].printerName1,
        'address': value[0].printerAddress1
      };
      Map<String, dynamic> printer2 = {
        'name': value[0].printerName2,
        'address': value[0].printerAddress2
      };
      BluetoothDevice device1 = BluetoothDevice.fromJson(printer1);
      BluetoothDevice device2 = BluetoothDevice.fromJson(printer2);
      pengaturan.namaToko = value[0].nama;
      pengaturan.alamat = value[0].alamat;
      pengaturan.kota = value[0].kota;
      pengaturan.telepon = value[0].telepon;
      pengaturan.alamatIP = value[0].alamatIP;
      pengaturan.printerBluetooth = PrinterBluetooth(device1);
      pengaturan.printerBluetooth2 = PrinterBluetooth(device2);
    });
    userController.text = pengaturan.savedEmail;
    passController.text = pengaturan.savedPass;
    super.initState();
  }

  late bool progress;
  String role = "";
  String pesan = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          theme == "dark" ? warnaBackgroundDark : warnaBackgroundLight,
      body: ColorfulSafeArea(
        //color: theme == "dark" ? warnaDarkDark : warnaDarkLight,
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            if (orientation == Orientation.portrait) {
              return Container(
                padding: EdgeInsets.only(top: 50, left: 26, right: 26),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image(image: AssetImage('assets/logo.png')),
                      SizedBox(
                        height: 50,
                      ),
                      Card(
                        // color: theme == "dark"
                        //     ? warnaLightDark.withOpacity(0.2)
                        //     : warnaPrimerDark,
                        elevation: 5,
                        child: Container(
                          height: 300,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                      onTap: () => settingAlamat(context),
                                      child: Icon(Icons.menu,
                                          color: warnaPrimer))),
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: theme == "dark"
                                      ? warnaTeksDark
                                      : warnaTeksLight,
                                ),
                              ),
                              Spacer(),
                              buildInput(
                                  controller: userController,
                                  nama: "Username",
                                  ikon: Icons.person,
                                  obscure: false),
                              SizedBox(
                                height: 10,
                              ),
                              buildInput(
                                  controller: passController,
                                  nama: "Password",
                                  ikon: Icons.lock,
                                  obscure: true),
                              Spacer(),
                              buildLoginButton(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                padding: EdgeInsets.all(26),
                //child: SingleChildScrollView(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        child: Image(image: AssetImage('assets/logo.png'))),
                    Expanded(
                      child: Card(
                        // color: theme == "dark"
                        //     ? warnaLightDark.withOpacity(0.2)
                        //     : warnaPrimerLight,
                        elevation: 5,
                        child: Container(
                          // height: 300,
                          padding: EdgeInsets.all(16),

                          child: Column(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: GestureDetector(
                                      onTap: () => settingAlamat(context),
                                      child: Icon(
                                        Icons.menu,
                                        color: warnaPrimer,
                                      ))),
                              Text(
                                "LOGIN",
                                style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: theme == "dark"
                                        ? warnaTeksDark
                                        : warnaTeksLight),
                              ),
                              Spacer(),
                              buildInput(
                                  controller: userController,
                                  nama: "Username",
                                  ikon: Icons.person,
                                  obscure: false),
                              SizedBox(
                                height: 10,
                              ),
                              buildInput(
                                  controller: passController,
                                  nama: "Password",
                                  ikon: Icons.lock,
                                  obscure: true),
                              Spacer(),
                              buildLoginButton(context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //),
              );
            }
          },
        ),
      ),
    );
  }

  void showMyDialog(BuildContext contexts) {
    showDialog<void>(
        context: contexts,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Card(
              child: Container(
                  padding: EdgeInsets.all(20),
                  child: BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                    if (state is LoginLoading) {
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
                    } else if (state is LoginFailed) {
                      LoginFailed loginFailed = state;
                      Future.delayed(new Duration(seconds: 1), () {
                        Navigator.pop(context);
                        FocusScope.of(context).unfocus();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar(loginFailed.message));
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
                          Text("Login Failed"),
                        ],
                      );
                    } else {
                      LoginLoaded loginLoaded = state as LoginLoaded;

                      Future.delayed(new Duration(seconds: 3), () async {
                        await loginLoaded.dataLogin.then((value) {
                          role = value.profile.roles[0].name;
                          pesan = value.message;
                          pengaturan.kasir = value.profile.name;
                        });
                        if (role == "Chef") {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KelolaKitchen(
                                      title: "Kitchen Order",
                                      kategori: 1,
                                    )),
                          );
                        } else if (role == "Barista") {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KelolaKitchen(
                                      title: "Bar Order",
                                      kategori: 2,
                                    )),
                          );
                        } else {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => KelolaTransaksi()),
                          );
                        }
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
                          Text("Masuk"),
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

  Row buildLoginButton(BuildContext context) {
    LoginBloc loginData = BlocProvider.of<LoginBloc>(context);
    return Row(
      children: [
        Expanded(
            child: CustomSecondaryButton(
          title: "BATAL",
          onpress: () {
            Navigator.pop(context);
          },
        )),
        SizedBox(width: 10),
        Expanded(
          child: CustomPrimaryButton(
            title: "LOGIN",
            onpress: () {
              loginData.add(LoginMasuk(
                  username: userController.text,
                  password: passController.text));
              showMyDialog(context);
            },
          ),
        ),
      ],
    );
  }

  Container buildInput(
      {required TextEditingController controller,
      required String nama,
      required IconData ikon,
      required bool obscure}) {
    return Container(
      child: TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            // filled: true,
            // fillColor: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            //labelText: nama,
            hintText: nama,
            hintStyle: TextStyle(color: Colors.black),
            labelStyle: TextStyle(color: Colors.black),

            suffixIcon: Icon(ikon, color: Colors.black),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: warnaPrimer, width: 1)),

            border: OutlineInputBorder(
                borderSide: BorderSide(color: warnaPrimer, width: 1)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: warnaPrimer, width: 1)),
          )),
    );
  }

  void settingAlamat(BuildContext context) {
    alamatController.text = pengaturan.alamatIP;
    Map<String, dynamic> data = {};
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: Card(
              //decoration: BoxDecoration(colo),
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: alamatController,
                        decoration:
                            InputDecoration(labelText: "Alamat IP Server"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomPrimaryButton(
                                title: "OK",
                                onpress: () {
                                  data = {
                                    'id': 1,
                                    'nama': pengaturan.namaToko,
                                    'alamat': pengaturan.alamat,
                                    'kota': pengaturan.kota,
                                    'telepon': pengaturan.telepon,
                                    'printerName1':
                                        pengaturan.printerBluetooth.name,
                                    'printerAddress1':
                                        pengaturan.printerBluetooth.address,
                                    'printerName2':
                                        pengaturan.printerBluetooth2.name,
                                    'printerAddress2':
                                        pengaturan.printerBluetooth2.address,
                                    'alamatIP': alamatController.text
                                  };
                                  PengaturanModel.simpanData(data);
                                  pengaturan.alamatIP = alamatController.text;
                                  Navigator.pop(context);
                                }),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: CustomSecondaryButton(
                                title: "Batal",
                                onpress: () {
                                  Navigator.pop(context);
                                }),
                          )
                        ],
                      )
                    ],
                  )),
            ),
          );
        });
  }
}
