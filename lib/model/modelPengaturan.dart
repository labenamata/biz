import 'package:chasier/DBHelper.dart';
import 'package:chasier/database/pengaturanQuery.dart';
import 'package:chasier/database/tempQuery.dart';
import 'dart:io';

import 'package:chasier/pengaturan.dart' as pengaturan;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:chasier/token.dart' as token;

class PengaturanModel {
  String id;
  String nama;
  String alamat;
  String kota;
  String telepon;
  String alamatIP;
  String printerName1;
  String printerName2;
  String printerAddress1;
  String printerAddress2;

  PengaturanModel(
      {required this.id,
      required this.nama,
      required this.alamat,
      required this.kota,
      required this.telepon,
      required this.alamatIP,
      required this.printerName1,
      required this.printerName2,
      required this.printerAddress1,
      required this.printerAddress2});

  factory PengaturanModel.fromJson(Map<String, dynamic> json) {
    return PengaturanModel(
        id: json['id'],
        nama: json['nama'],
        alamat: json['alamat'],
        kota: json['kota'],
        telepon: json['telepon'],
        alamatIP: json['alamatIP'],
        printerName1: json['printerName1'],
        printerName2: json['printerName2'],
        printerAddress1: json['printerAddress1'],
        printerAddress2: json['printerAddress2']);
  }

  static Future<List<PengaturanModel>> showData() async {
    DBHelper _helper = new DBHelper();
    var resultObject = await _helper.getData(PengaturanQuery.TABLE_NAME);
    return resultObject
        .map((item) => PengaturanModel(
              id: item["id"].toString(),
              nama: item['nama'],
              alamat: item['alamat'],
              kota: item['kota'],
              telepon: item['telepon'],
              alamatIP: item['alamatIP'],
              printerName1: item['printerName1'],
              printerName2: item['printerName2'],
              printerAddress1: item['printerAddress1'] ?? "null",
              printerAddress2: item['printerAddress2'] ?? "null",
            ))
        .toList();
  }

  static simpanData(Map<String, dynamic> data) async {
    DBHelper _helper = new DBHelper();
    await _helper.insert(PengaturanQuery.TABLE_NAME, data);
  }
}
