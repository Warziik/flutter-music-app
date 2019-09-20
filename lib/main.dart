import 'package:flutter/material.dart';
import 'music.dart';

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
  List<Music> musics = [
    Music('My song', 'Warzik', 'assets/img/1.jpg', 'https://codabee.com/wp-content/uploads/2018/06/un.mp3'),
    Music('My other song', 'Autre', 'assets/img/1.jpg', 'https://codabee.com/wp-content/uploads/2018/06/deux.mp3')
  ];

  Music currentMusic;

  double position = 0;

  @override
  void initState() {
    super.initState();
    currentMusic = musics[0];
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Music app'),
        backgroundColor: Colors.teal[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Card(
              elevation: 9,
              child: Container(
                width: screenHeight / 2.5,
                child: Image.asset(currentMusic.imagePath),
              ),
            ),
            textWithStyle(currentMusic.title, 1.5),
            textWithStyle(currentMusic.artist, 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                actionButton(Icons.fast_rewind, 30, MusicActions.rewind),
                actionButton(Icons.play_arrow, 45, MusicActions.play),
                actionButton(Icons.fast_forward, 30, MusicActions.forward)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                textWithStyle('0:0', 0.8),
                textWithStyle('0:22', 0.8)
              ],
            ),
            Slider(
              value: position,
              inactiveColor: Colors.teal[300],
              activeColor: Colors.teal[900],
              min: 0,
              max: 30,
              onChanged: (double d) {
                setState(() {
                 position = d; 
                });
              },
            )
          ],
        ),
      ),
      backgroundColor: Colors.teal[800],
    );
  }

  Text textWithStyle(String content, double scale) {
    return Text(
      content,
      textScaleFactor: scale,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontStyle: FontStyle.italic
      ),
    );
  }

  IconButton actionButton(IconData icon, double size, MusicActions actions) {
    return IconButton(
      icon: Icon(icon),
      color: Colors.white,
      iconSize: size,
      onPressed: () {
        switch(actions) {
          case MusicActions.play:
            print('Play');
            break;
          case MusicActions.pause:
            print('Pause');
            break;
          case MusicActions.rewind:
            print('Rewind');
            break;
          case MusicActions.forward:
            print('Forward');
            break;
        }
      },
    );
  }
}

enum MusicActions {
  play,
  pause,
  rewind,
  forward
}