import 'package:dio/dio.dart';

class HttpClientUtil {
  String? baseUrl;
  String? endpoint;

  HttpClientUtil({this.baseUrl, this.endpoint});
  Dio dio = Dio();
  
  Future<List<T>> getListAsync<T>(
      T Function(Map<String, dynamic> json) fromJson) async {
    try {
      Response response = await dio.get("$baseUrl/$endpoint");
      if (response.statusCode == 200) {
        List<T> res = [];
        for (var x in response.data) {
          res.add(fromJson(x));
        }
        return res;
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

    Future<T> getAsync<T>(
      T Function(Map<String, dynamic> json) fromJson,String id) async {
  
      Response response = await dio.get("$baseUrl/$endpoint/$id");
      if (response.statusCode == 200) {
       
        return fromJson(response.data);
      }
      return fromJson({});
    
  }

  Future<Response> postAsync(model) async {
    
      Map<String, dynamic> data = model;//.toJson();
      Response response = await dio.post("$baseUrl/$endpoint", data: data);
      return response;
  }

  Future<Response> patchAsync(model,String id) async {
    
      Map<String, dynamic> data = model.toJson();
      Response response = await dio.patch("$baseUrl/$endpoint/$id", data: data);
      return response;
  }

  Future<Response> deleteAsync(String id) async{
    Response response = await dio.delete("$baseUrl/$endpoint/$id");
    return response;
  }
}
