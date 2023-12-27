import 'dart:io';

import 'package:chasier/pengaturan.dart' as pengaturan;
import 'package:chasier/token.dart' as token;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ParsingTable {
  String message;
  List<Table> tables;

  ParsingTable({required this.message, required this.tables});

  factory ParsingTable.fromJson(List<dynamic> json) {
    //var jsonTable = json as List;
    List<Table> listTable = json.map((item) => Table.fromJson(item)).toList();
    return ParsingTable(message: "sukses", tables: listTable);
  }
  static Future<ParsingTable> getTable() async {
    try {
      final response = await http.post(
        Uri.parse(pengaturan.alamatIP + '/api/auth/get-tables'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + token.accessToken,
        },
      ).timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        return ParsingTable.fromJson(jsonDecode(response.body));
      } else {
        ParsingTable menu = ParsingTable(message: "Unauthorized", tables: []);
        return menu;
      }
    } on TimeoutException catch (e) {
      ParsingTable menu = ParsingTable(message: "Unauthorized", tables: []);
      return menu;
    } on SocketException {
      ParsingTable menu = ParsingTable(message: "No Connection", tables: []);
      return menu;
    }
  }
}

class Table {
  int id;
  String name;

  Table({
    required this.id,
    required this.name,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'],
      name: json['name'],
    );
  }
}
