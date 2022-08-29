import 'PhotosModel.dart';

class VoucherModel {
  String? id;
  String? dateCreated;
  String? firstName;
  String? lastName;
  String? designation;
  String? idNumber;
  String? phone;
  String? locationRefId;
  int? gender;
  List<PhotosModel>? photos;

  VoucherModel(
      {this.id,
      this.dateCreated,
      this.firstName,
      this.lastName,
      this.designation,
      this.idNumber,
      this.phone,
      this.locationRefId,
      this.gender,
      this.photos});

  VoucherModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['dateCreated'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    designation = json['designation'];
    idNumber = json['idNumber'];
    phone = json['phone'];
    locationRefId = json['locationRefId'];
    gender = json['gender'];
    if (json['photos'] != null) {
      photos = <PhotosModel>[];
      json['photos'].forEach((v) {
        photos!.add(PhotosModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dateCreated'] = dateCreated;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['designation'] = designation;
    data['idNumber'] = idNumber;
    data['phone'] = phone;
    data['locationRefId'] = locationRefId;
    data['gender'] = gender;
    if (photos != null) {
      data['photos'] = photos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
