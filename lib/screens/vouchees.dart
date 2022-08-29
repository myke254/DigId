import 'dart:convert';

import 'package:digital_identity_ui/RepoLayer/Models/VoucheeModel.dart';
import 'package:digital_identity_ui/ServiceLayer/http_client_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

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
      body: FutureBuilder(
        future: vouchees(),
        builder: (context,AsyncSnapshot<List<VoucheeModel>> snapshot) {
          return !snapshot.hasData?Center(child: CupertinoActivityIndicator(),): SafeArea(
              child: snapshot.data!.isEmpty?Center(child: Text('You have\'t vouched for anyone yet'),): ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: ((context, index) {
                  var data = snapshot.data![index];
                return ListTile(
                  title: Text('${data.firstName}'),
                );
              })));
        }
      ),
    );
  }
}
