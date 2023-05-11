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
    return Directionality(
      textDirection: TextDirection.ltr,
      child: OrientationBuilder(builder: (ctx, orientation) {
        final background = orientation == Orientation.portrait
            ? 'assets/images/forest_profile.png'
            : 'assets/images/forest_landscape.png';

        return Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(background), fit: BoxFit.cover)),
            child: Stack(children: const [
              Scrooch('scrooch1', x: 20, y: 30),
              Scrooch('scrooch2', x: 240, y: 20)
            ]));
      }),
    );
  }
}

class Scrooch extends StatelessWidget {
  final double x;
  final double y;
  final String name;

  const Scrooch(this.name, {super.key, required this.x, required this.y});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: y,
        left: x,
        child: GestureDetector(
            onTap: () {
              AudioPlayer player = AudioPlayer();
              final sounds = [
                'village-dog-barking-sound.mp3',
                'cat-purr-sound.mp3',
                'sheep-baa-sound.mp3'
              ];
              sounds.shuffle();
              player
                  .setAsset('assets/sounds/${sounds[0]}')
                  .then((value) => player.play());
            },
            child: Image.asset('assets/images/$name.png',
                    width: 120, height: 120)
                .animate(
                    onPlay: (controller) => controller.repeat(reverse: true))
                .moveY(end: -20.0, duration: 1.seconds, curve: Curves.easeInOut)
                .scaleY(
                    begin: 0.95,
                    end: 1.0,
                    duration: 1.seconds,
                    curve: Curves.easeInOut)));
  }
}
