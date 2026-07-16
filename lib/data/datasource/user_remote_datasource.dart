import 'package:dio/dio.dart';
import '../models/user_model.dart';

class UserRemoteDatasource {
  final Dio _dio = Dio();

  Future<List<UserModel>> getUsers() async {
    final response = await _dio.get('https://randomuser.me/api/?results=20');

    if (response.statusCode == 200) {
      final List results = response.data['results'];
      return results.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch users: ${response.statusCode}');
    }
  }
}
