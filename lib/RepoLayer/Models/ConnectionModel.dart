class ConnectionModel {
  String? name;
  int? idType;
  int? id;

  ConnectionModel({this.name, this.idType, this.id});

  ConnectionModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    idType = json['idType'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['idType'] = this.idType;
    data['id'] = this.id;
    return data;
  }
}
