part of 'home_bloc.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<UserModel> users;
  HomeLoaded(this.users);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
