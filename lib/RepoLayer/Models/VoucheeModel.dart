import 'ConnectionModel.dart';
import 'PhotosModel.dart';

class VoucheeModel {
  String? id;
  String? dateCreated;
  String? firstName;
  String? lastName;
  String? middleName;
  String? voucherRefId;
  String? voice;
  String? nationality;
  String? dob;
  int? gender;
  int? digitalId;
  List<PhotosModel>? photos;
  List<ConnectionModel>? connection;

  VoucheeModel(
      {this.firstName,
      this.lastName,
      this.middleName,
      this.voucherRefId,
      this.voice,
      this.nationality,
      this.dob,
      this.gender,
      this.digitalId,
      this.photos,
      this.connection});

  VoucheeModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    middleName = json['middleName'];
    voucherRefId = json['voucherRefId'];
    voice = json['voice'];
    nationality = json['nationality'];
    dob = json['dob'];
    gender = json['gender'];
   // digitalId = json['digitalId'];
    if (json['photos'] != null) {
      photos = <PhotosModel>[];
      json['photos'].forEach((v) {
        photos!.add(PhotosModel.fromJson(v));
      });
    }
    if (json['connection'] != null) {
      connection = <ConnectionModel>[];
      json['connection'].forEach((v) {
        connection!.add(ConnectionModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['middleName'] = this.middleName;
    data['voucherRefId'] = this.voucherRefId;
    data['voice'] = this.voice;
    data['nationality'] = this.nationality;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['digitalId'] = this.digitalId;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    if (this.connection != null) {
      data['connection'] = this.connection!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
