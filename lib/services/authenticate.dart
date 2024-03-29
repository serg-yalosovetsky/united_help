import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rate_limiter/rate_limiter.dart';
import 'package:united_help/services/urls.dart';

import '../providers/appservice.dart';
import 'debug_print.dart';

typedef FutureMap = Future<Map<String, dynamic>> ;

class Requests {

  FutureMap refreshing_token(String refresh_token, String server_url) async {
    Map<String, dynamic> response_map = {};
    String url = '${server_url}$refresh_token_url/';
    dPrint('url=$url');
    await http.post(
      Uri.parse(url),
      body: json.encode({
        "refresh": refresh_token,
      }),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
      },
    ).then((response) {
      dPrint('response=${response.statusCode}');
      dPrint('response ${response.statusCode==200}');
      response_map = jsonDecode(utf8.decode(response.bodyBytes));
      dPrint('response_map=$response_map');
      if (response.statusCode == 200) {
        response_map = {'success': true,
                'access_token': response_map['access'],};
      }
      else {
        response_map = {
          'success': false,
          'status_code': response.statusCode,
          'error': response.body,
        };
      }
    }).catchError((error){
      dPrint("Type: refreshing_token");

      dPrint("Error: $error");
      response_map['error'] = error;
      response_map = {
        'success': false,
        'error': error,
        };
      }
    );
    return response_map;
  }

  FutureMap authenticate(String username, String password, String server_url) async {
    Map<String, dynamic> response_map = {'success': false,};
    await http.post(
        Uri.parse('$server_url$authenticate_url/'),
        body: json.encode({"username": username, "password": password}),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
        },
    ).then((response) async {

      response_map = jsonDecode(response.body);
      response_map = jsonDecode(utf8.decode(response.bodyBytes));
      dPrint('response_map = $response_map');
      dPrint('response.statusCode = ${response.statusCode}');
        if (response.statusCode == 200) {
          response_map = {
            'success': true,
            'access_token': response_map['access'],
            'refresh_token': response_map['refresh'],
          };
        }
        else {
          response_map = {
          'success': false,
          'status_code': response.statusCode,
          'error': response.body,
              };
        }
    }).catchError((error) async{
      dPrint("Type: check_authenticate");
      dPrint("Error: $error");
      response_map['error'] = error;
      response_map = {
            'success': false,
            'error': error,
            };

    });
    return response_map;
  }


  FutureMap get(String url, [String? access_token]) async {
    var result;
    int status_code = 0;
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    };
    if (access_token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $access_token';
    }
    // if (!url.substring(url.length - 1).contains(RegExp(r'[0-9]'))){
    //   if (!url.endsWith('/')) url += '/';
    // }
    await http.get(
      Uri.parse(url),
      headers: headers,
    ).then((response) {
      status_code = response.statusCode;
      dPrint("Response status: ${response.statusCode}");
      dPrint("Response body: ${response.body}");
      result = jsonDecode(utf8.decode(response.bodyBytes));
    }).catchError((error){
      result = error;
      dPrint("Method: GET");

      dPrint("Error: $error");
      dPrint("Url: $url");
      dPrint("Headers: $headers");
    });
    return {'result': result, 'status_code': status_code, };
  }

  // FutureMap get(String url, [String? access_token]) async {
  //   // var auth_resp = await authenticate(url, access_token);
  //   // if (!auth_resp['success']) {
  //   //    return {'result': auth_resp['error'], 'status_code': auth_resp['status_code'], };
  //   // }
  //   return clear_get(url, access_token);
  // }

  // FutureMap get_wrapper = throttle((String url, AppService app_service) async {
  //   String? access_token = await app_service.get_access_token();
  //   dPrint('access_token = $access_token');
  //   var r = await get(url, access_token);
  //   dPrint(r);
  //   if (r == null || r['status_code'] == 403){
  //     app_service.set_access_token(null);
  //     return get(url, await app_service.get_access_token());
  //   }
  //   return r;
  // }, const Duration(seconds: 2)) as FutureMap;

  FutureMap get_wrapper(String url, AppService app_service) async {
    String? access_token = await app_service.get_access_token();
    dPrint('access_token = $access_token');
    var r = await get(url, access_token);
    dPrint(r);
    if (r == null || r['status_code'] == 403){
      app_service.set_access_token(null);
      return get(url, await app_service.get_access_token());
    }
    return r;
  }


  FutureMap post_wrapper(String url, Map body, AppService app_service) async {
    var r = await post(url, body, await app_service.get_access_token());
    if (r == null || r['status_code'] == 403){
      app_service.set_access_token(null);

      return post(url, body, await app_service.get_access_token());
    }
    return r;
  }

  FutureMap patch_wrapper(String url, Map body, AppService app_service) async {
    var r = await patch(url, body, await app_service.get_access_token());
    if (r == null || r['status_code'] == 403){
      // await app_service.relogin();
      app_service.set_access_token(null);

      return post(url, body, await app_service.get_access_token());
    }
    return r;
  }


  FutureMap file_wrapper(String url, Map<String, String> body, AppService app_service,
      {String method = 'patch'}) async {
    var r = await image_send(
                url,
                body['image']!,
                body: body,
                method: 'post',
                access_token: await app_service.get_access_token(),
    );
    if (r['status_code'] == 403){
      await app_service.relogin();
      return await image_send(
                url,
                body['image']!,
                body: body,
                method: 'post',
                access_token: await app_service.get_access_token(),
      );
    }
    return r;
  }


  FutureMap post(String url, Map body, [String? access_token]) async {
    var result;
    int status_code = 0;

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    };
    if (access_token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $access_token';
    }
    await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: headers,
    ).then((response) {
      status_code = response.statusCode;
      dPrint(status_code);
      dPrint(response.body);
      dPrint(utf8.decode(response.bodyBytes));
      result = jsonDecode(utf8.decode(response.bodyBytes));
    }).catchError((error){
      result = error;
      dPrint("Type: post");
      dPrint("Error: $error");
    });
    return {'result': result, 'status_code': status_code, };
  }


  FutureMap patch(String url, Map body, [String? access_token]) async {
    var result;
    int status_code = 0;

    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    };
    if (access_token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $access_token';
    }
    // if (!url.substring(url.length - 1).contains(RegExp(r'[0-9]')) && !url.endsWith('/')){
    //   url += '/';
    // }
    await http.patch(
      Uri.parse(url),
      body: json.encode(body),
      headers: headers,
    ).then((response) {
      status_code = response.statusCode;
      // dPrint("Response status: ${response.statusCode}");
      // dPrint("Response body: ${response.body}");
      result = jsonDecode(utf8.decode(response.bodyBytes));
    }).catchError((error){
      result = error;
      dPrint("Type: post");
      dPrint("Error: $error");
    });
    return {'result': result, 'status_code': status_code, };
  }

  FutureMap image_send(String url, String image_path,
                  {Map<String, String>? body, String? access_token, String? image_name, String? method}) async {
    // if (!url.substring(url.length - 1).contains(RegExp(r'[0-9]')) && !url.endsWith('/')){
    //   url += '/';
    // }

    method ??= 'patch';
    var request =  http.MultipartRequest(
        method.toUpperCase(),
        Uri.parse(url),
    );
    request.headers['Authorization'] = 'Bearer ${access_token}';
    request.files.add(await http.MultipartFile.fromPath(
        'image',
        image_path,
        filename: image_name,
    ));
    body?.remove('image');
    body?.forEach((key, value) {request.fields[key] = value;});
    var response = await request.send();
    final res = await http.Response.fromStream(response);
    dPrint('res= ${res.body} ');
    dPrint(res.body);
    dPrint('res= ${res.statusCode} ');
    dPrint('res=  ${res.reasonPhrase}');
    return {'result': res.body, 'status_code': response.statusCode, };
  }


}


