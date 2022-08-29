// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:digital_identity_ui/ServiceLayer/db_methods.dart';
import 'package:digital_identity_ui/ServiceLayer/firebase_service.dart';
import 'package:digital_identity_ui/ServiceLayer/http_client_util.dart';
import 'package:digital_identity_ui/constants.dart';
import 'package:digital_identity_ui/screens/verify_otp.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ServiceLayer/generate_otp.dart';

class MyDialog extends StatefulWidget {
  const MyDialog({
    Key? key,
    required this.vouchee,
    required this.voucheeModel,
    required this.voucheePictures,
  }) : super(key: key);
  final Map<String, dynamic> vouchee, voucheeModel;
  final List<Map<String, dynamic>> voucheePictures;
  @override
  State<MyDialog> createState() => _MyDialogState();
}

List<Map<String, dynamic>> pictures = [];

class _MyDialogState extends State<MyDialog> {
  bool postingVouchee = false;

  /*Future<bool> uploadPictures() async {
    bool uploadedAllPictures = true;
    widget.voucheePictures.forEach((picture) {
      print(picture);
      String fileName = picture['path'].toString().split('/').last;
      File file = File(picture['path']);

      FirebaseApi.uploadFile("files/$fileName", file)!
          .whenComplete(() {})
          .then((value) async {
        if (value.state != TaskState.error) {
          final urlDownload = await value.ref.getDownloadURL();
          print(urlDownload);
          pictures.add({'name': fileName, 'url': urlDownload});
        } else {
          setState(() {
            uploadedAllPictures = false;
          });
        }
        print(pictures);
        print(uploadedAllPictures);
      });
      setState(() {});
    });

    return uploadedAllPictures;
  }*/
  Future<Map<String, dynamic>> data ()async{
    var rand = Random();
    String ref = "";
    for (var i = 0; i < 12; i++) {
      ref += rand.nextInt(9).toString();
    }
    print(ref);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String phoneNumber = "254" +
        jsonDecode(preferences.getString('voucher')!)['phone']
            .toString()
            .substring(1);
    print(phoneNumber);
    Map<String, dynamic> myData = {
      "reference": ref,
      "to": phoneNumber,
      "platform": 1,
      "operation": "onboarding",
      "source": "chatbot",
      "noofDigit": 4,
      "customerId": "0178194299581"
    };
    print(myData);
    return myData;
  }
  bool success = false;
  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('First name: ${widget.vouchee['first_name']}'),
            Text('Middle name: ${widget.vouchee['middle_name']}'),
            Text('Last name: ${widget.vouchee['last_name']}'),
            Text('Nationality: ${widget.vouchee['nationality']}'),
            Text(
                'Gender: ${widget.vouchee['gender'] == 1 ? 'Female' : 'Male'}'),
            Text(
                'Date of Birth: ${DateTime.parse(widget.vouchee['dob']).toString().substring(0, 10)}\n'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: widget.voucheePictures
                  .map((e) => Card(
                      elevation: 12,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(File(e['path']),
                              height: 80, width: 60, fit: BoxFit.fill))))
                  .toList(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              postingVouchee
                  ? Fluttertoast.showToast(msg: 'please wait')
                  : Navigator.pop(context);
            },
            child: Text(
              'Dismiss',
              style: TextStyle(color: Color(0xff8c261e)),
            )),
        TextButton(
            onPressed: () async {

              setState((){
                postingVouchee = true;
              });


                  while(!success){
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    String token = preferences.getString('token')??'';
                    Map<String,dynamic> myData ={};
                    await data().then((d) {
                      setState((){
                        myData = d;
                      });
                    });
                    Dio dio = await Dio();
                    try{
                      await dio.post('https://api-omnichannel-uat.azure-api.net/v1/otp',
                        options: Options(
                          headers: {
                            "Authorization": "Bearer $token",
                            "Content-Type": "application/json"
                          },
                        ),
                        data: jsonEncode(myData),
                      ).then((res){
                        if(res.statusCode == 200){
                          preferences.setString('reference',myData['reference'] );
                          setState((){
                            success = true;
                            postingVouchee = false;
                          });
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>OtpVerificationPage(voucheeModel: widget.voucheeModel,localVouchee: widget.vouchee,)));
                        }else{
                          Otp().getToken();
                        }
                        print(res.statusCode);
                      });
                    } on DioError catch(e){
                      Otp().getToken();
                      print(e.message);
                    }finally{
                      setState((){});
                    }
                  }







            },
            child: postingVouchee
                ? CupertinoActivityIndicator()
                : Text(
                    'Create vouchee',
                    style: TextStyle(color: Color(0xff8c261e)),
                  ))
      ],
    );
  }
}
