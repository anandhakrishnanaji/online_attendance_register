import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

import './screens/changePassword.dart';
import './screens/loginPage.dart';
import './screens/homePage.dart';
import './provider/Auth.dart';
import './screens/registrationPage.dart';
import './screens/homePage2.dart';
import './screens/spalsh.dart';
import './screens/faceAuthentication.dart';
import './screens/faceRegister.dart';
//import './screens/biometricRegister.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras[1]));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final cameras;
  MyApp(this.cameras);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => Auth())],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        //auth.setCamera(cameras);
        return MaterialApp(
          title: 'Online Attendance',
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          home: auth.isAuth()
              ? MainHomePage()
              : FutureBuilder(
                  future: auth.checkIfLoggedIn(),
                  builder: (ctx, authres) =>
                      authres.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : LoginScreen()),
          routes: {
            HomePage.routeName: (ctx) => HomePage(),
            RegistrationScreen.routeName: (ctx) => RegistrationScreen(),
            MainHomePage.routeName: (ctx) => MainHomePage(),
            FaceAuthScreen.routeName: (ctx) => FaceAuthScreen(cameras),
            FaceRegisterScreen.routeName: (ctx) => FaceRegisterScreen(cameras),
            ChangePassScreen.routeName: (ctx) => ChangePassScreen(),
          },
        );
      }),
    );
  }
}
