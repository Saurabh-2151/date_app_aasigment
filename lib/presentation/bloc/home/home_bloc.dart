import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository _userRepository;

  HomeBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(HomeInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<RefreshUsers>(_onRefreshUsers);
  }

  Future<void> _onLoadUsers(LoadUsers event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final users = await _userRepository.fetchUsers();
      emit(HomeLoaded(users));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshUsers(RefreshUsers event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final users = await _userRepository.fetchUsers();
      emit(HomeLoaded(users));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
