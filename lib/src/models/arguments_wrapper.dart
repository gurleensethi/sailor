import 'package:sailor/sailor.dart';
import 'package:sailor/src/transitions/sailor_transition.dart';

class ArgumentsWrapper {
  final BaseArguments baseArguments;
  final List<SailorTransition> transitions;

  ArgumentsWrapper({
    this.baseArguments,
    this.transitions,
  });
}
