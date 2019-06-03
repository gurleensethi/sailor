import 'package:sailor/src/transitions/transition_component.dart';

abstract class TransitionDecorator implements TransitionComponent {
  TransitionComponent transitionComponent;

  TransitionDecorator({this.transitionComponent});
}
