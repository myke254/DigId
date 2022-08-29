// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:digital_identity_ui/RepoLayer/Models/LocationModel.dart';
import 'package:digital_identity_ui/RepoLayer/Models/VoucherModel.dart';
import 'package:digital_identity_ui/ServiceLayer/http_client_util.dart';
import 'package:digital_identity_ui/screens/verify_otp.dart';
import 'package:digital_identity_ui/screens/vouchee_list.dart';
import 'package:digital_identity_ui/screens/vouchee_registration.dart';
import 'package:digital_identity_ui/screens/vouchees.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../RepoLayer/Models/PhotosModel.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

Future<VoucherModel> voucher() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  VoucherModel voucher = VoucherModel();
  PhotosModel pm = PhotosModel();
  Map<String, dynamic> vmJson = jsonDecode(prefs.getString('voucher')!);
  List<PhotosModel> lPm = [];
  vmJson['photos'].forEach((photo) {
    pm.name = photo['name'];
    pm.url = photo['url'];
    lPm.add(pm);
  });

  voucher.dateCreated = vmJson['dateCreated'];
  voucher.designation = vmJson['designation'];
  voucher.firstName = vmJson['firstName'];
  voucher.id = vmJson['id'];
  voucher.idNumber = vmJson['idNumber'];
  voucher.lastName = vmJson['lastName'];
  voucher.locationRefId = vmJson['locationRefId'];
  voucher.phone = vmJson['phone'];
  voucher.gender = vmJson['gender'];
  voucher.photos = lPm;

  return voucher;
}

Future<LocationModel> location(id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  LocationModel location = LocationModel();
  if (prefs.getString('location') == null) {
    location = await HttpClientUtil(
            baseUrl: 'https://da36-197-248-246-149.in.ngrok.io/api',
            endpoint: 'location/get-location-by-id')
        .getAsync<LocationModel>((json) => LocationModel.fromJson(json), id);
    prefs.setString('location', jsonEncode(location));
  } else {
    Map<String, dynamic> locJson = jsonDecode(prefs.getString('location')!);
    location.administrativeArea = locJson['administrativeArea'];
    location.name = locJson['name'];
    location.dateCreated = locJson['dateCreated'];
    location.id = locJson['id'];
  }

  return location;
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: voucher(),
          builder:
              (BuildContext context, AsyncSnapshot<VoucherModel> snapshot) {
            return !snapshot.hasData
                ? CupertinoActivityIndicator()
                : SingleChildScrollView(
                  child: SafeArea(
                      child: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         
                           Image.asset(
                    Theme.of(context).brightness == Brightness.light
                        ? "assets/equity-bank-logo.png"
                        : "assets/equity-bank-logo1.png",
                    height: 90,
                    width: 120,
                  ),
                   SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Welcome to Equity Digital Identity', // ${snapshot.data!.designation} ${snapshot.data!.firstName}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff8c261e),
                                letterSpacing: 1.2),
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          SizedBox(
                            height: 160,
                            width: double.infinity,
                            child: FutureBuilder(
                                future: location(snapshot.data!.locationRefId!),
                                builder:
                                    (context, AsyncSnapshot<LocationModel> snap) {
                                  return !snap.hasData
                                      ? CircularProgressIndicator()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              // mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${snapshot.data!.firstName} ${snapshot.data!.lastName}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                      //color: Color(0xff8c261e),
                                                      letterSpacing: 1.2),
                                                ),
                                                Text(
                                                  'Designation: ${snapshot.data!.designation}',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      //color: Color(0xff8c261e),
                                                      letterSpacing: 1),
                                                ),
                                                Text(
                                                  'Location: ${snap.data!.name} - ${snap.data!.administrativeArea}',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      // color: Color(0xff8c261e),
                                                      letterSpacing: 1),
                                                ),
                                              ],
                                            ),
                                            Card(
                                              color: Color(0xff8c261e),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(76)),
                                              child: CachedNetworkImage(
                                                imageUrl: snapshot
                                                    .data!.photos!.first.url!,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  margin: EdgeInsets.all(2),
                                                  height: 150,
                                                  width: 150,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(75),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CupertinoActivityIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                          ],
                                        );
                                }),
                          ),
                          Divider(),
                          //  Image.network(snapshot.data!.photos!.first.url!),
                          ListTile(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: ((context) =>
                                        VoucheeRegistration()))),
                            leading:Icon(CupertinoIcons.person_add),
                            title: Text('Register a Vouchee'),
                          ),
                          Divider(),
                          ListTile(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: ((context) => VoucheeList()))),
                            leading: Icon(CupertinoIcons.list_dash),
                            title: Text('Show List of Pending Vouchees'),
                          ),
                           Divider(),
                          ListTile(
                           /* onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: ((context) => OtpVerificationPage()))),*/
                            leading: Icon(CupertinoIcons.checkmark_alt_circle),
                            title: Text('My Vouchees'),
                          )
                        ],
                      ),
                    )),
                );
          }),
    );
  }
}
