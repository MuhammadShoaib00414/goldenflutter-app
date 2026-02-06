import 'dart:developer';

import 'package:http/http.dart';

const nameTag = 'BaseService';
const reqTag = ' Request';
const resTag = ' Response';

class Log {
  Log._();

  ///
  /// [request] Log for the base service request
  ///
  static void req(Uri uri, String tag, {dynamic body, dynamic headers}) =>
      _requestLog(uri, tag, body: body, headers: headers);

  ///
  /// [response] Log for the base service response
  ///
  static void res(String api, Response res, String tag) =>
      _responseLog(api, res, tag);

  ///
  /// [exception] Log for the exceptions and errors
  ///
  static void ex(Object e, {dynamic name}) => _exceptionLog(e, name: name);

  ///
  /// [debug] Log for the debug messages
  ///
  static void d(Object? message, {String? name}) => _dLog(message, name: name);

  static void success(Object? message, {String? name}) =>
      _successLog(message, name: name);

  ///
  /// [info] Log for the info messages
  ///
  static void i(Object? message, {String? name}) =>
      log('\n$message\nℹ️ ℹ️ ℹ️\n', name: 'ℹ️ ℹ️ ℹ️ $name ℹ️ ℹ️ ℹ️');

  static void _requestLog(
    Uri uri,
    String tag, {
    dynamic body,
    dynamic headers,
  }) => log(
    '''⏳ ⏳ ⏳
URL==>: $uri  BASE: ${uri.authority}, API: ${uri.path} ,
PARAMS: ${uri.queryParameters}  
BODY: $body
⏳ ⏳ ⏳''',
    // HEADERS: $headers
    // ⏳ ⏳ ⏳''',
    name: tag + reqTag,
  );

  static void _responseLog(String api, Response res, String tag) {
    String emoji = res.statusCode == 200 || res.statusCode == 201
        ? '✅ ✅ ✅'
        : '🚫 🚫 🚫';
    log(name: tag + resTag, '''$emoji
"$api"  STATUS ===>> ${res.statusCode}
RESPONSE  ===>>   ${res.body} 
$emoji''');
  }

  static void _exceptionLog(Object e, {dynamic name}) => log('''🚫 🚫 🚫
${e.toString()}
🚫 🚫 🚫''', name: 'EXCEPTION${name == null ? '' : ' $name'}');

  static void _dLog(Object? message, {String? name}) =>
      log(message.toString(), name: 'DEBUG${name == null ? '' : ' $name'}');

  static void _successLog(Object? message, {String? name}) =>
      log('\n$message\n✅✅✅\n', name: '✅✅✅ $name ✅✅✅');
}
