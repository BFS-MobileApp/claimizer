// Import necessary packages
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../CommonUtils/image_utils.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Create animation controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Adjust duration as needed
    );
    // Create animation
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose the animation controller when not needed
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation, // Assign the animation to opacity
      child: Padding(
        padding: EdgeInsets.all(6.sp),
        child: Image.asset(
          ImageUtils.getImagePath("logo"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
