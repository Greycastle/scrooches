import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: OrientationBuilder(builder: (ctx, orientation) {
          final background = orientation == Orientation.portrait
              ? 'assets/images/forest_profile.jpg'
              : 'assets/images/forest_landscape.jpg';

          return Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(background), fit: BoxFit.cover)),
              child: Stack(
                  children: const [Scrooch('scrooch1'), Scrooch('scrooch2')]));
        }),
      ),
    );
  }
}

class DraggableScrooch extends StatelessWidget {
  final Scrooch scrooch;

  const DraggableScrooch({super.key, required this.scrooch});

  @override
  Widget build(BuildContext context) {
    return Draggable(
      feedback: scrooch,
      child: scrooch,
    );
  }
}

class Scrooch extends StatefulWidget {
  final String name;

  const Scrooch(this.name, {super.key});

  @override
  State<Scrooch> createState() => _ScroochState();
}

class _ScroochState extends State<Scrooch> {
  double x = Random().nextInt(200).toDouble();
  double y = Random().nextInt(200).toDouble();
  AudioPlayer player = AudioPlayer();
  bool soundReady = false;

  @override
  void initState() {
    final sounds = [
      'village-dog-barking-sound.mp3',
      'cat-purr-sound.mp3',
      'sheep-baa-sound.mp3'
    ];
    sounds.shuffle();
    player
        .setAsset('assets/sounds/${sounds[0]}')
        .then((value) => soundReady = true)
        .onError((error, stackTrace) {
      debugPrint(error.toString() + stackTrace.toString());
      return false;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scrooch =
        Image.asset('assets/images/${widget.name}.png', width: 120, height: 120)
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(end: -20.0, duration: 1.seconds, curve: Curves.easeInOut)
            .scaleY(
                begin: 0.95,
                end: 1.0,
                duration: 1.seconds,
                curve: Curves.easeInOut);
    return Positioned(
        top: y,
        left: x,
        child: Draggable(
          childWhenDragging: Container(),
          feedback: scrooch,
          onDragEnd: (details) => {
            setState(() {
              x = details.offset.dx;
              y = details.offset.dy;
            })
          },
          child: GestureDetector(
              onTap: () async {
                // this stops working after we've moved it
                try {
                  if (!soundReady) {
                    debugPrint('sound not ready');
                    return;
                  }
                  if (player.playing) {
                    await player.stop();
                  }

                  await player.play();
                } catch (error) {
                  debugPrint(error.toString());
                }
              },
              child: scrooch),
        ));
  }
}
