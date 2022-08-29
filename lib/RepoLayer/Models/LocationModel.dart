class LocationModel {
  String? id;
  String? dateCreated;
  String? name;
  String? administrativeArea;

  LocationModel(
      {this.id, this.dateCreated, this.name, this.administrativeArea});

  LocationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['dateCreated'];
    name = json['name'];
    administrativeArea = json['administrativeArea'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['dateCreated'] = dateCreated;
    data['name'] = name;
    data['administrativeArea'] = administrativeArea;
    return data;
  }
}