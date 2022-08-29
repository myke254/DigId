// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:advance_image_picker/models/image_object.dart';
import 'package:advance_image_picker/widgets/picker/image_picker.dart';
import 'package:digital_identity_ui/Enums/gender_enum.dart';
import 'package:digital_identity_ui/ServiceLayer/db_methods.dart';
import 'package:digital_identity_ui/screens/vouchee_list.dart';
import 'package:digital_identity_ui/widgets/form_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class VoucheeRegistration extends StatefulWidget {
  const VoucheeRegistration({Key? key}) : super(key: key);

  @override
  State<VoucheeRegistration> createState() => _VoucheeRegistrationState();
}

class _VoucheeRegistrationState extends State<VoucheeRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController nationality = TextEditingController();
  TextEditingController connectionId = TextEditingController();
  List<ImageObject> _imgObjs = [];
  List<Map<String, dynamic>> imgObjs = [];
  DateTime dateTime = DateTime.now();
  Gender? gender = Gender.male;

  Future<File> moveFile(
    File sourceFile,
  ) async {
    Directory? directory = await getExternalStorageDirectory();
    try {
      // prefer using rename as it is probably faster

      return await sourceFile
          .rename('${directory!.path}/${sourceFile.path.split('/').last}');
    } on FileSystemException catch (e) {
      // if rename fails, copy the source file and then delete it
      final newFile = await sourceFile
          .copy('${directory!.path}/${sourceFile.path.split('/').last}');
      await sourceFile.delete();
      return newFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
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
                  height: 30,
                ),
                Text("Vouchee Registration",
                    style: GoogleFonts.varelaRound(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff8c261e),
                        letterSpacing: 1.2)),
                SizedBox(
                  height: 15,
                ),
                FormTextField(
                  controller: firstName,
                  formKey: _formKey,
                  hintText: "first name",
                  validator: (value) {
                    return value.isEmpty;
                  },
                  errorMessage: "first name should not be empty",
                ),
                FormTextField(
                  controller: middleName,
                  formKey: _formKey,
                  hintText: "middle name",
                  validator: (value) {
                    return value.isEmpty;
                  },
                  errorMessage: "middle name should not be empty",
                ),
                FormTextField(
                  controller: lastName,
                  formKey: _formKey,
                  hintText: "last name",
                  validator: (value) {
                    return value.isEmpty;
                  },
                  errorMessage: "last name should not be empty",
                ),
                FormTextField(
                  controller: nationality,
                  formKey: _formKey,
                  hintText: "nationality",
                  validator: (value) {
                    return value.isEmpty;
                  },
                  errorMessage: "nationality should not be empty",
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 12),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'Select Date of Birth',
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Color(0xff8c261e)),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      IconButton(
                          onPressed: () async {
                            setState(() {});
                            var newDate = await showDatePicker(
                                context: context,
                                firstDate: DateTime(1990),
                                initialDate: DateTime.now(),
                                lastDate: DateTime.now(),
                                currentDate: DateTime.now(),
                                useRootNavigator: false);
                            print(newDate);
                            if (newDate != null) {
                              setState(() {
                                dateTime = newDate;
                              });
                              print(dateTime);
                            }
                          },
                          icon: Icon(
                            CupertinoIcons.calendar,
                            color: Colors.green,
                            size: 35,
                          )),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        '${dateTime.year.toString()}/${dateTime.month.toString()}/${dateTime.day.toString()}',
                        style: GoogleFonts.varelaRound(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Color(0xff8c261e)),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Gender',
                    style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Color(0xff8c261e)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Radio(
                        value: Gender.male,
                        groupValue: gender,
                        onChanged: (val) {
                          setState(() {
                            gender = val as Gender?;
                          });
                          print(gender!.index);
                        }),
                    Text(
                      'male',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Color(0xff8c261e)),
                    ),
                    Radio(
                        value: Gender.female,
                        groupValue: gender,
                        onChanged: (val) {
                          setState(() {
                            gender = val as Gender?;
                          });
                          print(gender!.index);
                        }),
                    Text(
                      'female',
                      style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Color(0xff8c261e)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)),
                    tileColor: Colors.grey.withOpacity(.1),
                    iconColor: Color(0xff8c261e),
                    leading: Icon(Icons.camera),
                    title: Text("attach vouchee pictures"),
                    subtitle: Text("minimum(2) maximum(3)"),
                    onTap: () async {
                      List<ImageObject>? objects = await Navigator.of(context)
                          .push(PageRouteBuilder(
                              pageBuilder: (context, animation, __) {
                        return ImagePicker(maxCount: 3);
                      }));

                      if (objects!.isNotEmpty) {
                        setState(() {
                          _imgObjs = objects;

                          // imageFiles.addAll(
                          //     objects.map((e) => e.modifiedPath).toList());
                        });
                      }
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      _imgObjs.length,
                      (index) => ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              height: 80,
                              width: 80,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                elevation: 0,
                                                //  title: Material(child: Text(_imgObjs[index].modifiedPath.split('/').last,style: GoogleFonts.varelaRound(fontSize: 6),)),
                                                content: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.file(
                                                    File(_imgObjs[index]
                                                        .modifiedPath),
                                                    // height: 240,
                                                    // width: 180,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ));
                                    },
                                    child: Image.file(
                                      File(_imgObjs[index].modifiedPath),
                                      height: 120,
                                      width: 90,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: InkWell(
                                          onTap: () {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return CupertinoAlertDialog(
                                                    title: Text(
                                                      'Remove this Picture',
                                                      style: GoogleFonts
                                                          .varelaRound(
                                                              color: Color(
                                                                0xff8c261e,
                                                              ),
                                                              fontSize: 10),
                                                    ),
                                                    content: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      child: Image.file(
                                                        File(_imgObjs[index]
                                                            .modifiedPath),
                                                        // height: 240,
                                                        // width: 180,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            print(_imgObjs[
                                                                    index]
                                                                .modifiedPath);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('close')),
                                                      TextButton(
                                                          onPressed: () {
                                                            File(_imgObjs[index]
                                                                    .modifiedPath)
                                                                .delete();
                                                            _imgObjs.remove(
                                                                _imgObjs[
                                                                    index]);
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          },
                                                          child: Text('remove'))
                                                    ],
                                                  );
                                                });
                                          },
                                          child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                                size: 15,
                                              ))))
                                ],
                              ),
                            ),
                          )),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 12),
                    height: 50,
                    width: 120,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 129, 35, 28),
                        borderRadius: BorderRadius.circular(14)),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () async {
                          for (int i = 0; i < _imgObjs.length; i++) {
                            if(_imgObjs[i].modifiedPath.contains('cache')){
                            await File(_imgObjs[i].modifiedPath)
                                .copy(
                                    '/storage/emulated/0/Android/data/com.digital.identity.digital_identity_ui/files/${_imgObjs[i].modifiedPath.split('/').last}')
                                .then((img) async {
                              imgObjs.add(
                                  {'id': _imgObjs[i].label, 'path': img.path});
                              await File(_imgObjs[i].modifiedPath).delete();
                            });

                            }else{
                              imgObjs.add(
                                  {'id': _imgObjs[i].label, 'path': _imgObjs[i].modifiedPath});
                            }
                            // imgObjs.add({'id':_imgObjs[i].label,'path':_imgObjs[i].modifiedPath});
                          }
                          DbMethods().insert(
                              firstName: firstName.text,
                              middleName: middleName.text,
                              lastName: lastName.text,
                              nationality: nationality.text,
                              dob: dateTime.toString(),
                              gender: gender!.index,
                              pictures: jsonEncode(imgObjs));

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VoucheeList()));
                          firstName.clear();
                          middleName.clear();
                          lastName.clear();
                          nationality.clear();
                          dateTime = DateTime.now();
                          gender = Gender.male;
                          _imgObjs.clear();
                          imgObjs.clear();
                          setState(() {});
                        },
                        child: Center(
                          child: Text(
                            "submit",
                            style: GoogleFonts.varelaRound(
                                color: Colors.white, fontSize: 19),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
