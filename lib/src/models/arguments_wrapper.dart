import 'package:flutter/animation.dart';
import 'package:sailor/sailor.dart';
import 'package:sailor/src/transitions/sailor_transition.dart';

class ArgumentsWrapper {
  final BaseArguments baseArguments;
  final List<SailorTransition> transitions;
  final Duration transitionDuration;
  final Curve transitionCurve;

  ArgumentsWrapper({
    this.baseArguments,
    this.transitions,
    this.transitionDuration,
    this.transitionCurve,
  });

  @override
  String toString() {
    return 'ArgumentsWrapper{baseArguments: $baseArguments, '
        'transitions: $transitions, '
        'transitionDuration: $transitionDuration, '
        'transitionCurve: $transitionCurve}';
  }
}
