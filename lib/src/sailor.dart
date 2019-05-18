import 'package:sailor/src/errors/route_not_found.dart';
import 'package:flutter/material.dart';
import 'package:sailor/src/models/base_arguments.dart';
import 'package:sailor/src/models/sailor_options.dart';
import 'package:sailor/src/models/sailor_route.dart';
import 'package:sailor/src/ui/page_not_found.dart';

import 'models/route_args_pair.dart';

enum NavigationType { push, pushReplace, pushAndRemoveUntil, popAndPushNamed }

class Sailor {
  /// Configuration options for [Sailor].
  ///
  /// Check out [SailorOptions] for available options.
  final SailorOptions options;

  /// Store all the mappings of route names and corresponding CompassRoute
  /// Used to generate routes
  Map<String, SailorRoute> _routeNameMappings = {};

  Sailor({
    this.options = const SailorOptions(),
  }) : assert(options != null);

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

  /// Add a new route to [Sailor].
  ///
  /// Route is stored in [_routeNameMappings].
  ///
  /// If a route is provided with a name that was previously added, it will
  /// override the old one.
  void addRoute(SailorRoute route) {
    _routeNameMappings[route.name] = route;
  }

  Future<T> call<T>(
    BuildContext context,
    String name, {
    BaseArguments args,
    NavigationType navigationType = NavigationType.push,
    dynamic result,
    bool Function(Route<dynamic> route) removeUntilPredicate,
  }) {
    return navigate<T>(
      context,
      name,
      navigationType: navigationType,
      result: result,
      removeUntilPredicate: removeUntilPredicate,
      args: args,
    );
  }

  /// Function used to navigate pages.
  ///
  /// [name] is the route name that was registered using [addRoute].
  ///
  /// [args] are optional arguments that can be passed to the next page.
  /// To retrieve these arguments use [arguments] method on [Sailor].
  ///
  /// [navigationType] can be specified to choose from various navigation
  /// strategies such as [NavigationType.push], [NavigationType.pushReplace],
  /// [NavigationType.pushAndRemoveUntil].
  ///
  /// [removeUntilPredicate] should be provided is using
  /// [NavigationType.pushAndRemoveUntil] strategy.
  Future<T> navigate<T>(
    BuildContext context,
    String name, {
    BaseArguments args,
    NavigationType navigationType = NavigationType.push,
    dynamic result,
    bool Function(Route<dynamic> route) removeUntilPredicate,
  }) {
    assert(context != null);
    assert(name != null);
    assert(navigationType != null);
    assert(navigationType != NavigationType.pushAndRemoveUntil ||
        removeUntilPredicate != null);

    _checkAndThrowRouteNotFound(context, name, args, navigationType);

    return _navigate(
      context,
      name,
      args,
      navigationType,
      result,
      removeUntilPredicate,
    ).then((value) => value as T);
  }

  /// Push multiple routes at the same time.
  ///
  /// [routeArgsPairs] is a list of [RouteArgsPair]. Each [RouteArgsPair]
  /// contains the name of a route and its corresponding argument (if any).
  Future<List> navigateMultiple(
    BuildContext context,
    List<RouteArgsPair> routeArgsPairs,
  ) {
    assert(context != null);
    assert(routeArgsPairs != null);
    assert(routeArgsPairs.isNotEmpty);

    final pageResponses = <Future>[];

    // For each route check if it exists.
    // Push the route.
    routeArgsPairs.forEach((routeArgs) {
      _checkAndThrowRouteNotFound(
        context,
        routeArgs.name,
        routeArgs.args,
        // TODO(gurleensethi): Give user the ability to use any type of NavigationType
        NavigationType.push,
      );

      final response = _navigate(
        context,
        routeArgs.name,
        routeArgs.args,
        // TODO(gurleensethi): Give user the ability to use any type of NavigationType
        NavigationType.push,
        null,
        null,
      );

      pageResponses.add(response);
    });

    return Future.wait(pageResponses);
  }

  /// Actual navigation is delegated by [navigate] method to this method.
  ///
  /// [name] is the route name that was registered using [addRoute].
  ///
  /// [args] are optional arguments that can be passed to the next page.
  /// To retrieve these arguments use [arguments] method on [Sailor].
  ///
  /// [navigationType] can be specified to choose from various navigation
  /// strategies such as [NavigationType.push], [NavigationType.pushReplace],
  /// [NavigationType.pushAndRemoveUntil].
  ///
  /// [removeUntilPredicate] should be provided is using
  /// [NavigationType.pushAndRemoveUntil] strategy.
  Future<dynamic> _navigate(
    BuildContext context,
    String name,
    BaseArguments args,
    NavigationType navigationType,
    dynamic result,
    bool Function(Route<dynamic> route) removeUntilPredicate,
  ) {
    switch (navigationType) {
      case NavigationType.push:
        {
          return Navigator.of(context).pushNamed(name, arguments: args);
        }
      case NavigationType.pushReplace:
        {
          return Navigator.of(context).pushReplacementNamed(
            name,
            result: result,
            arguments: args,
          );
        }
      case NavigationType.pushAndRemoveUntil:
        {
          return Navigator.of(context).pushNamedAndRemoveUntil(
            name,
            removeUntilPredicate,
            arguments: args,
          );
        }
      case NavigationType.popAndPushNamed:
        {
          return Navigator.of(context).popAndPushNamed(
            name,
            arguments: args,
            result: result,
          );
        }
    }

    return null;
  }

  /// If the route is not registered throw an error
  /// Make sure to use the correct name while calling navigate.
  void _checkAndThrowRouteNotFound(
    BuildContext context,
    String name,
    BaseArguments args,
    NavigationType navigationType,
  ) {
    assert(context != null);
    assert(name != null);

    if (!_routeNameMappings.containsKey(name)) {
      if (this.options.handleNameNotFoundUI) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) {
            return PageNotFound(
              routeName: name,
              args: args,
              navigationType: navigationType,
            );
          }),
        );
      }
      throw RouteNotFoundError(name: name);
    }
  }

  /// Delegation for [Navigator.pop].
  bool pop(BuildContext context, {dynamic result}) {
    return Navigator.of(context).pop(result);
  }

  /// Generates the [RouteFactory] which builds a [Route] on request.
  ///
  /// These routes are built using the [CompassRoute]s provided using
  /// [addRoute] method.
  RouteFactory generator() {
    return (settings) {
      final route = _routeNameMappings[settings.name];

      if (route == null) return null;

      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return route.builder(context, settings.arguments);
        },
      );
    };
  }

  static RouteFactory unknownRouteGenerator() {
    return (settings) {
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) {
          return PageNotFound(
            routeName: settings.name,
            args: settings.arguments,
          );
        },
      );
    };
  }
}
