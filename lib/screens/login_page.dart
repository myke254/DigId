// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:digital_identity_ui/RepoLayer/Models/PhotosModel.dart';
import 'package:digital_identity_ui/RepoLayer/Models/VoucherModel.dart';
import 'package:digital_identity_ui/ServiceLayer/http_client_util.dart';
import 'package:digital_identity_ui/constants.dart';
import 'package:digital_identity_ui/screens/landing_page.dart';
import 'package:digital_identity_ui/screens/verify_otp.dart';
import 'package:digital_identity_ui/screens/vouchee_registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/form_text_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final textFieldFocusNode = FocusNode();
  bool _obscurepassword = true;
  bool _obscureConfirmPassword = true;
  // bool register = true;
  bool recoverPassword = false;

  void _toggleObscured(bool pass) {
    setState(() {
      if (pass) {
        _obscurepassword = !_obscurepassword;
      } else {
        _obscureConfirmPassword = !_obscureConfirmPassword;
      }

      if (textFieldFocusNode.hasPrimaryFocus) {
        return;
      } // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus = false;
      // Prevents focus if tap on eye
    });
  }

  void toggleSignin() {
    setState(() {
      // register = !register;
    });
  }
  bool loggingIn = false;
  void toggleRecoverPassword() {
    setState(() {
      recoverPassword = !recoverPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? "assets/equity-bank-logo.png"
                      : "assets/equity-bank-logo1.png",
                  height: 90,
                  width: 120,
                ),
                SizedBox(height: 30),
                Center(
                    child: Text('Welcome',
                        style: GoogleFonts.varelaRound(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: const Color(
                              0xff8c261e,
                            )))),
                SizedBox(height: 30),
                Center(
                    child: Text("Equity Digital Identity",
                        style: GoogleFonts.varelaRound(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    // register
                    //     ? "Register"
                    //     :
                    recoverPassword
                        ? "Provide an Email address you previously Logged in with to send a password reset email"
                        : "Login",
                    style: GoogleFonts.varelaRound(
                        color: const Color(
                          0xff8c261e,
                        ),
                        fontSize: 13),
                  ),
                ),
                FormTextField(
                  validator: (String value) => value.isEmpty,
                  errorMessage: "Please provide a valid phone number",
                  inputType: TextInputType.phone,
                  prefixIcon: Icon(Icons.phone),
                  suffixIcon: SizedBox(),
                  controller: phoneController,
                  //formKey: _formKey,
                  hintText: "phone number",
                ),
                if (
                // register ||
                !recoverPassword)
                  FormTextField(
                    validator: (String value) => value.isEmpty,
                    errorMessage: "invalid password",
                    inputType: TextInputType.visiblePassword,
                    prefixIcon: Icon(Icons.password),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurepassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => _toggleObscured(true),
                    ),
                    controller: passwordController,
                    //formKey: _formKey,
                    letterSpacing: 2.0,
                    obscured: _obscurepassword,
                    hintText: "Password",
                    focusNode: textFieldFocusNode,
                  ),
                // if (register)
                //   FormTextField(
                //      validator: (String value){
                //    return value!=passwordController.text;
                //   },
                //   errorMessage: "Passwords do not match",
                //     inputType: TextInputType.visiblePassword,
                //     prefixIcon: Icon(Icons.password),
                //     suffixIcon: IconButton(
                //       icon: Icon(_obscureConfirmPassword
                //           ? Icons.visibility
                //           : Icons.visibility_off),
                //       onPressed: () => _toggleObscured(false),
                //     ),
                //     controller: confirmPasswordController,
                //     //formKey: _formKey,
                //     letterSpacing: 2.0,
                //     obscured: _obscureConfirmPassword,
                //     hintText: "Confirm Password",
                //     focusNode: textFieldFocusNode,
                //   ),
                // if (!register)
                Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                          onTap: loggingIn?()=>Fluttertoast.showToast(msg: 'logging in please wait'): toggleRecoverPassword,
                          child: Text(!recoverPassword
                              ? "forgot password?"
                              : "Back to login")),
                    )),
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
                        onTap:loggingIn?(){
                          Fluttertoast.showToast(msg: 'logging in... please wait');
                        }: () async {
                          setState((){
                            loggingIn = true;
                          });
                          VoucherModel vm = VoucherModel();
                          PhotosModel pm = PhotosModel();
                          if (_formKey.currentState!.validate()) {
                            try {
                              SharedPreferences preferences = await SharedPreferences.getInstance();
                             if(preferences.getString('voucher')==null){
                              await HttpClientUtil(
                                  baseUrl: '$BaseUrl',
                                  endpoint: 'voucher/get-voucher-by-phone')
                              .getAsync<VoucherModel>(
                                  (json) => VoucherModel.fromJson(json),
                                  phoneController.text).then((value) {

                                  preferences.setString('voucher', jsonEncode(value));
                                  if (value.idNumber == passwordController.text) {
                                    setState((){
                                      loggingIn = false;
                                    });
                                  Navigator.of(context).push(
                                   MaterialPageRoute(
                                   builder: (context) => LandingPage()));
                        
                                }else{
                                  Fluttertoast.showToast(msg: 'invalid login credentials');
                                }
                                  setState((){
                                    loggingIn = false;
                                  });
                                  });

                             }else{
                              Map<String,dynamic> vmJson = jsonDecode(preferences.getString('voucher')!);
                              List<PhotosModel> lPm = [];
                              vmJson['photos'].forEach((photo){
                                pm.name = photo['name'];
                                pm.url = photo['url'];
                                lPm.add(pm);
                              });

                              vm.dateCreated = vmJson['dateCreated'];
                              vm.designation =vmJson['designation'];
                              vm.firstName =vmJson['firstName'];
                              vm.id =vmJson['id'];
                              vm.idNumber =vmJson['idNumber'];
                              vm.lastName =vmJson['lastName'];
                              vm.locationRefId =vmJson['locationRefId'];
                              vm.phone =vmJson['phone'];
                              vm.gender =vmJson['gender'];
                             // vm.photos = vmJson['photos'] as List<PhotosModel>;
                              vm.photos =lPm;
                              
                            // Fluttertoast.showToast(msg:vm.phone.toString(),toastLength: Toast.LENGTH_LONG);
                             if ((phoneController.text == vm.phone)&&(passwordController.text == vm.idNumber)) {
                                 Navigator.of(context).push(
                                   MaterialPageRoute(
                                   builder: (context) => LandingPage()));
                              }else{
                                Fluttertoast.showToast(msg: 'invalid login credentials');
                              }
                             }
                                  
                          }on DioError catch (e) {
                            Fluttertoast.showToast(msg: 'An Error Occurred... Please try Again later');
                          }
                          }
                        },
                        child: Center(
                          child:loggingIn?CircularProgressIndicator(): Text(
                            // register
                            //     ? "Register"
                            //     :
                            recoverPassword ? "Reset Password" : "login",
                            style: GoogleFonts.varelaRound(
                                color: Colors.white,
                                fontSize: recoverPassword ? 15 : 19),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Align(
                //   alignment: Alignment.center,
                //   child: Padding(
                //     padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                //     child: InkWell(
                //       onTap: () {
                //         toggleSignin();
                //         recoverPassword ? toggleRecoverPassword() : null;
                //       },
                //       child: Text(
                //         register ? "Login instead" : "No account? Register now",
                //         style: GoogleFonts.varelaRound(
                //             fontSize: 18, color: Color(0xff8c261e)),
                //       ),
                //     ),
                //   ),
                // ),
                // if (!recoverPassword)
                //   Center(
                //       child: SizedBox(
                //     height: 50,
                //     child: Stack(
                //       children: [
                //         Align(
                //             alignment: Alignment.center,
                //             child: Container(
                //               decoration: BoxDecoration(
                //                 color: Colors.black,
                //               ),
                //               width: 200,
                //               height: 1,
                //             )),
                //         Align(
                //             alignment: Alignment.center,
                //             child: Container(
                //               height: 30,
                //               width: 30,
                //               decoration: BoxDecoration(
                //                   color: Color(0xff8c261e),
                //                   borderRadius: BorderRadius.circular(15)),
                //               child: Center(
                //                   child: Text(
                //                 "OR",
                //                 style: GoogleFonts.varelaRound(
                //                     color: Colors.white),
                //               )),
                //             ))
                //       ],
                //     ),
                //   )),
                //   if(!recoverPassword)
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Center(
                //       child: Text("Continue With",
                //           style: GoogleFonts.varelaRound(
                //               color: const Color(
                //             0xff8c261e,
                //           )))),
                // ),
                // if (!recoverPassword)
                //   Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Column(
                //         children: [
                //           InkWell(
                //             onTap: (){
                //               print(phoneController.text);
                //             },
                //             child: Image.asset(
                //               "assets/google.png",
                //               fit: BoxFit.fill,
                //               height: 30,
                //               width: 30,
                //             ),
                //           ),
                //           Text(
                //             "Google",
                //             style: GoogleFonts.varelaRound(
                //                 fontWeight: FontWeight.bold),
                //           )
                //         ],
                //       ),
                //       Container(height: 40,width: 1,color: Colors.black,),
                //       Column(
                //         children: [
                //           InkWell(
                //             onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=>VoucheeRegistration())),
                //             child: Image.asset(
                //               "assets/facebook.png",
                //               fit: BoxFit.fill,
                //               height: 37,
                //               width: 37,
                //             ),
                //           ),
                //           Text(
                //             "facebook",
                //             style: GoogleFonts.varelaRound(
                //                 fontWeight: FontWeight.bold),
                //           )
                //         ],
                //       )
                //     ],
                //   )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
