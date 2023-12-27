import 'package:bloc/bloc.dart';
import 'package:chasier/model/modelPenjualan.dart';
import 'package:chasier/model/modelTemp.dart';
import 'package:equatable/equatable.dart';

class DetailEvent {}

abstract class DetailState extends Equatable {}

class DetailUn extends DetailState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class DetailUni extends DetailEvent {}

class DetailLoaded extends DetailState {
  final Future<ParsingPenjualan> detailPenjualan;
  DetailLoaded(this.detailPenjualan);

  @override
  List<Object?> get props => [detailPenjualan];
}

class DetailLoading extends DetailState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class DetailError extends DetailState {
  final String message;
  DetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

class DetailHapus extends DetailEvent {
  int penjualanId;
  int detailId;
  DetailHapus(this.penjualanId, this.detailId);
}

class DetailUpdateNote extends DetailEvent {
  int penjualanId;
  int detailId;
  String note;
  DetailUpdateNote(
      {required this.penjualanId, required this.detailId, required this.note});
}

class DetailCari extends DetailEvent {
  int id;
  DetailCari(this.id);
}

class TambahPesanan extends DetailEvent {
  int id;
  TambahPesanan(this.id);
}

class DetailPenjualanBloc extends Bloc<DetailEvent, DetailState> {
  DetailPenjualanBloc(DetailState initialState) : super(initialState);
  //DetailState get initialState => PenjualanAwal();
  @override
  Stream<DetailState> mapEventToState(DetailEvent event) async* {
    Future<ParsingPenjualan> detailPenjualan;
    Future<List<TempModel>> temps;
    List<TempModel> data = [];
    String message = "";
    if (event is DetailCari) {
      yield DetailLoading();
      detailPenjualan = ParsingPenjualan.getDetail(event.id);
      await detailPenjualan.then((value) => message = value.message);
      if (message == "sukses") {
        yield DetailLoaded(detailPenjualan);
      } else {
        yield DetailError(message: message);
      }
    }
    if (event is DetailUni) {
      yield DetailUn();
    }
    if (event is DetailHapus) {
      yield DetailLoading();
      var status = ParsingDetailPenjualan.deleteDetail(
          event.penjualanId, event.detailId);
      await status.then((value) => message = value);
      if (message == "sukses") {
        detailPenjualan = ParsingPenjualan.getDetail(event.penjualanId);
        await detailPenjualan.then((value) => message = value.message);
        if (message == "sukses") {
          yield DetailLoaded(detailPenjualan);
        } else {
          yield DetailError(message: message);
        }
      } else {
        yield DetailError(message: message);
      }
    }
    if (event is DetailUpdateNote) {
      yield DetailLoading();
      var status = ParsingDetailPenjualan.updateDetail(
          event.penjualanId, event.detailId, event.note);
      await status.then((value) => message = value);
      if (message == "sukses") {
        detailPenjualan = ParsingPenjualan.getDetail(event.penjualanId);
        await detailPenjualan.then((value) => message = value.message);
        if (message == "sukses") {
          yield DetailLoaded(detailPenjualan);
        } else {
          yield DetailError(message: message);
        }
      } else {
        yield DetailError(message: message);
      }
    }

    if (event is TambahPesanan) {
      yield DetailLoading();
      temps = TempModel.showData();
      await temps.then((value) => data = value);
      detailPenjualan = ParsingPenjualan.addOrder(event.id, data);
      await detailPenjualan.then((value) => message = value.message);
      if (message == "sukses") {
        detailPenjualan = ParsingPenjualan.getDetail(event.id);
        await detailPenjualan.then((value) => message = value.message);
        if (message == "sukses") {
          yield DetailLoaded(detailPenjualan);
        } else {
          yield DetailError(message: message);
        }
      } else {
        yield DetailError(message: message);
      }
    }
  }
}
