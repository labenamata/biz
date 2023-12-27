import 'package:bloc/bloc.dart';
import 'package:chasier/DBHelper.dart';
import 'package:chasier/model/modelTemp.dart';

class TempEvent {}

abstract class TempState {}

class TempLoaded extends TempState {
  //String status;
  Future<List<TempModel>> data;
  int total;
  TempLoaded(this.data, this.total);
}

class TempLoading extends TempState {}

class TempError extends TempState {
  String message;
  TempError({required this.message});
}

class HapusTemp extends TempEvent {
  int menuId;
  HapusTemp({required this.menuId});
}

class GetTemp extends TempEvent {}

class EmptyTemp extends TempEvent {}

class TempAdd extends TempEvent {
  int id;
  String name;
  int varianId;
  String varian;
  int isTakeaway;
  int price;
  int qty;
  String note;
  TempAdd(
      {required this.id,
      required this.varian,
      required this.varianId,
      required this.isTakeaway,
      required this.name,
      required this.price,
      required this.note,
      required this.qty});
}

class TempBloc extends Bloc<TempEvent, TempState> {
  TempBloc(TempState initialState) : super(initialState);

  //TempState get initialState => PenjualanAwal();
  @override
  Stream<TempState> mapEventToState(TempEvent event) async* {
    Future<List<TempModel>> temps;
    if (event is GetTemp) {
      yield TempLoading();
      temps = TempModel.showData();
      var total = await TempModel.totalTemp();
      yield TempLoaded(temps, total == "null" ? 0 : total);
    }

    if (event is TempAdd) {
      yield TempLoading();
      int jumlah;
      int qty = event.qty;
      DBHelper _helper = new DBHelper();
      var cariData = await _helper.tempData(event.id);
      if (cariData.isNotEmpty) {
        qty = qty + int.parse(cariData[0]['qty'].toString());
      }
      jumlah = qty * event.price;
      await TempModel.tambahData({
        "menu_id": event.id.toString(),
        "name": event.name,
        "note": event.note,
        "variant": event.varian,
        "variant_id": event.varianId,
        "qty": qty,
        "total": jumlah,
        "is_takeaway": event.isTakeaway,
        "price": event.price.toString(),
      });
      temps = TempModel.showData();
      var total = await TempModel.totalTemp();
      yield TempLoaded(temps, total);
    }
    if (event is EmptyTemp) {
      yield TempLoading();
      await TempModel.emptyData();
      temps = TempModel.showData();

      yield TempLoaded(temps, 0);
    }
    if (event is HapusTemp) {
      yield TempLoading();
      await TempModel.deleteData(event.menuId);
      temps = TempModel.showData();
      var total = await TempModel.totalTemp();
      yield TempLoaded(temps, total);
    }
  }
}
