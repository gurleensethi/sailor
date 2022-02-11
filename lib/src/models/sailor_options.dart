// import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:sailor/src/transitions/custom_sailor_transition.dart';
import 'package:sailor/src/transitions/sailor_transition.dart';

/// Options to configure a Sailor instance.
class SailorOptions {
  final bool? handleNameNotFoundUI;

  /// Should display logs in console. Sailor prints some useful logs
  /// which can be helpful during development.
  ///
  /// By default logs are disabled i.e. value is set to [false].
  final bool? isLoggingEnabled;

  /// Default transitions for all the routes.
  /// Whatever transitions are provided in this list will be
  /// applied to every page launched using Sailor.
  ///
  /// These transitions are overridden by default route transitions and
  /// transitions provided when routing using Sailor's navigate method.
  final List<SailorTransition>? defaultTransitions;

  /// Default duration for all the transitions.
  ///
  /// This duration is overridden by default route duration and duration
  /// provided when routing using Sailor's navigate method.
  final Duration? defaultTransitionDuration;

  /// Default curve for all the transitions.
  ///
  /// This curve is overridden by default route curve and curve
  /// provided when routing using Sailor's navigate method.
  final Curve? defaultTransitionCurve;

  /// Provide a custom transition to sailor instead of using
  /// inbuilt transitions, if not provided, sailor will revert
  /// to use its default transitions or delegate to system's own
  /// transitions.
  final CustomSailorTransition? customTransition;

  /// A navigator key lets Sailor grab the [NavigatorState] from a [MaterialApp]
  /// or a [CupertinoApp]. All navigation operations (push, pop, etc) are carried
  /// out using this [NavigatorState].
  ///
  /// This is the same [NavigatorState] that is returned by [Navigator.of(context)]
  /// (when there is only a single [Navigator] in Widget tree, i.e. from [MaterialApp]
  /// or [CupertinoApp]).
  final GlobalKey<NavigatorState>? navigatorKey;

  const SailorOptions({
    this.handleNameNotFoundUI = false,
    this.isLoggingEnabled = false,
    this.defaultTransitions,
    this.defaultTransitionDuration,
    this.defaultTransitionCurve,
    this.customTransition,
    this.navigatorKey,
  })  : assert(handleNameNotFoundUI != null),
        assert(isLoggingEnabled != null);
}
