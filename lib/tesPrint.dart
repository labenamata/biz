import 'dart:typed_data';
import 'package:chasier/bloc/blocLogin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart';
import 'package:chasier/model/modelPenjualan.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'pengaturan.dart' as pengaturan;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' hide Image;

Future<Ticket> tesprint({
  required PaperSize paper,
}) async {
  final Ticket ticket = Ticket(paper);
  final now = DateTime.now();
  final formatter = DateFormat('dd/MM/yyyy HH:mm');
  final String timestamp = formatter.format(now);
  ticket.text(
    "TEST PRINT",
    styles: PosStyles(
      align: PosAlign.center,
      height: PosTextSize.size1,
      width: PosTextSize.size1,
    ),
  );

  ticket.text(timestamp, styles: PosStyles(align: PosAlign.center));
  ticket.text(
      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
      styles: PosStyles(align: PosAlign.left));

  ticket.cut();

  return ticket;
}

decodeImage(Uint8List bytes) {}
