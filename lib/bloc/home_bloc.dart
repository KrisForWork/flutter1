import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../data/testing_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(HomeInitial()) {
    on<LoadHomeEvent>(_onLoad);
  }

  final TestingRepository _repository;

  Future<void> _onLoad(LoadHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final items = await _repository.getAll();
      emit(HomeLoaded(items));
    } on Object {
      emit(HomeError('Не удалось загрузить данные'));
    }
  }
}
