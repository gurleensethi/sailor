import 'package:flutter/animation.dart';
import 'package:sailor/src/models/base_arguments.dart';
import 'package:sailor/src/models/sailor_param.dart';
import 'package:sailor/src/transitions/custom_sailor_transition.dart';
import 'package:sailor/src/transitions/sailor_transition.dart';

class ArgumentsWrapper {
  final BaseArguments? baseArguments;
  final List<SailorTransition>? transitions;
  final Duration? transitionDuration;
  final Curve? transitionCurve;
  final Map<String, dynamic>? params;

  /// Route params that are initially defined for the Route.
  /// Note: These are needed here, because user must be able to retrieve
  /// params from within the launched route. Since the only thing available
  /// from inside a launched route are arguments, these paramters are provided
  /// along with the arguments.
  final Map<String, SailorParam>? routeParams;

  final CustomSailorTransition? customTransition;

  ArgumentsWrapper({
    this.baseArguments,
    this.transitions,
    this.transitionDuration,
    this.transitionCurve,
    this.params,
    this.routeParams,
    this.customTransition,
  });

  ArgumentsWrapper copyWith({
    BaseArguments? baseArguments,
    List<SailorTransition>? transitions,
    Duration? transitionDuration,
    Curve? transitionCurve,
    List<SailorParam>? params,
    Map<String, SailorParam>? routeParams,
    CustomSailorTransition? customTransition,
  }) {
    return ArgumentsWrapper(
      baseArguments: baseArguments ?? this.baseArguments,
      transitions: transitions ?? this.transitions,
      transitionDuration: transitionDuration ?? this.transitionDuration,
      transitionCurve: transitionCurve ?? this.transitionCurve,
      params: params as Map<String, dynamic>? ?? this.params,
      routeParams: routeParams ?? this.routeParams,
      customTransition: customTransition ?? this.customTransition,
    );
  }

  @override
  String toString() {
    return 'ArgumentsWrapper{baseArguments: $baseArguments, '
        'transitions: $transitions, '
        'transitionDuration: $transitionDuration, '
        'transitionCurve: $transitionCurve}, '
        'params: $params, '
        'customTransition: $customTransition';
  }
}
