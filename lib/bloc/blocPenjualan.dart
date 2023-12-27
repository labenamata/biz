import 'package:bloc/bloc.dart';
import 'package:chasier/model/modelPenjualan.dart';

class PenjualanEvent {}

abstract class PenjualanState {}

class PenjualanKosong extends PenjualanState {}

class PenjualanLoaded extends PenjualanState {
  Future<ParsingPenjualan> penjualan;
  PenjualanLoaded(this.penjualan);
}

class PenjualanRefresh extends PenjualanEvent {
  String status;
  int isDone;
  String nama;
  PenjualanRefresh(this.status, this.isDone, this.nama);
}

class OrderRefresh extends PenjualanEvent {
  String status;
  int isDone;
  String nama;
  OrderRefresh(this.status, this.isDone, this.nama);
}

class PenjualanBayar extends PenjualanEvent {
  int idPenjualan;
  int diskon;
  int total;

  PenjualanBayar({
    required this.idPenjualan,
    required this.diskon,
    required this.total,
  });
}

class UpdateOrder extends PenjualanEvent {
  int idPenjualan;
  UpdateOrder({required this.idPenjualan});
}

class PenjualanError extends PenjualanState {
  String message;
  PenjualanError({required this.message});
}

class PenjualanBloc extends Bloc<PenjualanEvent, PenjualanState> {
  PenjualanBloc(PenjualanState initialState) : super(initialState);
  //TotalPenjualanState get initialState => PenjualanAwal();
  @override
  Stream<PenjualanState> mapEventToState(PenjualanEvent event) async* {
    Future<ParsingPenjualan> penjualan;
    String message = "";
    Future<String> status;
    String pesan = "";
    if (event is PenjualanRefresh) {
      yield PenjualanKosong();
      penjualan = ParsingPenjualan.getPenjualan(
          event.status, event.isDone, event.nama, "");
      await penjualan.then((value) => message = value.message);
      if (message == "sukses") {
        yield PenjualanLoaded(penjualan);
      } else {
        yield PenjualanError(message: message);
      }
    }
    if (event is OrderRefresh) {
      penjualan = ParsingPenjualan.getPenjualan(
          event.status, event.isDone, event.nama, "");
      await penjualan.then((value) => message = value.message);
      if (message == "sukses") {
        yield PenjualanLoaded(penjualan);
      } else {
        yield PenjualanError(message: message);
      }
    }

    if (event is PenjualanBayar) {
      yield PenjualanKosong();
      status = ParsingPenjualan.bayarPenjualan(
          event.idPenjualan, event.diskon, event.total);
      await status.then((value) => pesan = value);
      if (pesan == "sukses") {
        penjualan = ParsingPenjualan.getPenjualan("unpaid", 0, "", "");
        await penjualan.then((value) => message = value.message);
        if (message == "sukses") {
          yield PenjualanLoaded(penjualan);
        } else {
          yield PenjualanError(message: message);
        }
      } else {
        yield PenjualanError(message: pesan);
      }
    }

    if (event is UpdateOrder) {
      //yield PenjualanKosong();
      status = ParsingPenjualan.updateOrder(event.idPenjualan);
    }
  }
}
