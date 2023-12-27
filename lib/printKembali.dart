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

Future<Ticket> struk2({
  required PaperSize paper,
  required Future<ParsingPenjualan> detailPenjualan,
}) async {
  final Ticket ticket = Ticket(paper);
  final now = DateTime.now();
  final formatter = DateFormat('dd/MM/yyyy HH:mm');
  final numberFormatter = new NumberFormat("#,###", "id_ID");
  final String timestamp = formatter.format(now);

  // final ByteData data = await rootBundle.load('assets/rabbit.jpg');
  // final Uint8List bytes = data.buffer.asUint8List();
  // final Image gambar = decodeImage(bytes);
  // ticket.image(gambar);
  await detailPenjualan.then((data) {
    String tanggal =
        formatter.format(DateTime.parse(data.dataPenjualan[0].time));

    ticket.text(
      pengaturan.namaToko,
      styles: PosStyles(
        align: PosAlign.center,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );
    ticket.text(
      "Dining & Coffe",
      styles: PosStyles(
        align: PosAlign.center,
        // height: PosTextSize.,
        // width: PosTextSize.size1,
      ),
    );

    ticket.text(pengaturan.alamat, styles: PosStyles(align: PosAlign.center));
    ticket.text(pengaturan.kota, styles: PosStyles(align: PosAlign.center));
    ticket.text(pengaturan.telepon, styles: PosStyles(align: PosAlign.center));
    ticket.hr();
    ticket.row([
      PosColumn(text: "Kasir", width: 6),
      PosColumn(
          text: pengaturan.kasir,
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    ticket.row([
      PosColumn(text: "Customer", width: 6),
      PosColumn(
          text: data.dataPenjualan[0].name,
          width: 6,
          styles: PosStyles(align: PosAlign.right)),
    ]);
    ticket.row([
      PosColumn(text: data.dataPenjualan[0].id.toString(), width: 6),
      PosColumn(
          text: tanggal, width: 6, styles: PosStyles(align: PosAlign.right)),
    ]);
    ticket.hr();
    data.dataPenjualan[0].groupDetails.forEach((value) {
      var jumlahTotal = value.qty * value.menu.price;
      ticket.row([
        PosColumn(
            text: value.menu.name,
            width: 12,
            styles: PosStyles(align: PosAlign.left)),
      ]);
      ticket.row([
        PosColumn(
            text: "Variant : " + value.varian.name,
            width: 12,
            styles: PosStyles(align: PosAlign.left)),
      ]);
      ticket.row([
        PosColumn(
            text: value.qty.toString(),
            width: 1,
            styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text: " x " + numberFormatter.format(value.menu.price),
            width: 5,
            styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text: " = ", width: 3, styles: PosStyles(align: PosAlign.left)),
        PosColumn(
            text: numberFormatter.format(jumlahTotal),
            width: 3,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    });
    ticket.hr();
    ticket.row([
      PosColumn(
          text: 'SubTotal',
          width: 6,
          styles: PosStyles(
              // height: PosTextSize.size2,
              // width: PosTextSize.size2,
              )),
      PosColumn(
          text: numberFormatter.format(data.dataPenjualan[0].subtotal),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            // height: PosTextSize.size2,
            // width: PosTextSize.size2,
          )),
    ]);
    ticket.row([
      PosColumn(
          text: 'PB1',
          width: 6,
          styles: PosStyles(
              // height: PosTextSize.size2,
              // width: PosTextSize.size2,
              )),
      PosColumn(
          text: numberFormatter.format(data.dataPenjualan[0].ppn),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            // height: PosTextSize.size2,
            // width: PosTextSize.size2,
          )),
    ]);
    ticket.row([
      PosColumn(
          text: 'Diskon',
          width: 6,
          styles: PosStyles(
              // height: PosTextSize.size2,
              // width: PosTextSize.size2,
              )),
      PosColumn(
          text: numberFormatter.format(data.dataPenjualan[0].diskon),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            // height: PosTextSize.size2,
            // width: PosTextSize.size2,
          )),
    ]);
    ticket.row([
      PosColumn(
          text: 'Total Bayar',
          width: 6,
          styles: PosStyles(
              // height: PosTextSize.size2,
              // width: PosTextSize.size2,
              )),
      PosColumn(
          text: numberFormatter.format(data.dataPenjualan[0].total),
          width: 6,
          styles: PosStyles(
            align: PosAlign.right,
            // height: PosTextSize.size2,
            // width: PosTextSize.size2,
          )),
    ]);

    ticket.hr(ch: '=', linesAfter: 1);
    if (data.dataPenjualan[0].priceType == "cash") {
      ticket.row([
        PosColumn(
            text: 'Cash',
            width: 7,
            styles: PosStyles(align: PosAlign.left, width: PosTextSize.size2)),
        PosColumn(
            text: numberFormatter.format(0),
            width: 5,
            styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
      ]);
    } else {
      ticket.row([
        PosColumn(
            text: data.dataPenjualan[0].priceType,
            width: 12,
            styles: PosStyles(align: PosAlign.left, width: PosTextSize.size2)),
      ]);
    }

    ticket.row([
      PosColumn(
          text: 'Change',
          width: 7,
          styles: PosStyles(align: PosAlign.left, width: PosTextSize.size2)),
      PosColumn(
          text: numberFormatter.format(0),
          width: 5,
          styles: PosStyles(align: PosAlign.right, width: PosTextSize.size2)),
    ]);

    ticket.feed(2);
    ticket.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    ticket.text(timestamp,
        styles: PosStyles(align: PosAlign.center), linesAfter: 0);
    ticket.cut();
  });

  return ticket;
}

decodeImage(Uint8List bytes) {}
