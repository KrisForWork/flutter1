import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/testing_data.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeEvent>(_onLoad);
  }

  Future<void> _onLoad(LoadHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      emit(HomeLoaded(testingItems));
    } on Object {
      emit(HomeError('Не удалось загрузить данные'));
    }
  }
}
