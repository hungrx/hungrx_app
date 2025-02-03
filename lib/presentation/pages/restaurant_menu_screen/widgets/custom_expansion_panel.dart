// custom_expansion_panel.dart
import 'package:flutter/material.dart';

class CustomExpansionPanel extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final bool isExpanded;
  final Function(bool) onExpansionChanged;
  final double leftPadding;
  final double fontSize;
  final Color backgroundColor;

  const CustomExpansionPanel({
    super.key,
    required this.title,
    required this.children,
    required this.isExpanded,
    required this.onExpansionChanged,
    this.leftPadding = 0,
    this.fontSize = 18,
    this.backgroundColor = Colors.black,
  });

  @override
  State<CustomExpansionPanel> createState() => _CustomExpansionPanelState();
}

class _CustomExpansionPanelState extends State<CustomExpansionPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(CustomExpansionPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: [
          Material(
            color: widget.backgroundColor,
            child: InkWell(
              enableFeedback: true,
              onTap: () => widget.onExpansionChanged(!widget.isExpanded),
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: widget.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    RotationTransition(
                      turns:
                          Tween(begin: 0.0, end: 0.5).animate(_expandAnimation),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(children: widget.children),
          ),
        ],
      ),
    );
  }
}
