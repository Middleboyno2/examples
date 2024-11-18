import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarPainter extends CustomPainter{
  double x;

  AppBarPainter({required this.x});


  double height = 80.0;
  double start = 40.0;
  double end = 120.0;


  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0.0, start);
    // path.lineTo(10.0, 0.0);


    /// dịch chuyển x càng nhỏ thì càng
    /// DROP paths, included X for animation
    path.lineTo((x) < 20.0 ? 20.0 : x, start);
    path.quadraticBezierTo(20.0 + x, start, 30.0 + x, start + 30.0);
    path.quadraticBezierTo(40.0 + x, start + 55.0, 70.0 + x, start +55.0);
    path.quadraticBezierTo(100.0 + x, start + 55.0, 110.0 + x, start + 30.0);
    path. quadraticBezierTo(
        120.0 + x,
        start,
        (140.0 + x) > (size.width - 20.0) ? (size.width - 20.0) : 140.0+x,
        start);
    path.lineTo(size.width - 20.0, start);
    /// Box with BorderRadius
    path.quadraticBezierTo(size.width, start, size.width, start + 25.0);
    path. lineTo(size.width, end - 25.0);
    path.quadraticBezierTo(size.width, end, size.width - 25.0, end);
    path. lineTo(25.0, end);
    path.quadraticBezierTo(0.0, end, 0.0, end - 25.0);
    path.lineTo(0.0, start + 25.0);
    path.quadraticBezierTo(0.0, start, 20.0, start);
    path.close();



    canvas.drawPath(path, paint);
    canvas.drawCircle(Offset(70.0 + x, 50.0), 35.0, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}