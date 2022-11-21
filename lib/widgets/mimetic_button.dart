import 'package:flutter/widgets.dart';

class MimeticButton extends StatefulWidget {
  final Widget child;

  const MimeticButton({super.key, required this.child});

  @override
  State<MimeticButton> createState() => _MimeticButtonState();
}

class _MimeticButtonState extends State<MimeticButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: controller.value,
          child: GestureDetector(
            onTapDown: (details) {},
            onTapUp: (details) {},
            onTapCancel: () {},
            onTap: () {},
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
