import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:united_help/services/urls.dart';



class Requests {
  static String? access_token;
  static String? refresh_token;
  static String? username;
  static String? password;

  Map<String, dynamic> refreshing_token(String url) {
    Map response_map = {};
    if (refresh_token==null) {
      return {'success': false, 'error': 'no refresh_token'};
    }
    http.post(
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


  Map<String, dynamic> check_authenticate(String url) {
    Map response_map = {};
    if (url.startsWith(server_url) && !url.endsWith(register_url)) {
      if (access_token==null) {
        http.post(
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

  Map<String, dynamic> get(String url) {
    var auth_resp = check_authenticate(url);
    if (!auth_resp['success']) {
       return {'result': auth_resp['error'], 'result_code': auth_resp['status_code'], };
    }

    var result;
    int status_code = 0;

    http.get(
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
    return {'result': result, 'result_code': status_code, };
  }


  Map<String, dynamic> post(String url, Map body) {
    print('url $url');
    print('body $body');
    var auth_resp = check_authenticate(url);

    if (!auth_resp['success']) {
      return {'result': auth_resp['error'], 'result_code': auth_resp['status_code'], };
    }
    var result;
    int status_code = 0;

    http.post(
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
    return {'result': result, 'result_code': status_code, };
  }


}


