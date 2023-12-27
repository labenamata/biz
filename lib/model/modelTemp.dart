import 'package:chasier/DBHelper.dart';
import 'package:chasier/database/tempQuery.dart';
import 'dart:io';

import 'package:chasier/pengaturan.dart' as pengaturan;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:chasier/token.dart' as token;

class TempModel {
  int id;
  int menuId;
  int varianId;
  String varian;
  String name;
  int qty;
  int total;
  int isTakeaway;
  String note;
  int price;

  TempModel(
      {required this.id,
      required this.menuId,
      required this.varianId,
      required this.varian,
      required this.total,
      required this.isTakeaway,
      required this.name,
      required this.note,
      required this.qty,
      required this.price});

  factory TempModel.fromJson(Map<String, dynamic> json) {
    return TempModel(
        id: json['id'],
        menuId: json['menu_id'],
        varianId: json['variant_id'],
        varian: json['variant'],
        isTakeaway: json['is_takeaway'],
        total: json['total'],
        name: json['name'],
        price: json['price'],
        qty: json['qty'],
        note: json['note']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['menu_id'] = this.menuId;
    data['variant'] = this.varian;
    data['variant_id'] = this.varianId;
    data['is_takeaway'] = this.isTakeaway;
    data['name'] = this.name;
    data['price'] = this.price;
    data['note'] = this.note;
    data['qty'] = this.qty;
    return data;
  }

  static Future<List<TempModel>> showData() async {
    DBHelper _helper = new DBHelper();
    var resultObject = await _helper.getData(TempQuery.TABLE_NAME);
    return resultObject
        .map((item) => TempModel(
              id: item["id"],
              menuId: item["menu_id"],
              varian: item["variant"] ?? " ",
              varianId: item["variant_id"],
              total: item["total"],
              isTakeaway: item["is_takeaway"],
              qty: item["qty"],
              note: item["note"] ?? " ",
              price: item["price"],
              name: item["name"],
            ))
        .toList();
  }

  static Future<String> sendTransaksi(
      String nama, int meja, String tipe) async {
    // final date = DateTime.parse(tanggal);
    // final formatter = DateFormat('yyyy/mm/dd');
    // final searchDate = formatter.format(date);
    String isPaid = "";
    if (tipe == "cash") {
      isPaid = "";
    } else {
      isPaid = tipe;
    }
    try {
      DBHelper _helper = new DBHelper();
      var resultObject = await _helper.getData(TempQuery.TABLE_NAME);
      List<TempModel> temp = resultObject
          .map((item) => TempModel(
                id: item["id"],
                menuId: item["menu_id"],
                varian: item["varian"] ?? " ",
                varianId: item["variant_id"],
                total: item["total"],
                isTakeaway: item["is_takeaway"],
                qty: item["qty"],
                note: item["note"] ?? " ",
                price: item["price"],
                name: item["name"],
              ))
          .toList();
      final response = await http
          .post(Uri.parse(pengaturan.alamatIP + '/api/auth/save-order'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, dynamic>{
                'name': nama,
                'is_paid': '0',
                'table_id': meja,
                'time': '1',
                'price_type': tipe,
                'menus': resultObject
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        return "Sukses";
      } else {
        throw Exception(response.body);
      }
    } on TimeoutException catch (e) {
      return e.message.toString();
    } on SocketException {
      return "No Connection";
    }
  }

  static tambahData(Map<String, dynamic> data) async {
    DBHelper _helper = new DBHelper();
    await _helper.insert(TempQuery.TABLE_NAME, data);
  }

  static emptyData() async {
    DBHelper _helper = new DBHelper();
    await _helper.empty(TempQuery.TABLE_NAME);
  }

  static deleteData(int id) async {
    DBHelper _helper = new DBHelper();

    await _helper.remove(TempQuery.TABLE_NAME, "menu_id", id);
  }

  static totalTemp() async {
    DBHelper _helper = new DBHelper();
    var cariSum = await _helper.rawData(TempQuery.TotalTemp);
    var total = cariSum[0]['sum'] ?? 0;
    return total;
  }
}
