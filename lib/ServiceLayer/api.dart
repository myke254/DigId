import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Api{
  final Dio api = Dio();
  String? accessToken;

// will throw an error
  final _storage = const FlutterSecureStorage();

  Api() {
    api.interceptors
        .add(InterceptorsWrapper(onRequest: (options, handler) async {
          print(options);
      if (!options.path.contains('https')) {
        options.path = 'https://api-omnichannel-uat.azure-api.net' + options.path;
      }
      options.headers['Authorization'] = 'Bearer $accessToken';

      return handler.next(options);
    }, onError: (DioError error, handler) async {
      if ((error.response?.statusCode == 401 &&
          error.response?.data['message'] == "Invalid JWT")) {
        if (await _storage.containsKey(key: 'refreshToken')) {
          // will throw error below
          await refreshToken();
          return handler.resolve(await _retry(error.requestOptions));
        }
      }
      return handler.next(error);
    }));
}
  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return api.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<void> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refreshToken');
    final response = await api
        .post('/auth/refresh', data: {'refreshToken': refreshToken});

    if (response.statusCode == 201) {
      // successfully got the new access token
      accessToken = response.data;
    } else {
      // refresh token is wrong so log out user.
      accessToken = null;
      _storage.deleteAll();
    }
  }
}