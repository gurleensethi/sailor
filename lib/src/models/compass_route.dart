import 'package:compass/src/models/base_arguments.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

typedef CompassRouteBuilder = Widget Function(
    BuildContext context, BaseArguments args);

class CompassRoute {
  final String name;
  final CompassRouteBuilder builder;

  CompassRoute({
    @required this.name,
    @required this.builder,
  })  : assert(name != null),
        assert(builder != null);
}
