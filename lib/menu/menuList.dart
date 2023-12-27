import 'package:chasier/bloc/blocMenus.dart';
import 'package:chasier/komponen/customPrimaryButton.dart';
import 'package:chasier/menu/newTransaksi.dart';
import 'package:chasier/menu/tambahProduk.dart';
import 'package:chasier/model/modelMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chasier/constans.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

final formatter = new NumberFormat("#,###", "id_ID");

class MenuList extends StatefulWidget {
  final int priceId;
  final String status;
  final String nama;
  final int id;
  MenuList(this.priceId, this.status, this.nama, this.id);

  @override
  _MenuListState createState() => _MenuListState();
}

class _MenuListState extends State<MenuList> {
  late Future<List<ParsingMenu>> daftarMenu;

  void initState() {
    MenusBloc penjualanData = BlocProvider.of<MenusBloc>(context);
    penjualanData.add(GetMenu(""));
    super.initState();
    //futurePenjualan = ParsingMenu.getPenjualan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: warnaPrimer,
        title: Text(
          widget.status == "baru"
              ? "Transaksi Baru"
              : "Tambah Pesanan " + widget.nama.toUpperCase(),
          style: TextStyle(
            color: warnaTitle,
            fontSize: 24,
          ),
        ),
      ),
      body: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    buildCari(),
                    SizedBox(height: 10),
                    buildListMenu()
                  ],
                ),
              ),
              VerticalDivider(
                width: 10,
              ),
              Expanded(
                  child: NewTransaksi(
                id: widget.id,
                status: widget.status,
                priceId: widget.priceId,
              ))
            ],
          ),
        );
      }),
    );
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
                        if (widget.priceId == 1) {
                          harga = snapshot.data!.menus[index].price;
                        } else if (widget.priceId == 2) {
                          harga = snapshot.data!.menus[index].priceGofood;
                        } else if (widget.priceId == 3) {
                          harga = snapshot.data!.menus[index].priceGrabfood;
                        }
                        return menum(
                            menuId: snapshot.data!.menus[index].id,
                            name:
                                snapshot.data!.menus[index].name.toUpperCase(),
                            price: harga,
                            stok: snapshot.data!.menus[index].stok,
                            varian: snapshot.data!.menus[index].varians);
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
                    MenusBloc penjualanData =
                        BlocProvider.of<MenusBloc>(context);
                    penjualanData.add(GetMenu(cariController.text));
                  })),
        ],
      ),
    );
  }

  Widget menum(
      {required int menuId,
      required String name,
      required int price,
      required List<Varian> varian,
      required int stok}) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        splashColor: warnaPrimer,
        onTap: () {
          FocusScope.of(context).unfocus();
          if (stok <= 0) {
            Fluttertoast.showToast(msg: "Stok Habis");
          } else {
            showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  return TambahProduk(
                    priceId: widget.priceId,
                    context: context,
                    id: menuId,
                    name: name,
                    price: price,
                    stok: stok,
                    variant: varian,
                  );
                });
          }
        },
        child: Container(
            child: ListTile(
          leading: leadingList(name),
          trailing: Text(formatter.format(price),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 14)),
          title: Text(name.toUpperCase(),
              style: TextStyle(color: warnaTeks, fontSize: 14)),
          subtitle: Text("Stock : " + stok.toString()),
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
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: warnaPrimer),
      child: Center(
          child: Text(
        "$huruf3",
        style: TextStyle(fontSize: 12, color: Colors.white),
      )),
    );
  }
}
