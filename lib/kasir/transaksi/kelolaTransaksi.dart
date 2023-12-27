import 'package:chasier/bloc/blocTemp.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/kasir/transaksi/confirmedTransaksi.dart';
import 'package:chasier/kasir/transaksi/unconfirmedTransaksi.dart';
import 'package:chasier/menu/menuList.dart';
import 'package:chasier/menuSetting.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KelolaTransaksi extends StatefulWidget {
  const KelolaTransaksi({Key? key}) : super(key: key);

  @override
  _KelolaTransaksiState createState() => _KelolaTransaksiState();
}

class _KelolaTransaksiState extends State<KelolaTransaksi>
    with SingleTickerProviderStateMixin {
  late TabController tabTransaksi;
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    tabTransaksi = TabController(length: 2, vsync: this, initialIndex: 1);
    tabTransaksi.addListener(() {
      FocusScope.of(context).unfocus();
    });
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor:
            theme == "dark" ? warnaBackgroundDark : warnaBackgroundLight,
        appBar: AppBar(
          backgroundColor: warnaPrimer,
          iconTheme: IconThemeData(color: warnaTitle),
          title: Text(
            "TRANSAKSI",
            style: TextStyle(
                color: warnaTitle, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: warnaPrimer,
          onPressed: () {
            showAdd(context);
          },
          child: Icon(
            Icons.add,
            color: warnaTitle,
          ),
        ),
        drawer: MenuSetting(),
        body: ColorfulSafeArea(
          color: Colors.white,
          child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
            return Row(
              children: [
                RotatedBox(quarterTurns: -1, child: menu()),
                Expanded(
                  child: TabBarView(controller: tabTransaksi, children: [
                    ConfirmedTransaksi(),
                    UnconfirmedTransaksi(),
                  ]),
                ),
              ],
            );
          }),
        ));
  }

  void showAdd(BuildContext context) {
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
                  width: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ListTile(
                        trailing: Icon(
                          Icons.food_bank,
                          color: warnaPrimer,
                        ),
                        title: Text("Dine In"),
                        onTap: () {
                          TempBloc penjualanData =
                              BlocProvider.of<TempBloc>(context);
                          penjualanData.add(EmptyTemp());
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MenuList(1, "baru", "", 1)),
                          );
                        },
                      ),
                      ListTile(
                        trailing: Icon(
                          Icons.bike_scooter,
                          color: warnaPrimer,
                        ),
                        title: Text("Go Food"),
                        onTap: () {
                          TempBloc penjualanData =
                              BlocProvider.of<TempBloc>(context);
                          penjualanData.add(EmptyTemp());
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MenuList(2, "baru", "", 1)),
                          );
                        },
                      ),
                      ListTile(
                        trailing: Icon(
                          Icons.motorcycle,
                          color: warnaPrimer,
                        ),
                        title: Text("Grab Food"),
                        onTap: () {
                          TempBloc penjualanData =
                              BlocProvider.of<TempBloc>(context);
                          penjualanData.add(EmptyTemp());
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MenuList(3, "baru", "", 1)),
                          );
                        },
                      )
                    ],
                  )),
            ));
      },
    );
  }

  Widget menu() {
    return Container(
      //padding: EdgeInsets.symmetric(vertical: 5),
      // decoration: BoxDecoration(
      //     color: theme == "dark"
      //         ? warnaLightDark.withOpacity(0.4)
      //         : warnaPrimerLight),
      child: TabBar(
        controller: tabTransaksi,
        labelColor: Colors.white,

        indicator: BoxDecoration(
            // gradient: LinearGradient(
            //     begin: Alignment.topCenter,
            //     end: Alignment.bottomCenter,
            //     colors: [warnaPrimer, warnaSekunder.withOpacity(0.5)]),
            borderRadius: BorderRadius.circular(5),
            color: warnaPrimer),
        unselectedLabelColor: warnaPrimer,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 26),

        //indicatorPadding: EdgeInsets.all(5.0),
        //indicatorColor: theme == "dark" ? warnaSekunderDark : warnaSekunderLight,
        tabs: [
          Tab(
            text: "Confirmed",
            // text: "Bayar",
          ),
          Tab(
            text: "Unconfirmed",
          ),
        ],
      ),
    );
  }
}
