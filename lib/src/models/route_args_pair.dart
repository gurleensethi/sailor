import 'package:sailor/sailor.dart';

class RouteArgsPair {
  final String name;
  final BaseArguments args;
  final List<SailorTransition> transitions;

  RouteArgsPair(this.name, this.args, {this.transitions});
}
