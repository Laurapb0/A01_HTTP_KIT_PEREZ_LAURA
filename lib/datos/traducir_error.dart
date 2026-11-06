import 'package:dio/dio.dart';
import 'package:recetario_utez/dominio/falla_red.dart';

FallaRed traducirError(DioException e) {
  return switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout => const TiempoAgotado(),
    DioExceptionType.badResponse => _porCodigo(e.response?.statusCode ?? 0),
    DioExceptionType.unknown when e.error is FormatException =>
      const RespuestaInvalida(),
    DioExceptionType.badCertificate ||
    DioExceptionType.cancel ||
    DioExceptionType.connectionError ||
    DioExceptionType.unknown => const SinConexion(),
  };
}

FallaRed _porCodigo(int codigo) {
  if (codigo >= 500) return ErrorDelServidor(codigo);
  return PeticionRechazada(codigo);
}
