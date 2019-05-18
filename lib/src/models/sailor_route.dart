import 'package:sailor/src/models/base_arguments.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

typedef SailorRouteBuilder = Widget Function(
    BuildContext context, BaseArguments args);

class SailorRoute {
  final String name;
  final SailorRouteBuilder builder;
  final BaseArguments defaultArgs;

  SailorRoute({
    @required this.name,
    @required this.builder,
    this.defaultArgs,
  })  : assert(name != null),
        assert(builder != null);
}
