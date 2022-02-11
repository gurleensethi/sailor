import 'package:sailor/sailor.dart';
// import 'package:sailor/src/models/base_arguments.dart';
import 'package:flutter/widgets.dart';
// import 'package:meta/meta.dart';
// import 'package:sailor/src/models/sailor_param.dart';
// import 'package:sailor/src/models/sailor_route_guard.dart';
// import 'package:sailor/src/sailor.dart';
// import 'package:sailor/src/transitions/sailor_transition.dart';

typedef SailorRouteBuilder = Widget Function(
  BuildContext context,
  BaseArguments? args,
  ParamMap paramMap,
);

class SailorRoute {
  final String name;
  final SailorRouteBuilder builder;
  final BaseArguments? defaultArgs;
  final List<SailorTransition>? defaultTransitions;
  final Duration? defaultTransitionDuration;
  final Curve? defaultTransitionCurve;
  final List<SailorParam>? params;

  /// Ran before opening the route itself.
  /// If every route guard returns [true], the route is approvied and opened.
  /// Anything else will result in the route being rejected and not open.
  final List<SailorRouteGuard>? routeGuards;

  /// Provide a custom transition to sailor instead of using
  /// inbuilt transitions, if not provided, sailor will revert
  /// to use its default transitions or delegate to systems own
  /// transitions.
  final CustomSailorTransition? customTransition;

  const SailorRoute({
    required this.name,
    required this.builder,
    this.defaultArgs,
    this.defaultTransitions,
    this.defaultTransitionDuration,
    this.defaultTransitionCurve,
    this.params,
    this.customTransition,
    this.routeGuards,
  });
}
