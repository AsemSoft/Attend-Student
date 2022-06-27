import 'package:dio/dio.dart';

class HttpError implements Exception {
  final DioError internalError;

  String get message => _getMessage();

  HttpError(this.internalError);

  String _getMessage() {
    switch (internalError.type) {
      case DioErrorType.connectTimeout:
        return 'connection timeout';
      case DioErrorType.sendTimeout:
        return 'send timeout';
      case DioErrorType.receiveTimeout:
        return 'receive timeout';
      case DioErrorType.cancel:
        return 'operation canceled';
      case DioErrorType.other:
        return 'unexpected error occured';
      case DioErrorType.response:
        if (internalError.response == null) {
          return 'an error occured';
        }

        final data = internalError.response!.data;

        if (data is Map<String, dynamic> && data.containsKey('message')) {
          return data['message'];
        }

        return internalError.response!.statusMessage ??
            'an unkown error occured';
    }
  }
}
