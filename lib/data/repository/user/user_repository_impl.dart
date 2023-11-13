import 'dart:async';

import 'package:boilerplate/domain/repository/user/user_repository.dart';
import 'package:boilerplate/data/sharedpref/shared_preference_helper.dart';
import 'package:boilerplate/data/network/apis/auth/auth_api.dart';

import '../../../domain/entity/user/user.dart';
import '../../../domain/usecase/user/login_usecase.dart';

class UserRepositoryImpl extends UserRepository {
  // shared pref object
  final SharedPreferenceHelper _sharedPrefsHelper;

  final AuthApi _authApi;

  // constructor
  UserRepositoryImpl(this._authApi, this._sharedPrefsHelper);

  // Login:---------------------------------------------------------------------
  @override
  Future<User?> login(LoginParams params) async {
    return await _authApi.login(params).then((value) {
      return value;
    }).catchError((error) => throw error);
  }

  @override
  Future<void> saveIsLoggedIn(bool value) =>
      _sharedPrefsHelper.saveIsLoggedIn(value);

  @override
  Future<bool> get isLoggedIn => _sharedPrefsHelper.isLoggedIn;
}
