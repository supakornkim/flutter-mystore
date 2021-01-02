import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:my_store/AppTheme/AppStateNotifier.dart';
import 'package:my_store/AppTheme/appTheme.dart';
import 'package:my_store/AppTheme/my_behaviour.dart';
import 'package:my_store/functions/change_language.dart';
import 'package:my_store/functions/localizations.dart';
import 'package:my_store/pages/login_signup/login.dart';
import 'package:my_store/pages/onboarding/onboarding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLanguage appLanguage = AppLanguage();
  await appLanguage.fetchLocale();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(
      ChangeNotifierProvider<AppStateNotifier>(
        builder: (context) => AppStateNotifier(),
        child: MyApp(
          appLanguage: appLanguage,
        ),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final AppLanguage appLanguage;

  MyApp({this.appLanguage});
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateNotifier>(
      builder: (context, appState, child) {
        return ChangeNotifierProvider<AppLanguage>(
          builder: (_) => appLanguage,
          child: Consumer<AppLanguage>(builder: (context, model, child) {
            return MaterialApp(
              title: 'MyStore',
              debugShowCheckedModeBanner: false,
              locale: model.appLocal,
              supportedLocales: [
                Locale('en', 'US'),
                Locale('hi', ''),
                Locale('ar', ''),
                Locale('zh', ''),
                Locale('id', ''),
                Locale('ru', ''),
              ],
              localizationsDelegates: [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode:
                  appState.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
              builder: (context, child) {
                return ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: child,
                );
              },
              home: MyHomePage(),
            );
          }),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool progress = true;

  @override
  initState() {
    super.initState();

    checkOnboardingStatus();
  }

  checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int onBoardingStatus = (prefs.getInt('onboardingStatus') ?? 0);
    if (onBoardingStatus == 0) {
      Timer(
          Duration(seconds: 4),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OnBoarding()),
              ));
    } else {
      Timer(
          Duration(seconds: 4),
          () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    // var appLanguage = Provider.of<AppLanguage>(context);

    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash_image.png"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).translate('splash', 'welcomeMsg'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jost',
                letterSpacing: 0.7,
              ),
            ),
            SizedBox(height: 17.0),
            Text(
              'MYSTORE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jost',
                letterSpacing: 0.7,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
