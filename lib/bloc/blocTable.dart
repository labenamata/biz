import 'package:bloc/bloc.dart';
import 'package:chasier/model/modelTable.dart';
import 'package:equatable/equatable.dart';

class TablesEvent {}

abstract class TablesState extends Equatable {}

class TablesLoaded extends TablesState {
  //String status;
  final Future<ParsingTable> data;
  TablesLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class TablesLoading extends TablesState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TablesError extends TablesState {
  final String message;
  TablesError({required this.message});

  @override
  List<Object?> get props => [message];
}

class GetTables extends TablesEvent {}

class TablesBloc extends Bloc<TablesEvent, TablesState> {
  TablesBloc(TablesState initialState) : super(initialState);
  //TablesState get initialState => PenjualanAwal();
  @override
  Stream<TablesState> mapEventToState(TablesEvent event) async* {
    Future<ParsingTable> tables;
    String message = "";

    if (event is GetTables) {
      yield TablesLoading();
      tables = ParsingTable.getTable();
      await tables.then((value) => message = value.message);
      if (message == "sukses") {
        yield TablesLoaded(tables);
      } else {
        yield TablesError(message: message);
      }
    }
  }
}
