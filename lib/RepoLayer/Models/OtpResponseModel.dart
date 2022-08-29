class OtpResponseModel {
  String? statusMessage;
  String? statusCode;
  bool? successful;

  OtpResponseModel({this.statusMessage, this.statusCode, this.successful});

  OtpResponseModel.fromJson(Map<String, dynamic> json) {
    statusMessage = json['StatusMessage '];
    statusCode = json['StatusCode '];
    successful = json['Successful '];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['StatusMessage '] = statusMessage;
    data['StatusCode '] = statusCode;
    data['Successful '] = successful;
    return data;
  }
}