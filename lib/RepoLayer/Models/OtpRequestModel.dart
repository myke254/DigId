
class OtpRequestModel {
  String? reference;
  String? to;
  int? platform;
  String? operation;
  String? source;
  int? noofDigit;
  String? customerId;

  OtpRequestModel(
      {this.reference,
        this.to,
        this.platform,
        this.operation,
        this.source,
        this.noofDigit,
        this.customerId});

  OtpRequestModel.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
    to = json['to'];
    platform = json['platform'];
    operation = json['operation'];
    source = json['source'];
    noofDigit = json['noofDigit'];
    customerId = json['customerId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reference'] = this.reference;
    data['to'] = this.to;
    data['platform'] = this.platform;
    data['operation'] = this.operation;
    data['source'] = this.source;
    data['noofDigit'] = this.noofDigit;
    data['customerId'] = this.customerId;
    return data;
  }
}
