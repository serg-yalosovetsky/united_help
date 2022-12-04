import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:united_help/services/urls.dart';

import 'appservice.dart';

typedef FutureMap = Future<Map<String, dynamic>> ;

class Requests {

  FutureMap refreshing_token(String refresh_token) async {
    Map response_map = {};

    await http.post(
      Uri.parse('$server_url$refresh_token_url/'),
      body: json.encode({
        "refresh": refresh_token,
      }),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
        HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
      },
    ).then((response) {
      response_map = jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200) {
        return {'success': true,
                'access_token': response_map['access'],};
      }
      else {
        return {
          'success': false,
          'status_code': response.statusCode,
          'error': response.body,
        };
      }
    }).catchError((error){
      print("Type: refreshing_token");

      print("Error: $error");
      response_map['error'] = error;
      return {
        'success': false,
        'error': error,
        };
      }
    );
    return {'success': false,};
  }

  FutureMap authenticate(String username, String password) async {
    Map response_map = {};
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
        if (response.statusCode == 200) {
          print(response_map);

          return {
            'success': true,
            'access_token': response_map['access'],
            'refresh_token': response_map['refresh'],
          };
        }
        return {
          'success': false,
          'status_code': response.statusCode,
          'error': response.body,
              };
    }).catchError((error) async{
      print("Type: check_authenticate");

      print("Error: $error");
      response_map['error'] = error;
      return {
            'success': false,
            'error': error,
            };

    });
    if (response_map['access'].toString().isNotEmpty &&
        response_map['refresh'].toString().isNotEmpty ) {
        return {
        'success': true,
        'access_token': response_map['access'],
        'refresh_token': response_map['refresh'],
        };
    }

    return {'success': false,};
  }


  FutureMap clear_get(String url, [String? access_token]) async {
    var result;
    int status_code = 0;
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    };
    if (access_token != null) {
      headers[HttpHeaders.authorizationHeader] = 'Bearer $access_token';
    }
    if (!url.substring(url.length - 1).contains(RegExp(r'[0-9]')) && !url.endsWith('/')){
      url += '/';
    }
    await http.get(
      Uri.parse(url),
      headers: headers,
    ).then((response) {
      status_code = response.statusCode;
      result = jsonDecode(utf8.decode(response.bodyBytes));
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }).catchError((error){
      result = error;
      print("Type: get");

      print("Error: $error");
    });
    return {'result': result, 'status_code': status_code, };
  }

  FutureMap get(String url, [String? access_token]) async {
    // var auth_resp = await authenticate(url, access_token);
    // if (!auth_resp['success']) {
    //    return {'result': auth_resp['error'], 'status_code': auth_resp['status_code'], };
    // }
    return clear_get(url, access_token);
  }


  FutureMap get_wrapper(String url, [String? access_token]) async {
    if (access_token == null){
      var result = await authenticate('serg', 'sergey104781');
      if (result['success']){
        access_token = result['access_token'];
      }
    }
    return get(url, access_token);
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
    if (!url.endsWith('/')){
      url += '/';
    }
    await http.post(
      Uri.parse(url),
      body: json.encode(body),
      headers: headers,
    ).then((response) {
      status_code = response.statusCode;
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      result = jsonDecode(utf8.decode(response.bodyBytes));
    }).catchError((error){
      result = error;
      print("Type: post");
      print("Error: $error");
    });
    return {'result': result, 'status_code': status_code, };
  }

  FutureMap wrapper_post(String url, Map body, [String? access_token]) async {
    // print('url $url');
    // print('body $body');
    // var auth_resp = await authenticate(url, access_token);
    //
    // if (!auth_resp['success']) {
    //   return {'result': auth_resp['error'], 'status_code': auth_resp['status_code'], };
    // }
    return post(url, body, access_token);
  }


}


