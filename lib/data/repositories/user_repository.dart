import '../datasource/user_remote_datasource.dart';
import '../models/user_model.dart';

class UserRepository {
  final UserRemoteDatasource _remoteDatasource;

  UserRepository({required UserRemoteDatasource remoteDatasource})
      : _remoteDatasource = remoteDatasource;

  Future<List<UserModel>> fetchUsers() => _remoteDatasource.getUsers();
}
