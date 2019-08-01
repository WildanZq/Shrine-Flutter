import 'package:flutter/material.dart';

class ExpandableContainer extends StatefulWidget {
  final Widget child;
  final bool expand;
  final double begin;

  ExpandableContainer(
      {Key key, this.child, this.expand = false, this.begin = 0.0})
      : super(key: key);

  _ExpandableContainerState createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    prepareAnimation();
  }

  void prepareAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    Animation curve = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    animation = Tween(begin: widget.begin, end: 1.0).animate(curve);
  }

  @override
  void didUpdateWidget(ExpandableContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expand) {
      animationController.forward();
    } else {
      animationController.reverse();
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      axisAlignment: -1,
      sizeFactor: animation,
      child: widget.child,
    );
  }
}
