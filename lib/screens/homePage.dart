import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import './homePage2.dart';
import 'package:provider/provider.dart';
import '../provider/Auth.dart';

class HomePage extends StatelessWidget {
  static String routeName = '/homePage';

  @override
  Widget build(BuildContext context) {
    const List<String> txtList = ['Welcome', 'hello', 'by'];
    String uname = Provider.of<Auth>(context).username;
    final String path =
        'https://ui-avatars.com/api/?background=8A2BE2&color=fff&name=$uname';
    print(uname);
    final alucard = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(path),
        ),
      ),
    );

    final welcome = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Welcome $uname',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    Widget textbuild(String texts) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          texts,
          style: const TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      );
    }

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(28.0),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          alucard,
          welcome,
          Container(
              child: CarouselSlider(
            aspectRatio: 2.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: false,
            initialPage: 2,
            autoPlay: true,
            items: txtList.map((item) => textbuild(item)).toList(),
          ))
        ],
      ),
    );

    return Scaffold(
      body: body,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            Navigator.of(context).pushReplacementNamed(MainHomePage.routeName),
        icon: Icon(Icons.navigate_next),
        label: Text("Skip"),
        backgroundColor: Color.fromRGBO(22, 17, 144, 1),
      ),
    );
  }
}
