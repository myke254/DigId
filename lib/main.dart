// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:digital_identity_ui/Enums/Enums/ModelEnums.dart';
import 'package:digital_identity_ui/RepoLayer/Models/LocationModel.dart';
import 'package:digital_identity_ui/ServiceLayer/ApiService.dart';
import 'package:digital_identity_ui/screens/login_page.dart';
import 'package:digital_identity_ui/theme/app_theme.dart';
import 'package:digital_identity_ui/theme/constants.dart';
import 'package:digital_identity_ui/theme/theme_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
// Setup image picker configs (global settings for app)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Future<SharedPreferences> prefs = SharedPreferences.getInstance();
  prefs.then((value) {
    runApp(
      ChangeNotifierProvider<ThemeNotifier>(
        create: (BuildContext context) {
          String? theme = value.getString(Constants.APP_THEME) ?? '';

          if (theme == "" || theme == Constants.SYSTEM_DEFAULT) {
            value.setString(Constants.APP_THEME, Constants.SYSTEM_DEFAULT);
            return ThemeNotifier(ThemeMode.system);
          }
          return ThemeNotifier(
              theme == Constants.DARK ? ThemeMode.dark : ThemeMode.light);
        },
        child: MyApp(),
      ),
    );
  });
}
String? themeMode;
IconData? iconData = Icons.brightness_7;
SharedPreferences? prefs;
ThemeNotifier? themeNotifier;
getTheme() async {
  var prefs = await SharedPreferences.getInstance();
  themeMode = prefs.getString(Constants.APP_THEME);

  onThemeChanged(themeMode == 'Dark' ? 'light' : 'Dark');
  themeMode == 'Dark' ? iconData = Icons.brightness_3_sharp: iconData = Icons.brightness_7;
}
void onThemeChanged(String value) async {
  prefs = await SharedPreferences.getInstance();

  if (value == Constants.SYSTEM_DEFAULT) {
    themeNotifier?.setThemeMode(ThemeMode.system);
  } else if (value == Constants.DARK) {
    themeNotifier?.setThemeMode(ThemeMode.dark);
  } else {
    themeNotifier?.setThemeMode(ThemeMode.light);
  }
  prefs!.setString(Constants.APP_THEME, value);
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     final themeNotifier = Provider.of<ThemeNotifier>(context);
     final configs = ImagePickerConfigs();
    // AppBar text color
    configs.appBarTextColor = Colors.white;
    configs.appBarBackgroundColor = Colors.brown;
    // Disable select images from album
    // configs.albumPickerModeEnabled = false;
    // Only use front camera for capturing
    // configs.cameraLensDirection = 0;
    // Translate function
    configs.translateFunc = (name, value) => Intl.message(value, name: name);
    // Disable edit function, then add other edit control instead
    configs.adjustFeatureEnabled = false;
    configs.externalImageEditors['external_image_editor_1'] = EditorParams(
        title: 'external_image_editor_1',
        icon: Icons.edit_rounded,
        onEditorEvent: (
                {required BuildContext context,
                required File file,
                required String title,
                int maxWidth = 1080,
                int maxHeight = 1920,
                int compressQuality = 90,
                ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageEdit(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));
    configs.externalImageEditors['external_image_editor_2'] = EditorParams(
        title: 'external_image_editor_2',
        icon: Icons.edit_attributes,
        onEditorEvent: (
                {required BuildContext context,
                required File file,
                required String title,
                int maxWidth = 1080,
                int maxHeight = 1920,
                int compressQuality = 90,
                ImagePickerConfigs? configs}) async =>
            Navigator.of(context).push(MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) => ImageSticker(
                    file: file,
                    title: title,
                    maxWidth: maxWidth,
                    maxHeight: maxHeight,
                    configs: configs))));

    // Example about label detection & OCR extraction feature.
    // You can use Google ML Kit or TensorflowLite for this purpose
    configs.labelDetectFunc = (String path) async {
      return <DetectObject>[
        DetectObject(label: 'dummy1', confidence: 0.75),
        DetectObject(label: 'dummy2', confidence: 0.75),
        DetectObject(label: 'dummy3', confidence: 0.75)
      ];
    };
    configs.ocrExtractFunc =
        (String path, {bool? isCloudService = false}) async {
      if (isCloudService!) {
        return 'Cloud dummy ocr text';
      } else {
        return 'Dummy ocr text';
      }
    };

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Color(0xff8c261e),
        systemStatusBarContrastEnforced:false,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Digital Identity',
        theme: AppTheme().lightTheme,
        darkTheme: AppTheme().darkTheme,
        themeMode: themeNotifier.getThemeMode(),
        home:const Login()//const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
