import 'package:sailor/sailor.dart';

class SailorOptions {
  final bool handleNameNotFoundUI;
  final bool isLoggingEnabled;

  /// Default transitions for all the routes.
  final List<SailorTransition> defaultTransitions;

  const SailorOptions({
    this.handleNameNotFoundUI = false,
    this.isLoggingEnabled = false,
    this.defaultTransitions,
  })  : assert(handleNameNotFoundUI != null),
        assert(isLoggingEnabled != null);
}
