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
  /// These transitions are overriden by default route transitions and
  /// transitions provided when routing using Sailor's route method.
  final List<SailorTransition> defaultTransitions;

  const SailorOptions({
    this.handleNameNotFoundUI = false,
    this.isLoggingEnabled = false,
    this.defaultTransitions,
  })  : assert(handleNameNotFoundUI != null),
        assert(isLoggingEnabled != null);
}
