import 'package:compass/compass.dart';
import 'package:compass/src/errors/route_not_found.dart';
import 'package:flutter/material.dart';

class Compass {
  /// Store all the mappings of route names and corresponding CompassRoute
  /// Used to generate routes
  Map<String, CompassRoute> _routeNameMappings = {};

  /// Retrieves the arguments passed in when calling the [navigate] function.
  ///
  /// Returned arguments are casted with the type provided, the type will always
  /// be a subtype of [BaseArguments].
  ///
  /// Make sure to provide the appropriate type, that is, provide the same type
  /// as the one passed while calling [navigate], else a cast error will be
  /// thrown.
  static T arguments<T extends BaseArguments>(BuildContext context) {
    return ModalRoute.of(context).settings.arguments as T;
  }

  /// Add a new route to [Compass].
  ///
  /// Route is stored in [_routeNameMappings].
  ///
  /// If a route is provided with a name that was previously added, it will
  /// override the old one.
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

    // If the route is not registered throw an error
    // Make sure to use the correct name while calling navigate.
    if (!_routeNameMappings.containsKey(name)) {
      throw RouteNotFoundError(name: name);
    }

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
