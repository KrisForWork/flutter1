import '../models/testing_type.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  HomeLoaded(this.items);

  final List<TestingType> items;
}

class HomeError extends HomeState {
  HomeError(this.message);

  final String message;
}
