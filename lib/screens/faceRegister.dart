//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../provider/Auth.dart';
//import './biometricRegister.dart';
import './homePage.dart';

class FaceRegisterScreen extends StatefulWidget {
  static String routeName = '/faceReg';
  final CameraDescription cameras;
  FaceRegisterScreen(this.cameras);
  @override
  _FaceRegisterScreenState createState() => _FaceRegisterScreenState();
}

class _FaceRegisterScreenState extends State<FaceRegisterScreen> {
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

  Future<bool> faceRegister(String username) async {
    try {
      await _initialiseControllerFuture;
      final path = join((await getTemporaryDirectory()).path, '$username.jpg');
      const url = "http://192.168.1.22:8000/api/profile/";
      await _controller.takePicture(path);
      //File file = File(path);
      Dio dio = new Dio();
      FormData formdata = FormData.fromMap({
        "username": username,
        "picture": await MultipartFile.fromFile(path, filename: "$username.jpg")
      });
      final response = await dio
          .post(url,
              data: formdata,
              options: Options(method: 'POST', responseType: ResponseType.json))
          .catchError((e) {
        print(e);
        return false;
      });
      print(response);
      final j = response.data as Map;
      return (j.containsKey('picture') && j.containsKey('user'));
    } catch (e) {
      print(e);
      return false;
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
          faceRegister(username).then((b) {
            setState(() {
              _isloading = false;
            });
            final text = b ? 'Success' : 'Unknown Error!';
            final content = b
                ? 'Face registration success, Go to next Page'
                : 'Can\'t connect to the server, Check your Internet Connection and Try Again';
            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text(text),
                      content: Text(content),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              if (!b)
                                Navigator.of(context).pop();
                              else
                                Navigator.of(context)
                                    .pushReplacementNamed(HomePage.routeName);
                            },
                            child: b ? Text('Next') : Text('OK'))
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
