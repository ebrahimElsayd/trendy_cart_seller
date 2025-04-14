import 'package:flutter/material.dart';

import '../../theme/text_style.dart';

class AnimatedPriceWidget extends StatefulWidget {
  final double price;
  final TextStyle? style;
  final String prefix;

  const AnimatedPriceWidget({
    super.key,
    required this.price,
    this.style,
    this.prefix = "EGP",
  });

  @override
  State<AnimatedPriceWidget> createState() => _AnimatedPriceWidgetState();
}

class _AnimatedPriceWidgetState extends State<AnimatedPriceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: widget.price).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    )..addListener(() {
      setState(() {});
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedPriceWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.price != widget.price) {
      _animation = Tween<double>(
        begin: oldWidget.price,
        end: widget.price,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "${widget.prefix} ${_animation.value.toStringAsFixed(2)}",
      style: widget.style ?? TextStyles.Roboto20mediumBlack,
    );
  }
}
