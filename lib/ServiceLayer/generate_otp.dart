import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:digital_identity_ui/RepoLayer/Models/OtpRequestModel.dart';
import 'package:digital_identity_ui/RepoLayer/Models/OtpResponseModel.dart';
import 'package:dio/dio.dart';
import 'package:http/retry.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Otp {
  int count = 0;

  Future<OtpResponseModel?> getOtp() async {
    String token = "";
    var rand = Random();
    String ref = "";
    for (var i = 0; i < 12; i++) {
      ref += rand.nextInt(9).toString();
    }
    print(ref);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String phoneNumber = "254" +
        jsonDecode(preferences.getString('voucher')!)['phone']
            .toString()
            .substring(1);
    print(phoneNumber);
    print(token);
    Map<String, dynamic> data = {
      "reference": ref,
      "to": phoneNumber,
      "platform": 1,
      "operation": "onboarding",
      "source": "chatbot",
      "noofDigit": 6,
      "customerId": "0178194299581"
    };

    Dio dio = await Dio();
    final response = await dio.post(
        'https://api-omnichannel-uat.azure-api.net/v1/otp',
        data: data,
        options: Options(
            contentType: 'application/json',
            headers: {"Authorization": "Bearer $token"}));

    if (response.statusCode == 200) {
      return OtpResponseModel.fromJson(response.data);
    } else if (response.statusCode == 401) {
      //refresh token and call getUser again
      final response = await dio.post(
          'https://api-omnichannel-uat.azure-api.net/v2.1/oauth/token',
          data: {
            "clientId": "0EFAA8678A77460",
            "clientSecret": "MUZCNkM0N0QtNjdGQy00Mzc4LTk0QjktOENGNkMxNTMwMjBE",
            "appName": "InternTest"
          }
        //'client_secret=MUZCNkM0N0QtNjdGQy00Mzc4LTk0QjktOENGNkMxNTMwMjBE&client_id=0EFAA8678A77460&grant_type=client_credentials'
      );
      print(response.data);

      token = jsonDecode(response.data)['access_token'];
      return getOtp();
    } else {
      return null;
    }
  }

  Future<OtpResponseModel> getOtp1(String token) async {
    OtpResponseModel otpResponseModel = OtpResponseModel();

    final client = RetryClient(
      http.Client(),
      retries: 3,
      when: (response) {
        return response.statusCode == 401;
      },
      onRetry: (req, res, retryCount) async {
        if (retryCount == 0 && res?.statusCode == 401) {
          // refresh token
          final response = await http.post(
              Uri.parse(
                  'https://api-omnichannel-uat.azure-api.net/v2.1/oauth/token'),
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              body: {
                'client_secret':
                'MUZCNkM0N0QtNjdGQy00Mzc4LTk0QjktOENGNkMxNTMwMjBE',
                'client_id': '0EFAA8678A77460',
                'grant_type': 'client_credentials'
              });
          token = jsonDecode(response.body)['access_token'];
        }
      },
    );

    try {
      var rand = Random();
      String ref = "";
      for (var i = 0; i < 12; i++) {
        ref += rand.nextInt(9).toString();
      }
      print(ref);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String phoneNumber = "254" +
          jsonDecode(preferences.getString('voucher')!)['phone']
              .toString()
              .substring(1);
      print(phoneNumber);
      print(token);
      Map<String, dynamic> data = {
        "reference": ref,
        "to": "254745476040",//phoneNumber,
        "platform": 1,
        "operation": "onboarding",
        "source": "chatbot",
        "noofDigit": 6,
        "customerId": "0178194299581"
      };
      final response = await client.post(
        Uri.parse('https://api-omnichannel-uat.azure-api.net/v1/otp'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(data),
      );
      print(response.statusCode);
      otpResponseModel = OtpResponseModel.fromJson(jsonDecode(response.body));
      if(response.statusCode==401){
       await getToken().then((tkn) => getOtp1(tkn));
        return otpResponseModel;
      }else{
      // ;
      return otpResponseModel;
      }
    } finally {
      client.close();
    }
  }
  Future<OtpResponseModel> fetchAlbum() async {
    var rand = Random();
    String ref = "";
    String token = "";
    for (var i = 0; i < 12; i++) {
      ref+=rand.nextInt(9).toString();
    }
    print(ref);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String phoneNumber ="254"+jsonDecode(preferences.getString('voucher')!)['phone'].toString().substring(1);
    print(phoneNumber);
    Map<String,dynamic> data = {
      "reference": ref,
      "to": phoneNumber,
      "platform": 1,
      "operation": "onboarding",
      "source": "chatbot",
      "noofDigit": 6,
      "customerId": "0178194299581"
    };
    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/albums/1'),
      // Send authorization headers to the backend.
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IkU3OTg0RTdGMENGRjEzQUU2OTBBRjJBNEYzODA1MEJCRkUwQTZDNDEiLCJ0eXAiOiJKV1QifQ.eyJzdWIiOiIwRUZBQTg2NzhBNzc0NjAiLCJjbGllbnRUeXBlIjoiU2VydmVyIiwic291cmNlIjoiRXF1aXR5Q29ubmVjdCIsImNsaWVudF9pZCI6IjBFRkFBODY3OEE3NzQ2MCIsImNoYW5uZWwiOiJJbnRlcm5UZXN0IiwidG9rZW5fdXNhZ2UiOiJhY2Nlc3NfdG9rZW4iLCJqdGkiOiIwZWE5OWI2My0xNzk4LTQ1ZDctYWUyYi1iYjFiMjdkMDcyNjgiLCJjZmRfbHZsIjoicHJpdmF0ZSIsInNjb3BlIjoib2ZmbGluZV9hY2Nlc3MiLCJhdWQiOlsibm90aWZpY2F0aW9ucyIsImFjY291bnRzIl0sImF6cCI6IjBFRkFBODY3OEE3NzQ2MCIsIm5iZiI6MTY2MTc2MTg4NCwiZXhwIjoxNjYxNzY1NDg0LCJpYXQiOjE2NjE3NjE4ODQsImlzcyI6Imh0dHBzOi8vYXBpLW9tbmljaGFubmVsLXVhdC5henVyZS1hcGkubmV0L3YxL2lzc3VlciJ9.sjKbwPrOkWhxQVHG1hlAjeYx4ZcOZ1NFS3VNaGhnYHoB_ko4yNuEvDckjheKAckRgL3LrF5P-RDcAuOiRGQb0Asa8PRkDD1zYgfBTNKp3_FobD15LYf99a9GEkFMPZ22F6WHVKKmwyBWMIM3hFwKojHnaJXBeDqICNJoJylNZhc088CpPtrWwh8YQSyKng_mQ7lY563REBr743NpB3yF_blh5wJ99VUKhLPCYe9h6PdZDhx6dqMsV1Ij-9roTaXu0ZRAZQ9FSJGiv7dDnaMtrl4usv1dlhr6iPHae_gsjaDgGl6hCsjJRt-TcG_thGFaDdBuji8oxweiMOL9m1XtYg',
      },
      body: data
    );
    final responseJson = jsonDecode(response.body);
    print(responseJson);
    return OtpResponseModel.fromJson(responseJson);
  }

Future<String> getToken()async{
  var token = "";
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Dio dio = await Dio();
  var response = await dio.post('https://api-omnichannel-uat.azure-api.net/v2.1/oauth/token',
      options: Options(
        contentType: 'application/x-www-form-urlencoded'
      ),
      data: {'client_secret':'MUZCNkM0N0QtNjdGQy00Mzc4LTk0QjktOENGNkMxNTMwMjBE','client_id':'0EFAA8678A77460','grant_type':'client_credentials'});

   token = response.data['access_token'];
   sharedPreferences.setString('token', token);
  print(token);
  return token;

}
}
