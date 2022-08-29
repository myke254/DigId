// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:digital_identity_ui/ServiceLayer/database_helper.dart';
import 'package:digital_identity_ui/widgets/dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VoucheeList extends StatefulWidget {
  const VoucheeList({Key? key}) : super(key: key);

  @override
  State<VoucheeList> createState() => _VoucheeListState();
}

class _VoucheeListState extends State<VoucheeList> {
  final DatabaseHelper _helper = DatabaseHelper.instance;
  List<Map<String, dynamic>> voucheeList = [];
  bool dbHasData = false;
  getVoucheeList() async {
    List<Map<String, dynamic>> data = await _helper.queryAllRows();
    if (mounted) {
      setState(() {
        voucheeList = data;
        dbHasData = true;
      });
    }
  }

  List<Map<String, dynamic>> voucheePictures(int index) {
    List<Map<String, dynamic>> pictures = [];
    List jsonData = jsonDecode(voucheeList[index]['pictures']);
    for (var element in jsonData) {
      pictures.add(element);
    }
    return pictures;
  }

  List<Map<String, dynamic>> parsedImages(int index) {
    List<Map<String, dynamic>> parsedImages = [];
    for (var picture in voucheePictures(index)) {
      parsedImages.add({
        'url': picture['path'],
        'name': picture['id'].toString(),
      });
    }
   // parsedImages.forEach(print);
    return parsedImages;
  }

  bool postingVouchee = false;

  Future<Map<String, dynamic>> vm(index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      "firstName": voucheeList[index]['first_name'],
      "lastName": voucheeList[index]['last_name'],
      "middleName": voucheeList[index]['middle_name'],
      "voucherRefId": jsonDecode(preferences.getString('voucher')!)['id'],
      "voice": "string",
      "nationality": voucheeList[index]['nationality'],
      "dob":
          "${DateTime.parse(voucheeList[index]['dob']).toString().substring(0, 10)}T09:19:31.353Z",
      "gender": voucheeList[index]['gender'],
      "photos": parsedImages(index),
      "connection": [
        {"name": "string", "idType": 0, "id": 0}
      ]
    };
   // print(jsonEncode(data));
    return data;
  }

  @override
  Widget build(BuildContext context) {
    getVoucheeList();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                height: 20,
              ),
              Text("Pending Vouchees",
                  style: GoogleFonts.varelaRound(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff8c261e),
                      letterSpacing: 1.2)),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: !dbHasData
                      ? const Center(
                          child: CupertinoActivityIndicator(),
                        )
                      : voucheeList.isEmpty
                          ? Center(
                              child: Text('no data'),
                            )
                          : ListView.separated(
                              itemCount: voucheeList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onLongPress: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CupertinoAlertDialog(
                                            title: Text('delete this vouchee?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text('cancel')),
                                              TextButton(
                                                  onPressed: () => _helper
                                                          .delete(
                                                              voucheeList[index]
                                                                  ['_id'])
                                                          .then((value) {
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      }),
                                                  child: Text('delete'))
                                            ],
                                          );
                                        });
                                  },
                                  onTap: (() {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return FutureBuilder(
                                              future: vm(index),
                                              builder: (context,
                                                  AsyncSnapshot<
                                                          Map<String, dynamic>>
                                                      snapshot) {
                                                return snapshot.hasData
                                                    ? MyDialog(
                                                        vouchee:
                                                            voucheeList[index],
                                                        voucheeModel:
                                                            snapshot.data!,
                                                        voucheePictures:
                                                            voucheePictures(
                                                                index),
                                                      )
                                                    : SizedBox();
                                              });
                                        });
                                  }),
                                  leading: Material(
                                    elevation: 12,
                                    color: Color(0xff8c261e),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.file(
                                          File(
                                            voucheePictures(index)
                                                .first['path'],
                                          ),
                                          height: 100,
                                          width: 70,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                      'first name: ${voucheeList[index]['first_name']}\nmiddle name: ${voucheeList[index]['middle_name']}\nlast name: ${voucheeList[index]['last_name']}'),
                                  subtitle: Text(
                                      'nationality: ${voucheeList[index]['nationality']}'),
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Divider();
                              },
                            ))
            ],
          ),
        ),
      ),
    );
  }
}
