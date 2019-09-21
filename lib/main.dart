import 'dart:async';
import 'dart:async' as prefix0;

import 'package:flutter/material.dart';
import 'music.dart';
import 'package:audioplayer2/audioplayer2.dart';

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

  Duration position = Duration(seconds: 0);
  Duration duration = Duration(seconds: 10);

  AudioPlayer audioPlayer;
  StreamSubscription subPosition;
  StreamSubscription subState;
  PlayerState status = PlayerState.stopped;
  int index = 0;

  @override
  void initState() {
    super.initState();
    currentMusic = musics[index];
    configureAudioPlayer();
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
                width: screenHeight / 2,
                child: Image.asset(currentMusic.imagePath),
              ),
            ),
            textWithStyle(currentMusic.title, 1.5),
            textWithStyle(currentMusic.artist, 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                actionButton(Icons.fast_rewind, 30, MusicActions.rewind),
                actionButton((status == PlayerState.playing) ? Icons.pause : Icons.play_arrow, 45, (status == PlayerState.playing) ? MusicActions.pause : MusicActions.play),
                actionButton(Icons.fast_forward, 30, MusicActions.forward)
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                textWithStyle(fromDuration(position), 0.8),
                textWithStyle(fromDuration(duration), 0.8)
                ],
              ),
            ),
            Slider(
              value: position.inSeconds.toDouble(),
              inactiveColor: Colors.teal[300],
              activeColor: Colors.teal[900],
              min: 0,
              max: 30,
              onChanged: (double d) {
                setState(() {
                 audioPlayer.seek(d); 
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
            play();
            break;
          case MusicActions.pause:
            pause();
            break;
          case MusicActions.rewind:
            rewind();
            break;
          case MusicActions.forward:
            forward();
            break;
        }
      },
    );
  }

  void configureAudioPlayer() {
    audioPlayer = AudioPlayer();
    subPosition = audioPlayer.onAudioPositionChanged.listen(
      (pos) => setState(() => position = pos) 
    );
    subState = audioPlayer.onPlayerStateChanged.listen((pState) {
      if (pState == PlayerState.playing) {
        setState() {
          duration = audioPlayer.duration;
        }
      } else if(pState == PlayerState.stopped) {
        setState(() {
         status = PlayerState.stopped; 
        });
      }
    }, onError: (message) {
      print('Erreur $message');
      setState(() {
       status = PlayerState.stopped;
       duration = Duration(seconds: 0);
       position = Duration(seconds: 0); 
      });
    });
  }

  prefix0.Future play() async {
    await audioPlayer.play(currentMusic.urlSong);
    setState(() {
     status = PlayerState.playing; 
    });
  }

  prefix0.Future pause() async {
    await audioPlayer.pause();
    setState(() {
     status = PlayerState.paused; 
    });
  }

  void forward() {
    if (index == musics.length - 1) {
      index = 0;
    } else {
      index++;
    }
    currentMusic = musics[index];
    audioPlayer.stop();
    configureAudioPlayer();
    play();
  }

  void rewind() {
    if (position > Duration(seconds: 3)) {
      audioPlayer.seek(0);
    } else {
      if (index == 0) {
        index = musics.length - 1;
      } else {
        index--;
      }
      currentMusic = musics[index];
      audioPlayer.stop();
      configureAudioPlayer();
      play();
    }
  }

  String fromDuration(Duration duration) {
    return duration.toString().split('.').first;
  }
}

enum MusicActions {
  play,
  pause,
  rewind,
  forward
}

enum PlayerState {
  playing,
  stopped,
  paused
}