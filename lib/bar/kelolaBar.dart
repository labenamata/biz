import 'package:chasier/constans.dart';
import 'package:chasier/bar/finishOrder.dart';
import 'package:chasier/bar/newOrder.dart';
import 'package:flutter/material.dart';

class KelolaBar extends StatefulWidget {
  KelolaBar({Key? key}) : super(key: key);

  @override
  _KelolaBarState createState() => _KelolaBarState();
}

class _KelolaBarState extends State<KelolaBar>
    with SingleTickerProviderStateMixin {
  late TabController tabBar;

  void initState() {
    tabBar = TabController(length: 2, vsync: this);
    tabBar.addListener(() {
      FocusScope.of(context).unfocus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme == "dark" ? warnaPrimerDark : warnaPrimerLight,
        title: Text(
          "Bar Order",
          style: TextStyle(
              color: theme == "dark" ? warnaTitleDark : warnaTitleLight),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          menu(),
          Expanded(
            child: TabBarView(
                controller: tabBar, children: [NewOrder(), FinishOrder()]),
          ),
        ],
      ),
    );
  }

  Widget menu() {
    return Container(
      decoration: BoxDecoration(
          color: theme == "dark" ? warnaPrimerDark : warnaPrimerLight),
      child: TabBar(
        controller: tabBar,
        labelColor: theme == "dark" ? warnaTitleDark : warnaTitleLight,
        indicator: BoxDecoration(
          border: Border(
            bottom: BorderSide(
                color: theme == "dark" ? warnaSekunderDark : warnaSekunderLight,
                width: 5.0),
          ),
        ),
        unselectedLabelColor:
            theme == "dark" ? warnaTitleDark : warnaTitleLight.withOpacity(0.5),
        indicatorSize: TabBarIndicatorSize.tab,
        //indicatorPadding: EdgeInsets.all(5.0),
        //indicatorColor: warnaSekunder,
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
