import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:goldexia_fx/models/file.dart' as f;
import 'package:goldexia_fx/models/user.dart';
import 'package:http/http.dart' as http;

import '../utils/res/app_urls.dart';
import '../utils/utils.dart';
import 'app_exceptions.dart';
import 'local_db/user_session.dart';

class BaseService {
  final int _apiTimeOut = 25;

Future<Map<String, String>> _getHeaders() async {
  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // final user = await UserSession.getUser();
  final user = UserSession.currentUser;
  if (user?.accessToken != null) {
    headers['Authorization'] = 'Bearer ${user!.accessToken}';
  }

  return headers;
}


//  Future< Map<String, String>> _getHeaders() async {
//     final headers = <String, String>{
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };

//     if (UserSession.currentUser?.accessToken != null) {
//       headers['Authorization'] =
//           'Bearer ${UserSession.currentUser!.accessToken}';
//     }

//     return headers;
//   }

  @protected
  Future<dynamic> get(
    String api, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    String baseUrl = AppUrls.base,
  }) async {
    Uri? uri;
    headers = headers ??await _getHeaders();
    try {
      uri = Uri.parse(baseUrl + api);
      uri = uri.replace(queryParameters: queryParams);
      Log.req(uri, 'GET', headers: headers);
      var response = await http
          .get(uri, headers: headers)
          .timeout(Duration(seconds: _apiTimeOut));
      Log.res(api, response, 'GET');
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        message: 'No Internet Connection',
        url: uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        message: 'Api Not Responded in Time',
        url: uri.toString(),
      );
    }
    // catch (e) {
    //   Log.ex(e.toString(),name: 'GET on BASE');
    // }
  }

  @protected
  Future<dynamic> post(
    String api,
    payLoadObj, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    String baseUrl = AppUrls.base,
  }) async {
    Uri uri = Uri.parse(baseUrl + api);
    uri = uri.replace(queryParameters: queryParams);
    headers = headers ??await _getHeaders();
    Log.req(uri, 'POST', body: payLoadObj, headers: headers);
    try {
      var response = await http
          .post(uri, body: json.encode(payLoadObj), headers: headers)
          .timeout(Duration(seconds: _apiTimeOut));
      Log.res(api, response, 'POST');
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        message: 'No Internet Connection',
        url: uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        message: 'Api Not Responded in Time',
        url: uri.toString(),
      );
    }
    // catch (e) {
    //   Log.ex(e.toString(), name: 'POST on BASE');
    // }
  }

  @protected
  Future<dynamic> put(
    String api, {
    payLoadObj,
    Map<String, String> header = const {
      'Accept': '*/*',
      'Content-Type': 'application/json',
    },
    String baseUrl = AppUrls.base,
  }) async {
    var uri = Uri.https(baseUrl, api);

    Log.req(uri, 'PUT', body: payLoadObj);
    try {
      var response = await http
          .put(uri, headers: header, body: jsonEncode(payLoadObj))
          .timeout(Duration(seconds: _apiTimeOut));
      Log.res(api, response, 'PUT');
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        message: 'No Internet Connection',
        url: uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        message: 'Api Not Responded in Time',
        url: uri.toString(),
      );
    }
    // catch (e) {
    //   Log.ex(e.toString(), name: 'PUT on BASE');
    // }
  }

  @protected
  Future<dynamic> delete(
    String api, {
    payLoadObj,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    String baseUrl = AppUrls.base,
  }) async {
    var uri = Uri.https(baseUrl, api, queryParams);
    headers = headers ??await _getHeaders();

    Log.req(uri, 'DELETE');
    try {
      var response = await http
          .delete(uri, headers: headers, body: jsonEncode(payLoadObj))
          .timeout(Duration(seconds: _apiTimeOut));
      Log.res(api, response, 'DELETE');
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        message: 'No Internet Connection',
        url: uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        message: 'Api Not Responded in Time',
        url: uri.toString(),
      );
    }
    //  catch (e) {
    //   Log.ex(e.toString(), name: 'DELETE on BASE');
    // }
  }

  @protected
  Future<dynamic> patchWithFile(
    String api, {
    Map<String, dynamic>? payLoadObj,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    String baseUrl = AppUrls.base,
    String? filePath, // File path for image
    String fileField = 'logo', // Default field name for the file
  }) async {
    Uri uri = Uri.parse(baseUrl + api);
    uri = uri.replace(queryParameters: queryParams);
    headers = headers ??await _getHeaders();
    Log.req(uri, 'PATCH', body: payLoadObj);

    try {
      var request = http.MultipartRequest('PATCH', uri);
      request.headers.addAll(headers);
      if (payLoadObj != null) {
        payLoadObj.forEach((key, value) {
          if (value != null) {
            request.fields[key] = value.toString();
          }
        });
      }

      if (filePath != null && filePath.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath(fileField, filePath),
        );
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      Log.res(api, response, 'PATCH');
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        message: 'No Internet Connection',
        url: uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        message: 'API Not Responded in Time',
        url: uri.toString(),
      );
    } catch (e) {
      // Handle other exceptions here
      throw Exception('Unexpected error: $e');
    }
  }

  @protected
  Future<dynamic> patch(
    String api, {
    payLoadObj,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
    String baseUrl = AppUrls.base,
  }) async {
    Uri uri = Uri.parse(baseUrl + api);
    uri = uri.replace(queryParameters: queryParams);
    headers = headers ??await _getHeaders();
    Log.req(uri, 'PATCH', body: payLoadObj);
    try {
      var response = await http
          .patch(uri, headers: headers, body: jsonEncode(payLoadObj))
          .timeout(Duration(seconds: _apiTimeOut));
      Log.res(api, response, 'PATCH');
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        message: 'No Internet Connection',
        url: uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        message: 'Api Not Responded in Time',
        url: uri.toString(),
      );
    } catch (e) {
      // Handle other exceptions here
    }
  }

  @protected
  Future<dynamic> uploadFile(
    String api,
    List<f.File> files, {
    Map<String, String>? fields,
    String baseUrl = AppUrls.base,
  }) async {
    var uri = Uri.parse('$baseUrl$api');

    var headers = _getHeaders();

    var request = http.MultipartRequest('POST', uri);
    if (fields != null) {
      request.fields.addAll(fields);
    }
    for (f.File file in files) {
      Log.req(
        uri,
        'POST File path ${file.key} : ${file.path}  fields::>> $fields',
      );
      var multipartFile = await http.MultipartFile.fromPath(
        file.key,
        file.path,
      );
      request.files.add(multipartFile);
    }

    request.headers.addAll(await headers);

    try {
      var response = await request.send();
      final resBody = await response.stream.bytesToString();
      Log.d(
        ' response "$resBody" with ${response.statusCode} ',
        name: 'File Upload Response',
      );
      return _processResponse(http.Response(resBody, response.statusCode));
    } on SocketException {
      throw FetchDataException(
        message: 'No Internet Connection',
        url: uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        message: 'Api Not Responded in Time',
        url: uri.toString(),
      );
    } catch (e) {
      // Handle other exceptions here
      // Log.ex('  $e.', name: 'Exeption: File Upload Response Failure');
    }
  }

  Future<dynamic> getFile(String api, {String baseUrl = AppUrls.base}) async {
    var uri = Uri.https(baseUrl, api);
    Log.req(uri, 'GET');
    try {
      var response = await http
          .get(uri, headers:await _getHeaders())
          .timeout(Duration(seconds: _apiTimeOut));
      Log.d(
        ' $api ===>>  statusCode: ${response.statusCode}',
        name: 'GET IMAGE',
      );
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        return _processResponse(response);
      }
    } on SocketException {
      throw FetchDataException(
        message: 'No Internet Connection',
        url: uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        message: 'API Not Responded in Time',
        url: uri.toString(),
      );
    } catch (e) {
      // Log.ex(e.toString());
      // rethrow;
    }
  }

  dynamic _processResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        try {
          if (response.body.toString().isEmpty) return true;
          var responseJson = json.decode(response.body);
          return responseJson;
        } catch (e) {
          return 'success 200';
        }
      case 201:
        try {
          if (response.body.toString().isEmpty) return true;
          var responseJson = json.decode(response.body);
          return responseJson;
        } catch (e) {
          return 'success 201';
        }
      case 400:
        throw BadRequestException(
          message: response.body,
          url: response.request?.url.toString(),
        );
      case 401:
        {
          if (response.request!.url.toString().contains(AppUrls.login)) {
            throw UnAutthorizedException(
              message: response.body,
              url: response.request!.url.toString(),
            );
          }
          debugPrint('{SESSION DEBUG} ${DateTime.now()} before refresh token');
          if (await _refreshToken()) {
            debugPrint(
              '{SESSION DEBUG} ${DateTime.now()}  refresh token sucess and doing retry request ${response.request}',
            );
            return await _retryRequest(response.request!);
          } else {
            debugPrint(
              '{SESSION DEBUG} ${DateTime.now()}  throw unauthrosized ${response.request?.url}',
            );
            throw UnAutthorizedException(
              message: response.body,
              url: response.request!.url.toString(),
            );
          }
        }
      case 403:
      case 404:
        throw BadRequestException(
          message:
              json.decode(response.body)['message'] ?? response.body.toString(),
          url: response.request?.url.toString(),
        );

      case 409:
      case 422:
        throw UnProcessableException(
          message: response.body,
          url: response.request?.url.toString(),
        );
      case 500:
      default:
        throw FetchDataException(
          message: 'Something went wrong Internal Server Error (500)',
          url: response.request!.url.toString(),
        );
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final url = Uri.parse(AppUrls.base + AppUrls.refreshLogin);
      final body = jsonEncode({
        'refreshToken': UserSession.currentUser?.refreshToken,
      });
      Log.req(url, 'ⓘ refreshToken ⓘ', body: body, headers:await _getHeaders());
      final response = await http.post(url, body: body, headers:await _getHeaders());
      Log.res('ⓘ refreshToken ⓘ', response, 'Refreshing Token');
      if (response.statusCode != 200) return false;
      // final newUser = User.fromMap(jsonDecode(response.body));
      // await UserSession.saveUser(
      //   newUser.copyWith(
      //     selectedDevice: UserSession.currentUser?.selectedDevice,
      //     code: UserSession.currentUser?.code,
      //     logoPath: UserSession.currentUser?.logoPath,
      //   ),
      // );
       final newUser = User.fromJson(response.body);
    await UserSession.saveUser(newUser); // ✅ save new token
   
      return true;
    } catch (e) {
      Log.ex(e.toString(), name: 'base refreshLogin');
      return false;
    }
  }

  dynamic _retryRequest(http.BaseRequest request) async {
    try {
      Log.d(
        '{SESSION DEBUG} message ${request.url}, ${request.method} ${request.headers}',
        name: 'retryRequest',
      );
      // Get the new token from the session
      String newToken = UserSession.currentUser?.accessToken ?? '';

      // Create a new request with the updated Authorization header
      var uri = request.url;
      var newRequest = http.Request(request.method, uri)
        ..headers.addAll(request.headers)
        ..headers['Authorization'] = 'Bearer $newToken';

      // Use http.Client to send the request again
      var client = http.Client();
      var response = await client.send(newRequest);
      var resBody = await response.stream.bytesToString();
      client.close();
      Log.d(
        resBody,
        name: '{SESSION DEBUG} retryRequest ${response.statusCode}',
      );
      if (response.statusCode == 401) {
        throw UnAutthorizedException(
          message: resBody,
          url: request.url.toString(),
        );
      }
      return _processResponse(http.Response(resBody, response.statusCode));
    } catch (e) {
      Log.ex(e.toString(), name: '{SESSION DEBUG} retryRequest');
    }
  }
}
