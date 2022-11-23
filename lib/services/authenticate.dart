import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:united_help/services/urls.dart';

typedef FutureMap = Future<Map<String, dynamic>> ;

class Requests {
  static String? access_token;
  static String? refresh_token;
  static String? username;
  static String? password;

  FutureMap refreshing_token(String url) async {
    Map response_map = {};
    if (refresh_token==null) {
      return {'success': false, 'error': 'no refresh_token'};
    }
    await http.post(
      Uri.parse('$server_url$refresh_token_url'),
      body: {"refresh": refresh_token,},
      headers: {"accept": "application/json", },
    ).then((response) {
      response_map = jsonDecode(response.body);
      if (response.statusCode == 200) {
        access_token = response_map['access'];
        return {'success': true};
      }
      else {
        return {
          'success': false,
          'status_code': response.statusCode,
          'error': response.body,
        };
      }
    }).catchError((error){
      print("Error: $error");
      response_map['error'] = error;
      return {
        'success': false,
        'error': error,
        };
      }
    );
    return {'success': true,};
  }

  FutureMap check_authenticate(String url) async {
    Map response_map = {};
    if (url.startsWith(server_url) && !url.endsWith(register_url)) {
      if (access_token==null) {
        await http.post(
            Uri.parse('$server_url$authenticate_url'),
            body: {"username": username,
              "password": password},
            headers: {"accept": "application/json", },
        ).then((response) {
            response_map = jsonDecode(response.body);
            if (response.statusCode == 200) {
              access_token = response_map['access'];
              refresh_token = response_map['refresh'];
              return {'success': true};
            }
            else
              return {
                'success': false,
                'status_code': response.statusCode.toString(),
                'error': response.body,
                    };
        }).catchError((error){
            print("Error: $error");
            response_map['error'] = error;
            return {
              'success': false,
              'error': error,
            };
        });
      }
    }
    return {'success': true,};
  }


  FutureMap get(String url) async {
    var auth_resp = await check_authenticate(url);
    if (!auth_resp['success']) {
       return {'result': auth_resp['error'], 'status_code': auth_resp['status_code'], };
    }

    var result;
    int status_code = 0;

    await http.get(
        Uri.parse(url),
        headers: {"accept": "application/json", 'Content-Type': 'application/json'},
    ).then((response) {
      status_code = response.statusCode;
      result = jsonDecode(response.body);
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }).catchError((error){
      result = error;
      print("Error: $error");
    });
    return {'result': result, 'status_code': status_code, };
  }


  FutureMap post(String url, Map body) async {
    print('url $url');
    print('body $body');
    var auth_resp = await check_authenticate(url);

    if (!auth_resp['success']) {
      return {'result': auth_resp['error'], 'status_code': auth_resp['status_code'], };
    }
    var result;
    int status_code = 0;

    await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {"accept": "application/json", 'Content-Type': 'application/json'},
    ).then((response) {
      status_code = response.statusCode;
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      result = jsonDecode(response.body);
    }).catchError((error){
      result = error;
      print("Error: $error");
    });
    return {'result': result, 'status_code': status_code, };
  }


}


