import 'dart:io';

import 'package:chasier/pengaturan.dart' as pengaturan;
import 'package:chasier/token.dart' as token;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ParsingMenu {
  String message;
  List<Menu> menus;

  ParsingMenu({required this.message, required this.menus});

  factory ParsingMenu.fromJson(List<dynamic> json) {
    //var jsonMenu = json as List;
    List<Menu> listMenu = json.map((item) => Menu.fromJson(item)).toList();
    return ParsingMenu(message: "sukses", menus: listMenu);
  }
  static Future<ParsingMenu> getMenu(String nama) async {
    try {
      final response = await http
          .post(Uri.parse(pengaturan.alamatIP + '/api/auth/get-menus'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, String>{
                // 'is_done': isdone.toString(),
                // 'status': status,
                'nama': nama,
              }))
          .timeout(Duration(seconds: 20), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        return ParsingMenu.fromJson(jsonDecode(response.body));
      } else {
        ParsingMenu menu = ParsingMenu(message: "Unauthorized", menus: []);
        return menu;
      }
    } on TimeoutException catch (e) {
      ParsingMenu menu = ParsingMenu(message: "Unauthorized", menus: []);
      return menu;
    } on SocketException {
      ParsingMenu menu = ParsingMenu(message: "No Connection", menus: []);
      return menu;
    }
  }

  static Future<String?> updateStok(int id, int stok, int visible) async {
    try {
      final response = await http
          .post(
              Uri.parse(pengaturan.alamatIP +
                  '/api/auth/update-stock/' +
                  id.toString()),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
                'Accept': 'application/json',
                'Authorization': 'Bearer ' + token.accessToken,
              },
              body: jsonEncode(<String, String>{
                // 'is_done': isdone.toString(),
                // 'status': status,
                'stock': stok.toString(),
                'visible': visible.toString(),
              }))
          .timeout(Duration(seconds: 5), onTimeout: () {
        throw TimeoutException(
            'The connection has timed out, Please try again!');
      });
      if (response.statusCode == 200) {
        return "sukses";
      } else {
        return "Unauthorized";
      }
    } on TimeoutException catch (e) {
      return e.message;
    } on SocketException {
      return "No Connection";
    }
  }
}

class Varian {
  int id;
  String name;
  Varian({required this.id, required this.name});
  factory Varian.fromJson(Map<String, dynamic> json) {
    return Varian(id: json['id'], name: json['name']);
  }
}

class Menu {
  int id;
  String name;
  int price;
  int priceGofood;
  int priceGrabfood;
  int stok;
  int isVisible;
  List<Varian> varians;
  Menu({
    required this.id,
    required this.name,
    required this.price,
    required this.priceGofood,
    required this.priceGrabfood,
    required this.varians,
    required this.stok,
    required this.isVisible,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    var varian = json['active_menu_variants'] as List;

    return Menu(
        id: json['id'],
        name: json['name'],
        price: json['price_sell'] ?? 0,
        priceGofood: json['price_gofood'] ?? 0,
        priceGrabfood: json['price_grabfood'] ?? 0,
        stok: json['stock'] ?? 0,
        isVisible: json['visible'] ? 1 : 0,
        varians: varian.map((e) => Varian.fromJson(e)).toList());
  }
}
