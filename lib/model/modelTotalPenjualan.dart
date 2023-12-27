import 'dart:io';

import 'package:chasier/pengaturan.dart' as pengaturan;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:chasier/token.dart' as token;

class ParsingTotalPenjualan {
  String message;
  int total;
  List<ListPenjualan> penjualan;
  ParsingTotalPenjualan(
      {required this.message, required this.total, required this.penjualan});

  factory ParsingTotalPenjualan.fromJson(Map<String, dynamic> json) {
    var orders = json['orders'] as List;
    List<ListPenjualan> penjualan =
        orders.map((e) => ListPenjualan.fromJson(e)).toList();
    return ParsingTotalPenjualan(
        message: "sukses", total: json['sum'], penjualan: penjualan);
  }

  static Future<ParsingTotalPenjualan> getTotal(String tanggal) async {
    // final date = DateTime.parse(tanggal);
    // final formatter = DateFormat('yyyy/mm/dd');
    // final searchDate = formatter.format(date);
    try {
      final response = await http
          .post(Uri.parse(pengaturan.alamatIP + '/api/auth/get-orders'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(
                  <String, String>{'tanggal': tanggal, 'status': "paid"}))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        return ParsingTotalPenjualan.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load penjualan');
      }
    } on TimeoutException catch (e) {
      ParsingTotalPenjualan penjualan =
          ParsingTotalPenjualan(message: e.toString(), total: 0, penjualan: []);
      return penjualan;
    } on SocketException {
      ParsingTotalPenjualan penjualan = ParsingTotalPenjualan(
          message: "No Connection", total: 0, penjualan: []);
      return penjualan;
    }
  }
}

class Table {
  int id;
  String name;

  Table({required this.id, required this.name});

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(id: json['id'], name: json['nama']);
  }
}

class ListPenjualan {
  int id;
  String time;
  String name;
  int total;
  Table table;

  ListPenjualan(
      {required this.id,
      required this.name,
      required this.time,
      required this.total,
      required this.table});

  factory ListPenjualan.fromJson(Map<String, dynamic> json) {
    return ListPenjualan(
      id: json['id'] ?? 0,
      name: json['name'] ?? "null",
      time: json['time'] ?? "null",
      total: json['total'] ?? "null",
      table: Table.fromJson(json['table']),
    );
  }
}
