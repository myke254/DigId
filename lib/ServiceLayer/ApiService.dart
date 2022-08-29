import 'dart:convert';

import 'package:digital_identity_ui/Enums/Enums/ModelEnums.dart';
import 'package:digital_identity_ui/RepoLayer/Models/ConnectionModel.dart';
import 'package:digital_identity_ui/RepoLayer/Models/LocationModel.dart';
import 'package:digital_identity_ui/RepoLayer/Models/PhotosModel.dart';
import 'package:digital_identity_ui/RepoLayer/Models/VoucheeModel.dart';
import 'package:digital_identity_ui/RepoLayer/Models/VoucherModel.dart';
import 'package:http/http.dart';

class ApiService {
  final String apiUrl = "https://ab48-197-232-61-244.eu.ngrok.io/api/";

  Future<List<dynamic>> getAll(String url, ModelEnums type) async {
    Response res = await get(Uri.parse('$apiUrl$url'));

    if (res.statusCode == 200) {
      List<dynamic> body = jsonDecode(res.body);
      List<dynamic> result = [];
      switch (type) {
        case ModelEnums.connectionModel:
          result = body
              .map((dynamic item) => ConnectionModel.fromJson(item))
              .toList();
          break;
        case ModelEnums.locationModel:
          result =
              body.map((dynamic item) => LocationModel.fromJson(item)).toList();
          break;
        case ModelEnums.voucheeModel:
          result =
              body.map((dynamic item) => VoucheeModel.fromJson(item)).toList();
          break;
        case ModelEnums.voucherModel:
          result =
              body.map((dynamic item) => VoucherModel.fromJson(item)).toList();
          break;
        case ModelEnums.photosModel:
          result =
              body.map((dynamic item) => PhotosModel.fromJson(item)).toList();
          break;
        default:
      }
      return result;
    } else {
      throw "Failed to load the list";
    }
  }

  Future<dynamic> getById(String url, String id, ModelEnums type) async {
    final response = await get(Uri.parse('$apiUrl$url/$id'));

    if (response.body.isNotEmpty) {
      var result;
      var body = jsonDecode(response.body);
      switch (type) {
        case ModelEnums.connectionModel:
          result = ConnectionModel.fromJson(body);
          break;
        case ModelEnums.locationModel:
          result = LocationModel.fromJson(body);
          break;
        case ModelEnums.voucheeModel:
          result = VoucheeModel.fromJson(body);
          break;
        case ModelEnums.voucherModel:
          result = VoucherModel.fromJson(body);
          break;
        case ModelEnums.photosModel:
          result = PhotosModel.fromJson(body);
          break;
        default:
      }
      return result;
    } else {
      throw Exception('Failed to load the data');
    }
  }

  Future<bool> create(Map data, String url) async {
    final Response response = await post(
      Uri.parse('$apiUrl$url'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateid(String url, String id, Map data) async {
    final Response response = await put(
      Uri.parse('$apiUrl$url/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteid(String url, String id) async {
    Response res = await delete(Uri.parse('$apiUrl$url/$id'));

    if (res.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
