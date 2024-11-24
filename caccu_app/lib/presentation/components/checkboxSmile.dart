import 'package:flutter/material.dart';

class SmileFaceCheckbox extends StatefulWidget {
  final double height;
  final bool isActive;
  final VoidCallback onPress;
  final Color activeColor;
  final Color deactiveColor;

  const SmileFaceCheckbox({
    Key? key,
    this.height = 100.0,
    required this.isActive,
    required this.onPress,
  })  : activeColor = const Color(0xff6ad56a),
        deactiveColor = const Color(0xFFEF5350),
        super(key: key);

  @override
  State<SmileFaceCheckbox> createState() => _SmileFaceCheckboxState();
}

class _SmileFaceCheckboxState extends State<SmileFaceCheckbox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animationValue;

  void setupAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animationValue = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 1.0),
    );
  }

  @override
  void initState() {
    setupAnimation();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height;
    final width = height * 2;
    final largeRadius = (height * 0.9) / 2;
    final smallRadius = (height * 0.2) / 2;
    return GestureDetector(
      onTap: widget.onPress,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          if (widget.isActive) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80.0),
              color:
              widget.isActive ? widget.activeColor : widget.deactiveColor,
              boxShadow: [
                BoxShadow(
                  color: widget.isActive
                      ? widget.activeColor.withOpacity(0.5)
                      : widget.deactiveColor.withOpacity(0.5),
                  blurRadius: 20.0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Transform.translate(
                  offset: Offset(
                      -largeRadius + largeRadius * 2 * _animationValue.value,
                      0), // add animation move from -largeRadius to largeRadius
                  child: Container(
                    width: largeRadius * 2,
                    height: largeRadius * 2,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.translate(
                          offset: Offset(0, -smallRadius),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                width: smallRadius * 2,
                                height: smallRadius * 2,
                                decoration: BoxDecoration(
                                  color: widget.isActive
                                      ? widget.activeColor
                                      : widget.deactiveColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: smallRadius * 2,
                                height: smallRadius * 2,
                                decoration: BoxDecoration(
                                  color: widget.isActive
                                      ? widget.activeColor
                                      : widget.deactiveColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0, smallRadius * 2),
                          child: Container(
                            width: smallRadius * 4,
                            height:
                            widget.isActive ? smallRadius * 2 : smallRadius,
                            decoration: BoxDecoration(
                              color: widget.isActive
                                  ? widget.activeColor
                                  : widget.deactiveColor,
                              borderRadius: !widget.isActive
                                  ? BorderRadius.circular(22.0)
                                  : const BorderRadius.only(
                                bottomLeft: Radius.circular(40.0),
                                bottomRight: Radius.circular(40.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}