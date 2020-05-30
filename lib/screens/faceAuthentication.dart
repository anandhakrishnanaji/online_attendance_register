import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../provider/Auth.dart';
//import './biometricRegister.dart';
import './homePage2.dart';

class FaceAuthScreen extends StatefulWidget {
  static String routeName = '/faceReg';
  final CameraDescription cameras;
  FaceAuthScreen(this.cameras);
  @override
  _FaceAuthenticationScreenState createState() =>
      _FaceAuthenticationScreenState();
}

class _FaceAuthenticationScreenState extends State<FaceAuthScreen> {
  CameraController _controller;
  Future<void> _initialiseControllerFuture;
  bool _isloading = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras, ResolutionPreset.medium);
    _initialiseControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<int> faceAuth(String username) async {
    try {
      await _initialiseControllerFuture;
      final now = DateTime.now().toString();
      final path = join((await getTemporaryDirectory()).path, '$now.jpg');
      const url = "http://192.168.1.22:8000/api/faceauth/";
      await _controller.takePicture(path);
      //File file = File(path);
      Dio dio = new Dio();
      FormData formdata = FormData.fromMap({
        "username": username,
        "picture": await MultipartFile.fromFile(path, filename: "$now.jpg")
      });
      final response = await dio
          .post(url,
              data: formdata,
              options: Options(method: 'POST', responseType: ResponseType.json))
          .catchError((e) {


        final dir = Directory(path);
        dir.deleteSync(recursive: true);

        
        print(e);
        return 0;
      });
      print(response);
      final j = response.data as Map;
      if (j['picture'])
        return 1;
      else
        return -1;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<Auth>(context, listen: false).username;
    return Scaffold(
      appBar: AppBar(
        title: Text('Camera'),
      ),
      body: FutureBuilder<void>(
          future: _initialiseControllerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              return CameraPreview(_controller);
            else
              return CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _isloading = true;
          });
          faceAuth(username).then((b) {
            setState(() {
              _isloading = false;
            });
            const text = {1: 'Success', 0: 'Unknown Error!', -1: 'Failed!'};
            const content = {
              1: 'Face authentication success, Attendance and time registerd',
              0: 'Can\'t connect to the server, Check your Internet Connection and Try Again',
              -1: 'Face does not match with the registered face,Try Again'
            };
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text(text[b]),
                      content: Text(content[b]),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              if (b != 1)
                                Navigator.of(context).pop();
                              else
                                Navigator.of(context).pushReplacementNamed(
                                    MainHomePage.routeName);
                            },
                            child: b == 1 ? Text('Next') : Text('OK'))
                      ],
                    ));
          });
        },
        child:
            _isloading ? CircularProgressIndicator() : Icon(Icons.camera_alt),
      ),
    );
  }
}
