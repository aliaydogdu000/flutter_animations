import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class BouncingBallAnimation extends StatefulWidget {
  const BouncingBallAnimation({super.key});

  @override
  _BouncingBallAnimationState createState() => _BouncingBallAnimationState();
}

class _BouncingBallAnimationState extends State<BouncingBallAnimation> with TickerProviderStateMixin {
  AnimationController? _controller;
  SpringSimulation? _simulation;

  var _spring;
  @override
  void initState() {
    _spring = const SpringDescription(mass: 5, stiffness: 300, damping: 1);
    _simulation = SpringSimulation(_spring, 10, 500, 0);
    _controller = AnimationController(
      vsync: this,
      upperBound: 1000,
    )..addListener(() {
        setState(() {});
      });

    _controller!.animateWith(_simulation!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller!.animateWith(_simulation!);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              right: 200,
              top: _controller!.value,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.green[500],
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }
}
