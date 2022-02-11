import 'package:sailor/src/transitions/transition_component.dart';

/// Decorator interface for transition decorator pattern.
/// All transition decorators must implement this interface.
abstract class TransitionDecorator implements TransitionComponent {
  TransitionComponent? transitionComponent;

  TransitionDecorator({this.transitionComponent});
}
