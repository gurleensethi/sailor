import 'package:flutter/material.dart';

class SlideRightPageRoute extends PageRoute {
  final RouteSettings settings;
  final WidgetBuilder builder;
  final Curve curve;

  SlideRightPageRoute({
    this.settings,
    @required this.builder,
    this.curve = Curves.linear,
  }) : super(settings: settings);

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(1, 0.0),
        end: Offset.zero,
      ).animate(curvedAnimation),
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}
