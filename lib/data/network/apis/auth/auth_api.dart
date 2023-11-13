import 'dart:async';

import 'package:boilerplate/core/data/network/dio/dio_client.dart';
import 'package:boilerplate/data/network/constants/endpoints.dart';
import 'package:boilerplate/data/network/rest_client.dart';
import 'package:boilerplate/domain/entity/user/user.dart';

class AuthApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
  final RestClient _restClient;

  // injecting dio instance
  AuthApi(this._dioClient, this._restClient);

  /// Returns list of post in response
  Future<User?> login(params) async {
    try {
      final res = await _dioClient.dio.post(
        Endpoints.login,
        data: {
          'userNameOrEmailAddress': params.username,
          'password': params.password,
        },
      );
      return User();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
