import 'package:chasier/bloc/blocLogin.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/login.dart';
import 'package:chasier/menu/menuStok.dart';
import 'package:chasier/model/modelLogin.dart';
import 'package:chasier/settingPrinter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

TextEditingController printerController = TextEditingController();

class MenuSetting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      LoginLoaded loginLoaded = state as LoginLoaded;

      return FutureBuilder<ParsingLogin>(
          future: loginLoaded.dataLogin,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(
                color: warnaPrimer,
              ));
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else {
              return Container(
                decoration: BoxDecoration(color: Colors.white),
                child: ListView(
                  children: [
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        snapshot.data!.profile.name,
                        style: TextStyle(color: warnaTitle),
                      ),
                      accountEmail: Text(snapshot.data!.profile.email,
                          style: TextStyle(color: warnaTitle)),
                      currentAccountPicture: CircleAvatar(
                          child: CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 40,
                        ),
                      )),
                    ),
                    // ListTile(
                    //   title: Text(
                    //     "Dark Mode",
                    //     style: TextStyle(
                    //         color: theme == "dark"
                    //             ? warnaTeksDark
                    //             : warnaTeksLight),
                    //   ),
                    //   leading: Icon(
                    //     Icons.map_outlined,
                    //     color: theme == "dark"
                    //         ? warnaPrimerDark
                    //         : warnaPrimerLight,
                    //   ),
                    //   trailing: Switch(
                    //     value: theme == "dark" ? true : false,
                    //     onChanged: (bool value) {
                    //       if (value) {
                    //         theme = "dark";
                    //       } else {
                    //         theme = "light";
                    //       }
                    //     },
                    //   ),
                    //   onTap: () {
                    //     Future.delayed(new Duration(milliseconds: 200), () {
                    //       Navigator.pop(context);
                    //       Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => SettingPrinter()));
                    //     });
                    //   },
                    // ),
                    ListTile(
                      title: Text(
                        "Menu Stok",
                        style: TextStyle(color: warnaTeks),
                      ),
                      leading: Icon(
                        Icons.dining_outlined,
                        color: warnaPrimer,
                      ),
                      onTap: () {
                        Future.delayed(new Duration(milliseconds: 200), () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MenuStok()));
                        });
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Pengaturan",
                        style: TextStyle(
                            color: theme == "dark"
                                ? warnaTeksDark
                                : warnaTeksLight),
                      ),
                      leading: Icon(
                        Icons.print_outlined,
                        color: theme == "dark"
                            ? warnaPrimerDark
                            : warnaPrimerLight,
                      ),
                      onTap: () {
                        Future.delayed(new Duration(milliseconds: 200), () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingPrinter()));
                        });
                      },
                    ),
                    ListTile(
                      title: Text(
                        "Log Out",
                        style: TextStyle(
                            color: theme == "dark"
                                ? warnaTeksDark
                                : warnaTeksLight),
                      ),
                      leading: Icon(
                        Icons.logout_outlined,
                        color: theme == "dark"
                            ? warnaPrimerDark
                            : warnaPrimerLight,
                      ),
                      onTap: () {
                        Future.delayed(new Duration(milliseconds: 500), () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        });
                      },
                    )
                  ],
                ),
              );
            }
          });
    }));
  }
}
