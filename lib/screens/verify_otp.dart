// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:math';

import 'package:digital_identity_ui/RepoLayer/Models/LocationModel.dart';
import 'package:digital_identity_ui/RepoLayer/Models/OtpRequestModel.dart';
import 'package:digital_identity_ui/RepoLayer/Models/OtpResponseModel.dart';
import 'package:digital_identity_ui/ServiceLayer/http_client_util.dart';
import 'package:digital_identity_ui/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../RepoLayer/Models/VoucheeModel.dart';
import '../ServiceLayer/api.dart';
import '../ServiceLayer/db_methods.dart';
import '../ServiceLayer/generate_otp.dart';
import '../widgets/otp_form_field.dart';

ValueNotifier<String> code = ValueNotifier("");

class OtpVerificationPage extends StatefulWidget {
  const OtpVerificationPage({Key? key, required this.voucheeModel, required this.localVouchee}) : super(key: key);
 final Map<String,dynamic> voucheeModel;
 final Map<String,dynamic> localVouchee;

  @override
  State<OtpVerificationPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<OtpVerificationPage> {
bool success = false;
bool verified = false;
bool verifying = false;
Future<bool>postToDb()async{
  bool uploaded = false;
  try {
                    await HttpClientUtil(
                            baseUrl: "$BaseUrl",
                            endpoint: "vouchee/post-vouchee")
                        .postAsync(widget.voucheeModel)
                        .then((value) {
                      if (value.statusCode == 201) {

                        DbMethods().delete(widget.localVouchee['_id']);
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg: 'Vouchee Created successfully');
                        setState((){
                          uploaded = true;
                        });
                      } else {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                            msg:
                                'Failed to create vouchee, please try again later');
                      }

                    });
                  } on DioError catch (e) {
                    Navigator.pop(context);
                    Fluttertoast.showToast(msg: e.message);
                  }
                  return uploaded;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ValueListenableBuilder(
          valueListenable: code,
          builder: (context, value, child) {
            return SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xff8c261e)),
                      child: Card(
                          margin: EdgeInsets.all(2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Navigator.of(context).pop(),
                            child: Icon(CupertinoIcons.back),
                          ))),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    "OTP Verification",
                    style: GoogleFonts.varelaRound(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      "Enter verification code sent to your Email in the field provided",
                      style: GoogleFonts.varelaRound(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8c261e),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4,(index) => OtpFormField(index: index,)),
                  ),
                  SizedBox(
                    height: 70,
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 12),
                      height: 50,
                      width: 120,
                      decoration: BoxDecoration(
                          color: Color(0xff8c261e),
                          borderRadius: BorderRadius.circular(14)),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          //onTap: () =>Navigator.of(context).push(MaterialPageRoute(builder:( context)=>OtpVerificationPage())),
                          onTap:verifying?(){}:verified?(){
                            print(widget.voucheeModel);
                          }: () async {
                            //Otp().getOtp1('token');
                            setState((){
                              verifying = true;
                            });
                            Dio dio = await Dio();


                            while(!success){
                              SharedPreferences preferences = await SharedPreferences.getInstance();
                              String token = preferences.getString('token')??'';
                              String? reference = preferences.getString("reference");
                              Dio dio = await Dio();
                              Map<String,dynamic> data = {
                                "reference": reference!,
                                    "operation":"onboarding",
                            "source":"chatbot",
                                "otp":code.value
                              };
                              try{
                                await dio.post('https://api-omnichannel-uat.azure-api.net/v1/otp/verify',
                                  options: Options(
                                    headers: {
                                      "Authorization": "Bearer $token",
                                      "Content-Type": "application/json"
                                    },
                                  ),
                                  data: jsonEncode(data),
                                ).then((res){
                                  if(res.statusCode == 200){

                                    setState((){
                                      success = true;
                                      verified = true;
                                      verifying = false;
                                    });
                                    postToDb().then((value) {
                                      print(value);
                                    });
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



                            //Api();
                          // Otp().fetchAlbum();

                            /*var res = await HttpClientUtil(
                                    baseUrl:"$BaseUrl",
                                    endpoint: "location/get-all-locations")
                                .getListAsync<LocationModel>(
                              (json) => LocationModel.fromJson(json),
                            );
                            for (var i in res) {
                              print(jsonEncode(i));
                            }*/
                            print(code.value);
                          },
                          child: Center(
                            child: verifying?CupertinoActivityIndicator():Text(
                              verified?"Verified 👍":"Verify",
                              style: GoogleFonts.varelaRound(
                                  color: Colors.white,
                                  fontSize: 19,
                                  letterSpacing: 1.2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Didn't Receive Code? ",
                          style: GoogleFonts.varelaRound(
                              fontWeight: FontWeight.bold)),
                      InkWell(
                        onTap: ()async {
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          print(preferences.get('reference'));
                        },
                        child: Text("Resend",
                            style: GoogleFonts.varelaRound(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff8c261e))),
                      )
                    ],
                  )
                ],
              ),
            ));
          }),
    );
  }
}
