import 'package:bloc/bloc.dart';
import 'package:chasier/model/modelPenjualan.dart';

class OrderFinishEvent {}

abstract class OrderFinishState {}

class OrderFinishLoading extends OrderFinishState {}

class OrderFinishLoaded extends OrderFinishState {
  Future<ParsingPenjualan> penjualan;
  OrderFinishLoaded(this.penjualan);
}

class OrderFinishRefresh extends OrderFinishEvent {
  String status;
  int isDone;
  String nama;
  String tanggal;
  OrderFinishRefresh(this.status, this.isDone, this.nama, this.tanggal);
}

class OrderFinishError extends OrderFinishState {
  String message;
  OrderFinishError({required this.message});
}

class OrderFinishBloc extends Bloc<OrderFinishEvent, OrderFinishState> {
  OrderFinishBloc(OrderFinishState initialState) : super(initialState);
  //TotalOrderFinishState
  // get initialState => PenjualanAwal();
  @override
  Stream<OrderFinishState> mapEventToState(OrderFinishEvent event) async* {
    Future<ParsingPenjualan> penjualan;
    String message = "";
    if (event is OrderFinishRefresh) {
      yield OrderFinishLoading();
      penjualan = ParsingPenjualan.getPenjualan(
          event.status, event.isDone, event.nama, event.tanggal);
      await penjualan.then((value) => message = value.message);
      if (message == "sukses") {
        yield OrderFinishLoaded(penjualan);
      } else {
        yield OrderFinishError(message: message);
      }
    }
  }
}
