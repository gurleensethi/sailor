import 'package:sailor/src/models/base_arguments.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:sailor/src/models/sailor_param.dart';
import 'package:sailor/src/transitions/sailor_transition.dart';

typedef SailorRouteBuilder = Widget Function(
    BuildContext context, BaseArguments args);

class SailorRoute {
  final String name;
  final SailorRouteBuilder builder;
  final BaseArguments defaultArgs;
  final List<SailorTransition> defaultTransitions;
  final Duration defaultTransitionDuration;
  final Curve defaultTransitionCurve;
  final List<SailorParam> params;

  const SailorRoute({
    @required this.name,
    @required this.builder,
    this.defaultArgs,
    this.defaultTransitions,
    this.defaultTransitionDuration,
    this.defaultTransitionCurve,
    this.params,
  })  : assert(name != null),
        assert(builder != null);
}
