import 'dart:convert';
import 'dart:io';

import 'package:digital_identity_ui/RepoLayer/Models/VoucheeModel.dart';
import 'package:digital_identity_ui/ServiceLayer/http_client_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../widgets/dialog.dart';

class MyVouchees extends StatefulWidget {
  const MyVouchees({Key? key}) : super(key: key);

  @override
  State<MyVouchees> createState() => _MyVoucheesState();
}

class _MyVoucheesState extends State<MyVouchees> {
  Future<List<VoucheeModel>> vouchees() async {
    List<VoucheeModel> vm = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> vmJson = jsonDecode(preferences.getString('voucher')!);
    await HttpClientUtil(
            baseUrl: '$BaseUrl',
            endpoint: 'vouchee/get-vouchees-by-voucherId/${vmJson['id']}')
        .getListAsync<VoucheeModel>(
          (json) => VoucheeModel.fromJson(json),
        )
        .then((vouchees) {
          vm = vouchees;
        });

    return vm;
  }

  @override
  Widget build(BuildContext context) {
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
              Text("My Vouchees",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff8c261e),
                      letterSpacing: 1.2)),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: FutureBuilder(
                  future: vouchees(),
                  builder: (context,AsyncSnapshot<List<VoucheeModel>> snapshot) {
                    return !snapshot.hasData?Center(child: CupertinoActivityIndicator(),): SafeArea(
                        child: snapshot.data!.isEmpty?Center(child: Text('You have\'t vouched for anyone yet'),): ListView.separated(
                          itemCount: snapshot.data!.length,
                          itemBuilder: ((context, index) {
                            var data = snapshot.data![index];
                          return ListTile(
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
                                      data.photos!.first.url!,
                                    ),
                                    height: 100,
                                    width: 70,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: Text('${data.firstName} ${data.middleName} ${data.lastName}'),
                            subtitle: Text('created at: ${DateTime.parse(data.dateCreated??DateTime.now().toString()).toString().substring(0,10)}'),
                            trailing: Icon(CupertinoIcons.check_mark_circled,color: Colors.green,),
                            onTap: (() {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text('Digital Id: ${data.digitalId}'),

                                      content: Material(
                                        color: Colors.transparent,
                                        elevation: 0,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${data.firstName} ${data.middleName} ${data.lastName}'),
                                            Text('Nationality: ${data.nationality}'),
                                            Text(
                                                'Gender: ${data.gender == 1 ? 'Female' : 'Male'}'),
                                            Text(
                                                'Date of Birth: ${DateTime.parse(data.dob!).toString().substring(0, 10)}\n'),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(children: data.photos!.map((e) => Card(
                                                  elevation: 12,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)),
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image.file(File(e.url!),
                                                          height: 100, width: 80, fit: BoxFit.fill)))).toList(),),
                                            ),
                                          ],
                                        ),
                                      )
                                    );
                                  });
                            }),
                          );
                        }), separatorBuilder: (BuildContext context, int index) { return Divider(); },));
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
