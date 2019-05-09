import 'package:compass/compass.dart';
import 'package:flutter/material.dart';

class Compass {
  /// Store all the mappings of route names and corresponding CompassRoute
  /// Used to generate routes
  Map<String, CompassRoute> _routeNameMappings = {};

  static T arguments<T extends BaseArguments>(BuildContext context) {
    return ModalRoute.of(context).settings.arguments as T;
  }

  void addRoute(CompassRoute route) {
    _routeNameMappings[route.name] = route;
  }

  void navigate(
    BuildContext context,
    String name, {
    BaseArguments args,
  }) {
    assert(context != null);
    assert(name != null);
    Navigator.of(context).pushNamed(name, arguments: args);
  }

  RouteFactory generator() {
    return (settings) {
      print("Requested Path: ${settings.name}");
      print(settings.arguments);

      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return _routeNameMappings[settings.name]
              .builder(context, settings.arguments);
        },
      );
    };
  }
}
