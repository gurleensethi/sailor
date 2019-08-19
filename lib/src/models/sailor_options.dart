import 'package:flutter/animation.dart';
import 'package:sailor/src/transitions/sailor_transition.dart';

/// Options to configure a Sailor instance.
class SailorOptions {
  final bool handleNameNotFoundUI;

  /// Should display logs in console. Sailor prints some useful logs
  /// which can be helpful during development.
  ///
  /// By default logs are disabled i.e. value is set to [false].
  final bool isLoggingEnabled;

  /// Default transitions for all the routes.
  /// Whatever transitions are provided in this list will be
  /// applied to every page launched using Sailor.
  ///
  /// These transitions are overridden by default route transitions and
  /// transitions provided when routing using Sailor's navigate method.
  final List<SailorTransition> defaultTransitions;

  /// Default duration for all the transitions.
  ///
  /// This duration is overridden by default route duration and duration
  /// provided when routing using Sailor's navigate method.
  final Duration defaultTransitionDuration;

  /// Default curve for all the transitions.
  ///
  /// This curve is overridden by default route curve and curve
  /// provided when routing using Sailor's navigate method.
  final Curve defaultTransitionCurve;

  const SailorOptions({
    this.handleNameNotFoundUI = false,
    this.isLoggingEnabled = false,
    this.defaultTransitions,
    this.defaultTransitionDuration,
    this.defaultTransitionCurve,
  })  : assert(handleNameNotFoundUI != null),
        assert(isLoggingEnabled != null);
}
