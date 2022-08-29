class PhotosModel {
  String? url;
  String? name;

  PhotosModel({this.url, this.name});

  PhotosModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['url'] = url;
    data['name'] = name;
    return data;
  }
}
