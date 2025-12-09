import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color normalColor;
  final Color hoverColor;
  final double fontSize;

  const HoverButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.normalColor = Colors.white70,
    this.hoverColor = Colors.blueAccent,
    this.fontSize = 16,
  });

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          style: TextStyle(
            color: _hovering ? widget.hoverColor : widget.normalColor,
            fontSize: widget.fontSize,
            decoration:
                _hovering ? TextDecoration.underline : TextDecoration.none,
            fontWeight: _hovering ? FontWeight.bold : FontWeight.normal,
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }
}
