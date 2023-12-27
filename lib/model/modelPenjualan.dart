import 'dart:io';

import 'package:chasier/model/modelTemp.dart';
import 'package:chasier/pengaturan.dart' as pengaturan;
import 'package:chasier/token.dart' as token;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ParsingPenjualan {
  String message;
  List<Penjualan> dataPenjualan;

  ParsingPenjualan({required this.message, required this.dataPenjualan});

  factory ParsingPenjualan.fromJson(Map<String, dynamic> json) {
    var jsonPenjualan = json['orders'] as List;
    List<Penjualan> listPenjualan =
        jsonPenjualan.map((item) => Penjualan.fromJson(item)).toList();
    return ParsingPenjualan(message: "sukses", dataPenjualan: listPenjualan);
  }

  static Future<ParsingPenjualan> getPenjualan(
      String status, int isdone, String nama, String tanggal) async {
    try {
      final response = await http
          .post(Uri.parse(pengaturan.alamatIP + '/api/auth/get-orders'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, String>{
                'is_done': isdone.toString(),
                'status': status,
                'nama': nama,
                'tanggal': tanggal,
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        return ParsingPenjualan.fromJson(jsonDecode(response.body));
      } else {
        ParsingPenjualan penjualan =
            ParsingPenjualan(message: "Unauthorized", dataPenjualan: []);
        return penjualan;
      }
    } on TimeoutException catch (e) {
      ParsingPenjualan penjualan =
          ParsingPenjualan(message: e.toString(), dataPenjualan: []);
      return penjualan;
    } on SocketException {
      ParsingPenjualan penjualan =
          ParsingPenjualan(message: "No Connection", dataPenjualan: []);
      return penjualan;
    }
  }

  static Future<ParsingPenjualan> getDetail(int id) async {
    try {
      final response = await http
          .post(Uri.parse(pengaturan.alamatIP + '/api/auth/get-orders'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, String>{
                'order_id': id.toString(),
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        return ParsingPenjualan.fromJson(jsonDecode(response.body));
      } else {
        ParsingPenjualan penjualan =
            ParsingPenjualan(message: response.body, dataPenjualan: []);
        return penjualan;
      }
    } on TimeoutException catch (e) {
      ParsingPenjualan penjualan =
          ParsingPenjualan(message: e.toString(), dataPenjualan: []);
      return penjualan;
    } on SocketException {
      ParsingPenjualan penjualan =
          ParsingPenjualan(message: "No Connection", dataPenjualan: []);
      return penjualan;
    }
  }

  static Future<ParsingPenjualan> addOrder(
      int id, List<TempModel> detail) async {
    try {
      final response = await http
          .post(Uri.parse(pengaturan.alamatIP + '/api/auth/add-order'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, dynamic>{
                'id': id.toString(),
                'detail': detail,
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        //throw Exception(response.body);
        return ParsingPenjualan.fromJson(jsonDecode(response.body));
      } else {
        ParsingPenjualan penjualan =
            ParsingPenjualan(message: response.body, dataPenjualan: []);
        return penjualan;
      }
    } on TimeoutException catch (e) {
      ParsingPenjualan penjualan =
          ParsingPenjualan(message: e.toString(), dataPenjualan: []);
      return penjualan;
    } on SocketException {
      ParsingPenjualan penjualan =
          ParsingPenjualan(message: "No Connection", dataPenjualan: []);
      return penjualan;
    }
  }

  static Future<ParsingPenjualan> cekPrinted(
      {required String status,
      required int isdone,
      required int isprinted}) async {
    try {
      final response = await http
          .post(Uri.parse(pengaturan.alamatIP + '/api/auth/get-orders'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, String>{
                'is_done': isdone.toString(),
                'status': status,
                'is_printed': isprinted.toString(),
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        return ParsingPenjualan.fromJson(jsonDecode(response.body));
      } else {
        ParsingPenjualan penjualan =
            ParsingPenjualan(message: "Unauthorized", dataPenjualan: []);
        return penjualan;
      }
    } on TimeoutException catch (e) {
      ParsingPenjualan penjualan =
          ParsingPenjualan(message: e.toString(), dataPenjualan: []);
      return penjualan;
    } on SocketException {
      ParsingPenjualan penjualan =
          ParsingPenjualan(message: "No Connection", dataPenjualan: []);
      return penjualan;
    }
  }

  static Future<String> updatePrinted({
    required List<Penjualan> penjualan,
  }) async {
    try {
      final response = await http
          .post(Uri.parse(pengaturan.alamatIP + '/api/auth/update-printed'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, dynamic>{
                'order': penjualan,
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        return "sukses";
      } else {
        return response.body;
      }
    } on TimeoutException catch (e) {
      return "Unauthorized";
    } on SocketException {
      return "Unauthorized";
    }
  }

  static Future<ParsingPenjualan> cekUpdate(int idDetail, String status) async {
    final response =
        await http.post(Uri.parse(pengaturan.alamatIP + '/penjualan/ceklist'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'idDetail': idDetail.toString(),
              'cek': status,
            }));
    if (response.statusCode == 200) {
      return ParsingPenjualan.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load penjualan');
    }
  }

  static Future<String> bayarPenjualan(
      int idPenjualan, int diskon, int total) async {
    try {
      final response = await http
          .post(
              Uri.parse(pengaturan.alamatIP +
                  '/api/auth/update-order/' +
                  idPenjualan.toString()),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, String>{
                'is_paid': "1",
                'diskon': diskon.toString(),
                'total': total.toString()
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        //var message = jsonDecode(jsonDecode(response.body));
        return "sukses";
      } else {
        // var message = jsonDecode(jsonDecode(response.body));
        return response.statusCode.toString();
      }
    } on TimeoutException catch (e) {
      return e.toString();
    } on SocketException {
      return "No Connection";
    }
  }

  static Future<String> updateOrder(int idPenjualan) async {
    try {
      final response = await http
          .post(
              Uri.parse(pengaturan.alamatIP +
                  '/api/auth/update-order/' +
                  idPenjualan.toString()),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, String>{
                'is_done': "1",
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        //var message = jsonDecode(jsonDecode(response.body));
        return "sukses";
      } else {
        // var message = jsonDecode(jsonDecode(response.body));
        return response.statusCode.toString();
      }
    } on TimeoutException catch (e) {
      return e.toString();
    } on SocketException {
      return "No Connection";
    }
  }
}

class ParsingDetailPenjualan {
  String message;
  List<DetailPenjualan> detailPenjualan;

  ParsingDetailPenjualan(
      {required this.message, required this.detailPenjualan});

  factory ParsingDetailPenjualan.fromJson(List<dynamic> json) {
    List<DetailPenjualan> listPenjualan =
        json.map((item) => DetailPenjualan.fromJson(item)).toList();
    return ParsingDetailPenjualan(
        message: "sukses", detailPenjualan: listPenjualan);
  }
  static Future<String> deleteDetail(int idPenjualan, int idDetail) async {
    try {
      final response = await http
          .post(
              Uri.parse(pengaturan.alamatIP +
                  '/api/auth/delete-order-detail/' +
                  idDetail.toString()),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, String>{
                'order_id': idPenjualan.toString(),
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        //var message = jsonDecode(jsonDecode(response.body));
        return "sukses";
      } else {
        // var message = jsonDecode(jsonDecode(response.body));
        return response.body;
      }
    } on TimeoutException catch (e) {
      return e.toString();
    } on SocketException {
      return "No Connection";
    }
  }

  static Future<String> updateDetail(
      int idPenjualan, int idDetail, String note) async {
    try {
      final response = await http
          .post(
              Uri.parse(pengaturan.alamatIP +
                  '/api/auth/update-order-detail/' +
                  idDetail.toString()),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, String>{
                'order_id': idPenjualan.toString(),
                'note': note,
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        //var message = jsonDecode(jsonDecode(response.body));
        return "sukses";
      } else {
        // var message = jsonDecode(jsonDecode(response.body));
        return response.body;
      }
    } on TimeoutException catch (e) {
      return e.toString();
    } on SocketException {
      return "No Connection";
    }
  }

  static Future<ParsingDetailPenjualan> getDetail(int id) async {
    try {
      final response = await http
          .post(Uri.parse(pengaturan.alamatIP + '/api/auth/get-order-details'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, String>{
                'order_id': id.toString(),
                //'status': "unpaid"
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        return ParsingDetailPenjualan.fromJson(jsonDecode(response.body));
      } else {
        ParsingDetailPenjualan penjualan = ParsingDetailPenjualan(
            message: "Unauthorized", detailPenjualan: []);
        return penjualan;
      }
    } on TimeoutException catch (e) {
      ParsingDetailPenjualan penjualan =
          ParsingDetailPenjualan(message: e.toString(), detailPenjualan: []);
      return penjualan;
    } on SocketException {
      ParsingDetailPenjualan penjualan =
          ParsingDetailPenjualan(message: "No Connection", detailPenjualan: []);
      return penjualan;
    }
  }
}

class Table {
  int id;
  String name;
  Table({required this.id, required this.name});
  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(id: json['id'], name: json['name']);
  }
}

class Penjualan {
  int id;
  String time;
  String name;
  int total;
  int diskon;
  int subtotal;
  int ppn;
  String priceType;
  Table table;
  List<DetailPenjualan> detailPenjualan;
  List<DetailPenjualan> groupDetails;

  Penjualan(
      {required this.id,
      required this.time,
      required this.name,
      required this.total,
      required this.subtotal,
      required this.ppn,
      required this.diskon,
      required this.table,
      required this.priceType,
      required this.groupDetails,
      required this.detailPenjualan});

  factory Penjualan.fromJson(Map<String, dynamic> json) {
    var detail = json['group_details'] as List;
    var detail2 = json['role_details'] as List;

    return Penjualan(
      id: json['id'] ?? 0,
      time: json['time'] ?? "null",
      name: json['name'] ?? "No Name",
      total: json['total'] ?? 0,
      subtotal: json['subtotal'] ?? 0,
      diskon: json['discount'] ?? 0,
      ppn: json['ppn'] ?? 0,
      priceType: json['price_type'] ?? "cash",
      table: Table.fromJson(json['table']),
      detailPenjualan: detail2.map((e) => DetailPenjualan.fromJson(e)).toList(),
      groupDetails: detail.map((e) => DetailPenjualan.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class Menu {
  int id;
  String name;
  int price;

  Menu({required this.id, required this.name, required this.price});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(id: json['id'], name: json['name'], price: json['price_sell']);
  }
}

class DetailPenjualan {
  int id;
  int isDone;
  int isPrinted;
  int isTakeaway;
  int qty;
  String note;
  Menu menu;
  Varian varian;

  DetailPenjualan({
    required this.id,
    required this.isDone,
    required this.menu,
    required this.isPrinted,
    required this.isTakeaway,
    required this.note,
    required this.qty,
    required this.varian,
  });
  factory DetailPenjualan.fromJson(Map<String, dynamic> json) {
    //var data = jsonDecode(json['data']);
    return DetailPenjualan(
        id: json['id'] ?? 0,
        isDone: json['is_done'] ?? 0,
        isPrinted: json['is_printed'] ?? 0,
        isTakeaway: json['is_takeaway'] ? 1 : 0,
        note: json['note'] ?? "",
        qty: json['qty'] ?? 0,
        menu: Menu.fromJson(json['menu']),
        varian: Varian.fromJson(json['menu_variant'] ?? {}));
  }
}

class Varian {
  int id;
  String name;
  Varian({required this.id, required this.name});
  factory Varian.fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      return Varian(id: 0, name: "");
    } else {
      return Varian(id: json['id'] ?? 0, name: json['name'] ?? "");
    }
  }
}

class Produk {
  int idProduk;
  String namaProduk;

  Produk({required this.idProduk, required this.namaProduk});

  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
        idProduk: json['idProduk'] ?? 0,
        namaProduk: json['namaProduk'] ?? "null");
  }
}
