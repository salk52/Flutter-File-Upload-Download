import 'package:dio/dio.dart';
import 'package:openapi/openapi.dart';

/// Creates instance of [Dio] to be used in the remote layer of the app.
Dio createDio(BaseOptions baseConfiguration) {
  var dio = Dio(baseConfiguration);
  dio.interceptors.addAll([
    // interceptor to retry failed requests
    // interceptor to add bearer token to requests
    // interceptor to refresh access tokens
    // interceptor to log requests/responses
    // etc.
  ]);

  return dio;
}

/// Creates Dio Options for initializing a Dio client.
///
/// [baseUrl] Base url for the configuration
/// [connectionTimeout] Timeout when sending data
/// [connectionReadTimeout] Timeout when receiving data
BaseOptions createDioOptions(String baseUrl, Duration connectionTimeout, Duration connectionReadTimeout) {
  return BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectionTimeout,
      receiveTimeout: connectionReadTimeout,
      receiveDataWhenStatusError: true);
}

/// Creates an instance of the backend API with default options.
Openapi createMyApi() {
  const baseUrl = 'http://192.168.0.15:45455';
  final options = createDioOptions(baseUrl, const Duration(seconds: 60), const Duration(seconds: 60));
  final dio = createDio(options);
  return Openapi(dio: dio);
}
