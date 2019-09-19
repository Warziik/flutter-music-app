import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Music App',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Music app')),
        backgroundColor: Colors.teal[900],
      ),
      body: Center(
        child: Center(child: Card(
          elevation: 5,
          color: Colors.teal[800],
        )),
      ),
      backgroundColor: Colors.teal[800],
    );
  }
}
