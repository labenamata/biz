import 'package:chasier/constans.dart';
import 'package:chasier/kasir/pesanan/detailPesanan.dart';
import 'package:flutter/material.dart';

class KelolaPesanan extends StatefulWidget {
  const KelolaPesanan(
      {required this.name,
      required this.meja,
      required this.id,
      required this.total,
      required this.subtotal,
      required this.ppn,
      required this.tanggal});

  final String name;
  final String meja;
  final int id;
  final int total;
  final int subtotal;
  final int ppn;
  final String tanggal;
  @override
  _KelolaPesananState createState() => _KelolaPesananState();
}

class _KelolaPesananState extends State<KelolaPesanan>
    with SingleTickerProviderStateMixin {
  late TabController tabDetail;
  @override
  void initState() {
    tabDetail = TabController(length: 2, vsync: this);
    tabDetail.addListener(() {
      FocusScope.of(context).unfocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: warnaBackground,
        appBar: AppBar(
          backgroundColor: warnaPrimer,
          title: Text(
            widget.name.toUpperCase(),
            style: TextStyle(
                color: warnaTitle, fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: warnaTitle,
            ),
          ),
          elevation: 0,
        ),
        body: DetailPesanan(
            name: widget.name,
            total: widget.total,
            subtotal: widget.subtotal,
            ppn: widget.ppn,
            meja: widget.meja,
            tanggal: widget.tanggal,
            id: widget.id));
  }

  Widget menu() {
    return Container(
      decoration: BoxDecoration(color: warnaPrimer),
      child: TabBar(
        controller: tabDetail,
        labelColor: warnaPrimer,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: warnaSekunder, width: 5.0),
          ),
        ),
        unselectedLabelColor: warnaTitle,
        indicatorSize: TabBarIndicatorSize.tab,
        //indicatorPadding: EdgeInsets.all(5.0),
        //indicatorColor: warnaSekunder,
        tabs: [
          Tab(
            text: "Pesanan",
          ),
          Tab(
            text: "Bayar",
            // text: "Bayar",
          ),
        ],
      ),
    );
  }
}
