import 'package:sailor/src/models/base_arguments.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

typedef SailorRouteBuilder = Widget Function(
    BuildContext context, BaseArguments args);

class SailorRoute {
  final String name;
  final SailorRouteBuilder builder;

  SailorRoute({
    @required this.name,
    @required this.builder,
  })  : assert(name != null),
        assert(builder != null);
}
