import 'package:flutter/animation.dart';
import 'package:sailor/sailor.dart';

class RouteArgsPair {
  final String name;
  final BaseArguments args;
  final List<SailorTransition> transitions;
  final Duration transitionDuration;
  final Curve transitionCurve;
  final CustomSailorTransition customTransition;

  RouteArgsPair(
    this.name, {
    this.args,
    this.transitions,
    this.transitionDuration,
    this.transitionCurve,
    this.customTransition,
  });
}
