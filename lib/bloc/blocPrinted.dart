import 'package:bloc/bloc.dart';
import 'package:chasier/model/modelPenjualan.dart';

class PrintedEvent {}

abstract class PrintedState {}

class PrintedLoading extends PrintedState {}

class PrintedLoaded extends PrintedState {
  Future<ParsingPenjualan> penjualan;
  PrintedLoaded(this.penjualan);
}

class PrintedRefresh extends PrintedEvent {
  String status;
  int isDone;
  int isPrinted;
  PrintedRefresh(
      {required this.status, required this.isDone, required this.isPrinted});
}

class OrderRefresh extends PrintedEvent {
  String status;
  int isDone;
  String nama;
  OrderRefresh(this.status, this.isDone, this.nama);
}

class PenjualanBayar extends PrintedEvent {
  int idPenjualan;
  PenjualanBayar({required this.idPenjualan});
}

class UpdateOrder extends PrintedEvent {
  int idPenjualan;
  UpdateOrder({required this.idPenjualan});
}

class PenjualanError extends PrintedState {
  String message;
  PenjualanError({required this.message});
}

class PrintedBloc extends Bloc<PrintedEvent, PrintedState> {
  PrintedBloc(PrintedState initialState) : super(initialState);
  //TotalPrintedState get initialState => PenjualanAwal();
  @override
  Stream<PrintedState> mapEventToState(PrintedEvent event) async* {
    Future<ParsingPenjualan> penjualan;
    String message = "";
    if (event is PrintedRefresh) {
      yield PrintedLoading();
      penjualan = ParsingPenjualan.cekPrinted(
          status: event.status,
          isdone: event.isDone,
          isprinted: event.isPrinted);
      await penjualan.then((value) => message = value.message);
      if (message == "sukses") {
        yield PrintedLoaded(penjualan);
      } else {
        yield PenjualanError(message: message);
      }
    }
  }
}
