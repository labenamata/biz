import 'package:bloc/bloc.dart';
import 'package:chasier/model/modelTemp.dart';

class SendEvent {}

abstract class SendState {}

class SendLoaded extends SendState {
  //String status;
  String status;
  SendLoaded(this.status);
}

class SendLoading extends SendState {}

class SendErr extends SendState {
  String message;
  SendErr({required this.message});
}

class SendData extends SendEvent {
  String nama;
  int meja;
  String tipe;
  SendData({required this.nama, required this.meja, required this.tipe});
}

class SendBloc extends Bloc<SendEvent, SendState> {
  SendBloc(SendState initialState) : super(initialState);

  //TempState get initialState => PenjualanAwal();
  @override
  Stream<SendState> mapEventToState(SendEvent event) async* {
    if (event is SendData) {
      yield SendLoading();
      var status = TempModel.sendTransaksi(event.nama, event.meja, event.tipe);
      String message = "";
      status.then((value) => message = value);
      if (message == "sukses") {
        yield SendLoaded(message);
      } else {
        yield SendErr(message: message);
      }
    }
  }
}
