import 'dart:math';

import 'package:animations/bouncing_ball_animation.dart';
import 'package:animations/image_zoomIn_zoomOut_animation.dart';
import 'package:flutter/material.dart';

class FlipAnimation extends StatefulWidget {
  const FlipAnimation({
    Key? key,
  }) : super(key: key);

  @override
  _FlipAnimationState createState() => _FlipAnimationState();
}

class _FlipAnimationState extends State<FlipAnimation> {
  late bool frontSide;
  late bool flipXAxis;

  @override
  void initState() {
    super.initState();
    frontSide = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BouncingBallAnimation(),
                ),
              );
            },
            icon: const Icon(
              Icons.sports_baseball,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapAnimation(),
                ),
              );
            },
            icon: const Icon(
              Icons.zoom_in_map_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: DefaultTextStyle(
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        child: Center(
          child: SizedBox(
            height: 200,
            width: 330,
            child: _buildFlipAnimation(),
          ),
        ),
      ),
    );
  }

  void _changeSide() {
    setState(() {
      frontSide = !frontSide;
    });
  }

  Widget _buildFlipAnimation() {
    return GestureDetector(
      onTap: _changeSide,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 1000),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget!, ...list]),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
        child: frontSide ? _buildFront() : _buildRear(),
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnimation = Tween(
      begin: pi,
      end: 0.0,
    ).animate(
      animation,
    );
    return AnimatedBuilder(
      animation: rotateAnimation,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(frontSide) != widget?.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.002;
        tilt *= isUnder ? -1.0 : 1.0;
        final value = isUnder
            ? min(
                rotateAnimation.value,
                pi / 2,
              )
            : rotateAnimation.value;
        return Transform(
          transform: (Matrix4.rotationY(value)..setEntry(3, 0, tilt)),
          alignment: Alignment.center,
          child: widget,
        );
      },
    );
  }

  Widget _buildFront() {
    return __buildLayout(
      key: const ValueKey(true),
      backgroundColor: Colors.green,
      front: true,
      name: "ALİ AYDOĞDU",
      cardNo: "1234 5678 9123 4567",
      cardType: "VISA",
      bankName: "FlutterBANK",
      child: const ColorFiltered(
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
        child: FlutterLogo(),
      ),
    );
  }

  Widget _buildRear() {
    return __buildLayout(
      key: const ValueKey(false),
      front: false,
      bankName: "FlutterBANK",
      backgroundColor: Colors.green,
      child: const Padding(
        padding: EdgeInsets.all(15.0),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcATop),
          child: FlutterLogo(),
        ),
      ),
    );
  }

  Widget __buildLayout(
      {Key? key,
      Widget? child,
      String? bankName,
      String? cardType,
      String? cardNo,
      String? name,
      Color? backgroundColor,
      bool? front}) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _cardNo(cardNo),
          _rearBlackLine(front),
          _rearWhiteLine(front),
          _rearBankDomain(front),
          _qrCode(front),
          _chip(front),
          _cardType(cardType),
          _bankName(front, child, bankName),
          _ownerName(name),
        ],
      ),
    );
  }

  Positioned _ownerName(String? name) {
    return Positioned(
      bottom: 15.0,
      left: 20.0,
      child: Text(
        name ?? "",
        style: const TextStyle(fontSize: 20),
      ),
    );
  }

  Positioned _bankName(bool? front, Widget? child, String? bankName) {
    return Positioned(
        top: front! ? 10.0 : 150.0,
        left: front ? 10.0 : 0,
        child: Row(
          children: [
            child ?? const SizedBox(),
            Text(
              bankName ?? "",
              style: TextStyle(
                fontSize: front ? 25 : 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ));
  }

  Positioned _cardType(String? cardType) {
    return Positioned(
      bottom: 15,
      right: 15,
      child: Text(
        cardType ?? "",
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Positioned _chip(bool? front) {
    return Positioned(
      left: 20,
      top: 110,
      child: Container(
        alignment: FractionalOffset.center,
        transform: Matrix4.identity()
          ..rotateZ(
            270 * pi / 180,
          ),
        child: front! ? const Icon(size: 40, Icons.sd_card) : const SizedBox(),
      ),
    );
  }

  Positioned _qrCode(bool? front) {
    return Positioned(
      bottom: 15,
      right: 15,
      child: !front!
          ? const Icon(
              Icons.qr_code,
              size: 50,
            )
          : const SizedBox(),
    );
  }

  Positioned _rearBankDomain(bool? front) {
    return Positioned(
      left: 60,
      child: !front! ? const Text("www.flutterbank.com | 444 1 234") : const SizedBox(),
    );
  }

  Positioned _rearWhiteLine(bool? front) {
    return Positioned(
      top: 85,
      left: 15,
      child: !front!
          ? Container(
              color: Colors.white54,
              height: 45,
              width: 200,
            )
          : const SizedBox(),
    );
  }

  Positioned _rearBlackLine(bool? front) {
    return Positioned(
      top: 20,
      child: !front!
          ? Container(
              color: Colors.black,
              height: 45,
              width: 350,
            )
          : const SizedBox(),
    );
  }

  Positioned _cardNo(String? cardNo) {
    return Positioned(
      bottom: 50,
      left: 20.0,
      child: Text(
        cardNo ?? "",
        style: const TextStyle(fontSize: 25),
      ),
    );
  }
}
