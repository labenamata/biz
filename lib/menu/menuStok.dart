import 'package:chasier/bloc/blocMenus.dart';
import 'package:chasier/constans.dart';
import 'package:chasier/komponen/customPrimaryButton.dart';
import 'package:chasier/menu/detailMenu.dart';
import 'package:chasier/model/modelMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

final formatter = new NumberFormat("#,###", "id_ID");

class MenuStok extends StatefulWidget {
  const MenuStok({Key? key}) : super(key: key);

  @override
  _MenuStokState createState() => _MenuStokState();
}

class _MenuStokState extends State<MenuStok> {
  int vis = 0;
  int jumlahStok = 0;

  @override
  void initState() {
    MenusBloc penjualanData = BlocProvider.of<MenusBloc>(context);
    penjualanData.add(GetMenu(""));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: warnaPrimer,
        centerTitle: true,
        title: Text(
          "Menu Stok",
          style: TextStyle(color: warnaTitle),
        ),
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios, color: warnaTitle)),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildCari(context),
            SizedBox(
              height: 10,
            ),
            buildListMenu()
          ],
        ),
      ),
    );
  }
}

Container buildListMenu() {
  return Container(
    child: BlocBuilder<MenusBloc, MenusState>(builder: (context, state) {
      if (state is MenusLoading) {
        return Expanded(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state is MenusError) {
        MenusError penjualanError = state;
        Future.delayed(Duration(seconds: 1), () {
          Fluttertoast.showToast(msg: penjualanError.message);
        });
        return Center(
          child: Icon(Icons.error),
        );
      } else {
        MenusLoaded menusLoaded = state as MenusLoaded;
        return FutureBuilder<ParsingMenu>(
            future: menusLoaded.data,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Expanded(
                    child: Center(
                        child: CircularProgressIndicator(
                  color: warnaPrimer,
                )));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else {
                return Expanded(
                  child: ListView.builder(
                    // separatorBuilder: (context, index) => SizedBox(
                    //   height: 10,
                    // ),
                    itemCount: snapshot.data!.menus.length,
                    itemBuilder: (BuildContext context, int index) {
                      late int harga;
                      return menum(
                          menuId: snapshot.data!.menus[index].id,
                          name: snapshot.data!.menus[index].name.toUpperCase(),
                          stok: snapshot.data!.menus[index].stok,
                          isVisible: snapshot.data!.menus[index].isVisible,
                          context: context);
                    },
                  ),
                );
              }

              // By default, show a loading spinner.
            });
      }
    }),
  );
}

Container buildCari(BuildContext context) {
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
                border: Border.all(color: warnaPrimer),
                borderRadius: BorderRadius.circular(5)),
            child: TextField(
              controller: cariController,
              cursorColor: warnaPrimer,
              style: TextStyle(color: warnaTeks),
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Nama",
                  hintStyle: TextStyle(color: warnaTeks.withOpacity(0.3)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: warnaPrimer,
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
                  FocusScope.of(context).unfocus();
                  MenusBloc penjualanData = BlocProvider.of<MenusBloc>(context);
                  penjualanData.add(GetMenu(cariController.text));
                })),
      ],
    ),
  );
}

Widget menum(
    {required int menuId,
    required String name,
    required BuildContext context,
    required int stok,
    required int isVisible}) {
  return Material(
    borderRadius: BorderRadius.all(Radius.circular(10)),
    child: InkWell(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      splashColor: warnaPrimer,
      onTap: () {
        FocusScope.of(context).unfocus();
        showDialog<void>(
            context: context,
            builder: (BuildContext context) {
              return DetailMenu(
                id: menuId,
                name: name,
                stok: stok,
                visible: isVisible,
              );
            });
      },
      child: Container(
          child: ListTile(
        leading: leadingList(name),
        title: Text(name.toUpperCase(),
            style: TextStyle(color: warnaTeks, fontSize: 14)),
        subtitle: Text("Stok : " + stok.toString(),
            style: TextStyle(
                //fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 14)),
        trailing: isVisible == 1
            ? Icon(Icons.visibility, color: warnaPrimer)
            : Icon(Icons.visibility_off_outlined),
      )),
    ),
  );
}

Container leadingList(String huruf) {
  String huruf1 = huruf.substring(0, 1).toUpperCase();
  String huruf2 = huruf.substring(1, 2).toLowerCase();
  String huruf3 = huruf1 + huruf2;
  return Container(
    width: 50,
    height: 50,
    //margin: EdgeInsets.only(left: defaultPadding),
    //padding: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)), color: warnaPrimer),
    child: Center(
        child: Text(
      "$huruf3",
      style: TextStyle(fontSize: 12, color: Colors.white),
    )),
  );
}
