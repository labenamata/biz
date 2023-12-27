import 'dart:io';

import 'package:chasier/bloc/blocDetail.dart';
import 'package:chasier/bloc/blocLogin.dart';
import 'package:chasier/bloc/blocMenus.dart';
import 'package:chasier/bloc/blocOrderFinish.dart';
import 'package:chasier/bloc/blocPenjualan.dart';
import 'package:chasier/bloc/blocPrinted.dart';
import 'package:chasier/bloc/blocSend.dart';
import 'package:chasier/bloc/blocTable.dart';
import 'package:chasier/bloc/blocTemp.dart';
import 'package:chasier/bloc/blocTotalPenjualan.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<PenjualanBloc>(
              create: (context) => PenjualanBloc(PenjualanKosong())
                ..add(PenjualanRefresh("unpaid", 1, ""))),
          BlocProvider<OrderFinishBloc>(
              create: (context) => OrderFinishBloc(OrderFinishLoading())
                ..add(OrderFinishRefresh("unpaid", 1, "", ""))),
          BlocProvider<LoginBloc>(create: (context) => LoginBloc(LoginUn())),
          BlocProvider<DetailPenjualanBloc>(
              create: (context) => DetailPenjualanBloc(DetailUn())),
          BlocProvider<TotalPenjualanBloc>(
              create: (context) => TotalPenjualanBloc(TotalPenjualanLoading())),
          BlocProvider<TempBloc>(create: (context) => TempBloc(TempLoading())),
          BlocProvider<SendBloc>(create: (context) => SendBloc(SendLoading())),
          BlocProvider<PrintedBloc>(
              create: (context) => PrintedBloc(PrintedLoading())),
          BlocProvider<MenusBloc>(
              create: (context) => MenusBloc(MenusLoading())),
          BlocProvider<TablesBloc>(
              create: (context) =>
                  TablesBloc(TablesLoading())..add(GetTables())),
        ],
        child: MaterialApp(
            title: 'Bistro',
            theme: ThemeData(
              fontFamily: 'OpenSans-Regular',
              primaryColor:
                  theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
            ),
            home: LoginPage()));
  }
}
