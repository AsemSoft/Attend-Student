import 'package:attend/models/session_user.dart';
import 'package:attend/services/http_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HttpContext {
  // create instance
  final _http = Dio();

  /*
  Flutter Secure Storage provides API to store data
  in secure storage. Keychain is used in iOS,
  KeyStore based solution is used in Android.
  هذه الداله عملها انها تقوم بخزن البيانات القادمه من السيرفر لماذا نقوم بمثل هذا الشي
  في حال انه التطبيق كان متصل بالنت وفجأ فصل النت من مسؤول عن تخزين هذه البيانات وعرضها في التطبيق
  هذه الويجت مسؤوله على هذا الشي وفيها مجوعه من الدوال التي تقوم بحفظ وقراءه هذه البينات او حذفها.
  */
  final _storage = const FlutterSecureStorage();

  String? _token;

  final String baseUrl;
  // dio.options.baseUrl = 'https://www.xx.com/api';


  // constactor
  HttpContext(this.baseUrl) {
   /* Dio instance may have interceptor(s) by which you can
    intercept requests/responses/errors
    before they are handled by then or catchError.*/
    /*
    عملية الاتصال مع مكتبه دو امر ممتاز وهي التي ستعمل على مراسله اي بي اي
    لكن في حال لم يوجد اتصال مع هذا الايبي ستحدث مشاكل اثناء الاتصال
    بستطاعتها ان نعمل مثل ما يعمل كروم عندما لا يوجد نت يقوم بطباعه ديناصور او ارسال رساله
    لكن لا يعقل ان يقوم السمتخدم بإعاده تشغيل التطبيق كل مره ليتحقق من انه التطبيق عاد للاتصال بالنت او لا
    لهذا يتوجب علينا اخذ زمام المبادره والتحقق وعملية اعاده الطلب اولا باول الى حين عوده النت تشغل الامور طبيعي دون اي مشكله
    */
    _http.interceptors.add(
      InterceptorsWrapper(
        /*  If you want to easily allows add the access_token to the request
          I suggest adding the following function when you declare your dio router
          with the onError callback:*/
        onRequest: (o, h) {
            o.path = '$baseUrl${o.path}';

          if (_token != null) {
            o.headers['Authorization'] = 'Bearer $_token';
          }

          return h.next(o);
        },

        onError: (e, h) async {
          try {
            if (e.response?.statusCode == 401 && _token != null) {
              if (JwtDecoder.isExpired(_token!) &&
                  await _storage.containsKey(key: 'creds')) {
                await _refreshToken();
                return h.resolve(await _retry(e.requestOptions));
              }
            }
          } catch (_) {}

          return h.next(e);
        },
      ),
    );
  }

  Future<SessionUser?> authenticate(String username, String password) async {
    try {
      final res = await _http.post(
        '/api/auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      if (res.statusCode == 200 && res.data != null) {
        _token = res.data;
        await _storage.write(key: 'creds', value: '$username:$password');
        return SessionUser.fromToken(_token!);
      }

      return null;
    } on DioError catch (ex) {
      throw HttpError(ex);
    }
  }

  Future<void> eraseAuthCreds() async {
    if (await _storage.containsKey(key: 'creds')) {
      _storage.delete(key: 'creds');
    }
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return (await _http.get(path, queryParameters: queryParameters)).data;
    } on DioError catch (ex) {
      throw HttpError(ex);
    }
  }
  // الداله بوست ترسل الى API
  Future<dynamic> post(
    String path,
    dynamic data, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final res = await _http.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return res.data;
    } on DioError catch (ex) {
      throw HttpError(ex);
    }
  }

  Future<dynamic> put(String path, dynamic data,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final res = await _http.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );

      return res.data;
    } on DioError catch (ex) {
      throw HttpError(ex);
    }
  }
  // داله الحذف
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      // علشان ارسل الحذف معي داله في مكتبه dio تطلب عملية الحذف من api
      return (await _http.delete(path, queryParameters: queryParameters)).data;
    } on DioError catch (ex) {
      throw HttpError(ex);
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions reqOpts) async {
    final opts = Options(method: reqOpts.method, headers: reqOpts.headers);

    return _http.request<dynamic>(
      reqOpts.path,
      data: reqOpts.data,
      queryParameters: reqOpts.queryParameters,
      options: opts,
    );
  }

  Future<bool> _refreshToken() async {
    final creds = await _storage.read(key: 'creds');

    if (creds == null) {
      throw Exception('creds not stored');
    }

    final credsParts = creds.split(':');

    if (credsParts.length != 2) {
      throw Exception('invalid stored creds');
    }

    return await authenticate(credsParts[0], credsParts[1]) != null;
  }
}
