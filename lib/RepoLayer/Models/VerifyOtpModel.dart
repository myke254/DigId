class VerifyOtpModel {
  String? reference;
  String? operation;
  String? source;
  String? otp;

  VerifyOtpModel({this.reference, this.operation, this.source, this.otp});

  VerifyOtpModel.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
    operation = json['operation'];
    source = json['source'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['reference'] = reference;
    data['operation'] = operation;
    data['source'] = source;
    data['otp'] = otp;
    return data;
  }
}