import 'package:dio/dio.dart';
import 'package:recetario_utez/datos/bitacora_interceptor.dart';

const urlDummyJson = 'https://dummyjson.com';

Dio crearDioRecetas({List<Interceptor> interceptores = const []}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: urlDummyJson,
      connectTimeout: const Duration(seconds: 1),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.add(BitacoraInterceptor());
  dio.interceptors.addAll(interceptores);
  return dio;
}
