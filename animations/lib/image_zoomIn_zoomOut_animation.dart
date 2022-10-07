import 'package:flutter/material.dart';

class MapAnimation extends StatefulWidget {
  const MapAnimation({super.key});

  @override
  State<MapAnimation> createState() => _MapAnimationState();
}

class _MapAnimationState extends State<MapAnimation> with SingleTickerProviderStateMixin {
  late TransformationController controller;
  TapDownDetails? tapDownDetails;

  late AnimationController animationController;
  Animation<Matrix4>? animation;

  @override
  void initState() {
    super.initState();
    controller = TransformationController();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..addListener(
        () {
          controller.value = animation!.value;
        },
      );
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Container(
        alignment: Alignment.center,
        child: imageBuilder(),
      ),
    );
  }

  Widget imageBuilder() {
    return GestureDetector(
      onDoubleTapDown: (details) => tapDownDetails = details,
      onDoubleTap: () {
        final position = tapDownDetails!.localPosition;

        const double scale = 5;
        final x = -position.dx * (scale - 1);
        final y = -position.dy * (scale - 1);
        final zoomed = Matrix4.identity()
          ..translate(x, y)
          ..scale(scale);

        final end = controller.value.isIdentity() ? zoomed : Matrix4.identity();

        animation = Matrix4Tween(
          begin: controller.value,
          end: end,
        ).animate(CurveTween(curve: Curves.easeOut).animate(animationController));
        animationController.forward(from: 0);
      },
      child: InteractiveViewer(
        transformationController: controller,
        panEnabled: false,
        scaleEnabled: false,
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            'https://eoimages.gsfc.nasa.gov/images/imagerecords/62000/62350/Turkey.A2002264.0845.250m.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
