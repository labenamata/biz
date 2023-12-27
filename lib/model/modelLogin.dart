import 'dart:io';

import 'package:chasier/pengaturan.dart' as pengaturan;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ParsingLogin {
  String message;
  String accessToken;
  String tokenType;
  String expiresAt;
  Profile profile;

  ParsingLogin(
      {required this.message,
      required this.accessToken,
      required this.tokenType,
      required this.expiresAt,
      required this.profile});

  factory ParsingLogin.fromJson(Map<String, dynamic> json) {
    Profile profile = Profile.fromJson(json['profile']);
    return ParsingLogin(
        message: "sukses",
        accessToken: json['access_token'],
        tokenType: json['token_type'],
        expiresAt: json['expires_at'],
        profile: profile);
  }

  static Future<ParsingLogin> loginMasuk(String user, String pass) async {
    String url = pengaturan.alamatIP + "/api/auth/login";

    try {
      final response = await http
          .post(Uri.parse(url),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'email': user,
                'password': pass,
              }))
          .timeout(
        Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException(
              'The connection has timed out, Please try again!');
        },
      );
      if (response.statusCode == 200) {
        return ParsingLogin.fromJson(jsonDecode(response.body));
      } else {
        ParsingLogin login = ParsingLogin(
          message: "Unauthorized",
          accessToken: "",
          tokenType: "",
          expiresAt: "",
          profile: Profile(id: 0, name: "", email: "", status: "", roles: []),
        );
        return login;
      }
    } on TimeoutException catch (e) {
      ParsingLogin login = ParsingLogin(
        message: e.toString(),
        accessToken: "",
        tokenType: "",
        expiresAt: "",
        profile: Profile(id: 0, name: "", email: "", status: "", roles: []),
      );
      return login;
    } on SocketException {
      ParsingLogin login = ParsingLogin(
        message: "No Connection",
        accessToken: "",
        tokenType: "",
        expiresAt: "",
        profile: Profile(id: 0, name: "", email: "", status: "", roles: []),
      );
      return login;
    }
  }
}

class Roles {
  int id;
  String name;

  Roles({required this.id, required this.name});
  factory Roles.fromJson(Map<String, dynamic> json) {
    return Roles(id: json['id'] ?? 0, name: json['name'] ?? "");
  }
}

class Profile {
  int id;
  String name;
  String email;
  //int is_first_login;
  String status;
  List<Roles> roles;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    //required this.is_first_login,
    required this.status,
    required this.roles,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    var roles = json['roles'] as List;
    return Profile(
        id: json['id'] ?? 0,
        name: json['name'] ?? "null",
        email: json['email'] ?? "null",
        status: json['status'] ?? "null",
        roles: roles.map((item) => Roles.fromJson(item)).toList());
  }
}
