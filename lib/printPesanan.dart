import 'package:chasier/model/modelPenjualan.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:intl/intl.dart';
import 'pengaturan.dart' as pengaturan;

Future<Ticket> printPesanan({
  required PaperSize paper,
  required Future<ParsingPenjualan> dataPenjualan,
}) async {
  final Ticket ticket = Ticket(paper);
  final now = DateTime.now();
  final formatter = DateFormat('HH:mm');
  //final numberFormatter = new NumberFormat("#,###", "id_ID");
  final String timestamp = formatter.format(now);
  await dataPenjualan.then((data) {
    data.dataPenjualan.forEach((order) {
      if (order.groupDetails.isNotEmpty) {
        ticket.row([
          PosColumn(
              text: order.table.name,
              width: 4,
              styles: PosStyles(align: PosAlign.left)),
          PosColumn(
              text: order.name,
              width: 4,
              styles: PosStyles(align: PosAlign.center)),
          PosColumn(
              text: formatter.format(DateTime.parse(order.time)),
              width: 4,
              styles: PosStyles(align: PosAlign.right)),
        ]);
        ticket.hr();
        order.groupDetails.forEach((orderDetail) {
          ticket.row([
            PosColumn(
                text: orderDetail.qty.toString(),
                width: 2,
                styles: PosStyles(align: PosAlign.left)),
            PosColumn(
                text: orderDetail.menu.name,
                width: 10,
                styles: PosStyles(align: PosAlign.left)),
          ]);

          // ticket.row([
          //   PosColumn(
          //       text: orderDetail.varian.id.toString(),
          //       width: 12,
          //       styles: PosStyles(align: PosAlign.left)),
          // ]);
          if (orderDetail.isTakeaway == 1) {
            ticket.row([
              PosColumn(
                  text: "",
                  width: 2,
                  styles: PosStyles(align: PosAlign.left, reverse: true)),
              PosColumn(
                  text: "Takeaway",
                  width: 10,
                  styles: PosStyles(align: PosAlign.left, reverse: true)),
            ]);
          }
          if (orderDetail.varian.id != 0) {
            ticket.row([
              PosColumn(
                  text: "",
                  width: 2,
                  styles: PosStyles(align: PosAlign.left, reverse: true)),
              PosColumn(
                  text: orderDetail.varian.name,
                  width: 10,
                  styles: PosStyles(align: PosAlign.left, reverse: true)),
            ]);
          }
          if (orderDetail.note != "") {
            ticket.row([
              PosColumn(
                  text: "",
                  width: 2,
                  styles: PosStyles(align: PosAlign.left, reverse: true)),
              PosColumn(
                  text: orderDetail.note,
                  width: 10,
                  styles: PosStyles(align: PosAlign.left, reverse: true)),
            ]);
          }
        });
        ticket.feed(2);
      }
    });
    // ticket.cut();
  });

  return ticket;
}
