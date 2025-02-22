import 'dart:convert';

import 'package:buenas_practicas_app/core/errors/exceptions.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/utils/constants.dart';
import '../../../../core/utils/typedef.dart';
import '../models/user_model.dart';

import 'package:http/http.dart' as http;

abstract class AuthenticationRemoteDataSource {
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  });

  Future<List<UserModel>> getUsers();
}

const kCreateUserEndpoint = '/test-api/users';
const kGetUsersEndpoint = '/test-api/users';

class AuthenticationRemoteDataSourceImplementation
    extends AuthenticationRemoteDataSource {
  AuthenticationRemoteDataSourceImplementation(this._client);

  final http.Client _client;
  @override
  Future<void> createUser({
    required String createdAt,
    required String name,
    required String avatar,
  }) async {
    // 1. check to make sure that it returns the right data when the response
    // code is 200 or the proper repsonse code
    // 2. check to make sure that it "THROWS A CUSTOM EXCEPTION" with the
    // right message when status code is the bad one
    try {
      final response =
          await _client.post(Uri.https(kBaseUrl, kCreateUserEndpoint),
              body: jsonEncode(
                {
                  'createdAt': createdAt,
                  'name': name,
                  'avatar': avatar,
                },
              ),
              headers: {'Content-Type': 'application/json'});

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on APIException {
      rethrow;
    } catch (e) {
      throw APIException(message: e.toString(), statusCode: 505);
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      debugPrint('url de get users ${Uri.https(kBaseUrl, kGetUsersEndpoint)}');
      final response =
          await _client.get(Uri.https(kBaseUrl, kGetUsersEndpoint));

      print('status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        debugPrint(
            'List<DataMap>.from(jsonDecode(response.body) as List), ${List<DataMap>.from(jsonDecode(response.body) as List).map((userData) => UserModel.fromMap(userData)).toList()}');
        return List<DataMap>.from(jsonDecode(response.body) as List)
            .map((userData) => UserModel.fromMap(userData))
            .toList();
      } else {
        throw APIException(
          message: response.body,
          statusCode: response.statusCode,
        );
      }
    } on APIException {
      rethrow;
    } catch (e) {
      debugPrint('Error generico $e');
      throw APIException(message: e.toString(), statusCode: 500);
    }
  }
}
