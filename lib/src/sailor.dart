import 'package:sailor/src/errors/param_not_provided.dart';
import 'package:sailor/src/errors/param_not_registered.dart';
import 'package:sailor/src/errors/route_not_found.dart';
import 'package:flutter/material.dart';
import 'package:sailor/src/logger/app_logger.dart';
import 'package:sailor/src/models/arguments_wrapper.dart';
import 'package:sailor/src/models/base_arguments.dart';
import 'package:sailor/src/models/sailor_options.dart';
import 'package:sailor/src/models/sailor_param.dart';
import 'package:sailor/src/models/sailor_route.dart';
import 'package:sailor/src/navigator_observers/sailor_stack_observer.dart';
import 'package:sailor/src/transitions/sailor_transition.dart';
import 'package:sailor/src/transitions/transition_factory.dart';
import 'package:sailor/src/ui/page_not_found.dart';
import 'models/route_args_pair.dart';

enum NavigationType { push, pushReplace, pushAndRemoveUntil, popAndPushNamed }

/// Sailor manages routing, registering routes with transitions, navigating to
/// routes, closing routes. It is a thin layer on top of [Navigator] to help
/// you encapsulate and manage routing at one place.
class Sailor {
  Sailor({
    this.options = const SailorOptions(),
  }) : assert(options != null) {
    AppLogger.init(isLoggerEnabled: options.isLoggingEnabled);
  }

  /// Configuration options for [Sailor].
  ///
  /// Check out [SailorOptions] for available options.
  final SailorOptions options;

  /// Store all the mappings of route names and corresponding [SailorRoute]
  /// Used to generate routes
  Map<String, SailorRoute> _routeNameMappings = {};

  /// Store all the mappings of route names and corresponding [SailorParam]s
  Map<String, Map<String, SailorParam>> _routeParamsMappings = {};

  /// A navigator key lets Sailor grab the [NavigatorState] from a [MaterialApp]
  /// or a [CupertinoApp]. All navigation operations (push, pop, etc) are carried
  /// out using this [NavigatorState].
  ///
  /// This is the same [NavigatorState] that is returned by [Navigator.of(context)]
  /// (when there is only a single [Navigator] in Widget tree, i.e. from [MaterialApp]
  /// or [CupertinoApp]).
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  SailorStackObserver _navigationStackObserver = SailorStackObserver();

  SailorStackObserver get navigationStackObserver => _navigationStackObserver;

  /// Get the registered routes names as a list.
  List<String> getRegisteredRouteNames() {
    return _routeNameMappings.keys.toList();
  }

  /// Retrieves the arguments passed in when calling the [navigate] function.
  ///
  /// Returned arguments are casted with the type provided, the type will always
  /// be a subtype of [BaseArguments].
  ///
  /// Make sure to provide the appropriate type, that is, provide the same type
  /// as the one passed while calling [navigate], else a cast error will be
  /// thrown.
  static T args<T extends BaseArguments>(BuildContext context) {
    return (ModalRoute.of(context).settings.arguments as ArgumentsWrapper)
        .baseArguments as T;
  }

  static T param<T>(BuildContext context, String key) {
    final routeSettings = ModalRoute.of(context).settings;
    final argumentsWrapper = (routeSettings.arguments as ArgumentsWrapper);
<<<<<<< HEAD
    final isParamNotRegistered = argumentsWrapper.routeParams == null ||
        !argumentsWrapper.routeParams.containsKey(key);

    if (isParamNotRegistered) {
=======
    if (argumentsWrapper.routeParams == null ||
        !argumentsWrapper.routeParams.containsKey(key)) {
>>>>>>> Add functionality to pass paramters.
      throw ParamNotRegisteredError(
        paramKey: key,
        routeName: routeSettings.name,
      );
    }

<<<<<<< HEAD
    final defaultParamValue = argumentsWrapper.routeParams[key].defaultValue;
    final paramFromNavigationCall =
        argumentsWrapper.params != null ? argumentsWrapper.params[key] : null;
    return (paramFromNavigationCall ?? defaultParamValue) as T;
=======
    final sailorParam = argumentsWrapper.routeParams[key];
    final paramFromNavigationCall =
        argumentsWrapper.params != null ? argumentsWrapper.params[key] : null;
    return (paramFromNavigationCall ?? sailorParam.defaultValue) as T;
>>>>>>> Add functionality to pass paramters.
  }

  /// Add a new route to [Sailor].
  ///
  /// Route is stored in [_routeNameMappings].
  ///
  /// If a route is provided with a name that was previously added, it will
  /// override the old one.
  void addRoute(SailorRoute route) {
    assert(route != null, "'route' argument cannot be null.");

    if (_routeNameMappings.containsKey(route.name)) {
      AppLogger.instance.warning(
          "'${route.name}' has already been registered before. Overriding it!");
    }

    // Prepare route params
    final routeParams = <String, SailorParam>{};

    if (route.params != null) {
      route.params.forEach((sailorParam) {
        if (routeParams.containsKey(sailorParam.name)) {
          AppLogger.instance.warning(
              "'${sailorParam.name}' param has already been specified for route $route. Overriding it!");
        }

        routeParams[sailorParam.name] = sailorParam;
      });
    }

    _routeNameMappings[route.name] = route;
    _routeParamsMappings[route.name] = routeParams;
  }

  /// Add a list of routes at once.
  ///
  /// Calls [addRoute] for each route in the list.
  void addRoutes(List<SailorRoute> routes) {
    if (routes != null && routes.isNotEmpty) {
      routes.forEach((route) => this.addRoute(route));
    }
  }

  /// Makes this a callable class. Delegates to [navigate].
  Future<T> call<T>(
    String name, {
    BaseArguments args,
    NavigationType navigationType = NavigationType.push,
    dynamic result,
    bool Function(Route<dynamic> route) removeUntilPredicate,
    List<SailorTransition> transitions,
    Duration transitionDuration,
    Map<String, dynamic> params,
  }) {
    return navigate<T>(
      name,
      navigationType: navigationType,
      result: result,
      removeUntilPredicate: removeUntilPredicate,
      args: args,
      transitions: transitions,
      transitionDuration: transitionDuration,
      params: params,
    );
  }

  /// Function used to navigate pages.
  ///
  /// [name] is the route name that was registered using [addRoute].
  ///
  /// [args] are optional arguments that can be passed to the next page.
  /// To retrieve these arguments use [args] method on [Sailor].
  ///
  /// [navigationType] can be specified to choose from various navigation
  /// strategies such as [NavigationType.push], [NavigationType.pushReplace],
  /// [NavigationType.pushAndRemoveUntil].
  ///
  /// [removeUntilPredicate] should be provided if using
  /// [NavigationType.pushAndRemoveUntil] strategy.
  ///
  /// [transitions] is a list of transitions to be used when switching between
  /// pages. [transitionDuration] and [transitionCurve] are duration and curve
  /// used for these transitions.
  ///
  /// [params] are key pair values that can be passed when navigating to a route.
  Future<T> navigate<T>(
    String name, {
    BaseArguments args,
    NavigationType navigationType = NavigationType.push,
    dynamic result,
    bool Function(Route<dynamic> route) removeUntilPredicate,
    List<SailorTransition> transitions,
    Duration transitionDuration,
    Curve transitionCurve,
    Map<String, dynamic> params,
  }) {
    assert(name != null);
    assert(navigationType != null);
    assert(navigationType != NavigationType.pushAndRemoveUntil ||
        removeUntilPredicate != null);

    _checkAndThrowRouteNotFound(name, args, navigationType);

    return _navigate(
      name,
      args,
      navigationType,
      result,
      removeUntilPredicate,
      transitions,
      transitionDuration,
      transitionCurve,
      params,
    ).then((value) => value as T);
  }

  /// Push multiple routes at the same time.
  ///
  /// [routeArgsPairs] is a list of [RouteArgsPair]. Each [RouteArgsPair]
  /// contains the name of a route and its corresponding argument (if any).
  Future<List> navigateMultiple(
    List<RouteArgsPair> routeArgsPairs,
  ) {
    assert(routeArgsPairs != null);
    assert(routeArgsPairs.isNotEmpty);

    final pageResponses = <Future>[];

    // For each route check if it exists.
    // Push the route.
    routeArgsPairs.forEach((routeArgs) {
      _checkAndThrowRouteNotFound(
        routeArgs.name,
        routeArgs.args,
        // TODO(gurleensethi): Give user the ability to use any type of NavigationType
        NavigationType.push,
      );

      final response = _navigate(
        routeArgs.name,
        routeArgs.args,
        // TODO(gurleensethi): Give user the ability to use any type of NavigationType
        NavigationType.push,
        null,
        null,
        routeArgs.transitions,
        routeArgs.transitionDuration,
        routeArgs.transitionCurve,
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
  ///
  /// [transitions] is a list of transitions to be used when switching between
  /// pages. [transitionDuration] and [transitionCurve] are duration and curve
  /// used for these transitions.
  ///
  /// [params] are key pair values that can be passed when navigating to a route.
  Future<dynamic> _navigate(
    String name,
    BaseArguments args,
    NavigationType navigationType,
    dynamic result,
    bool Function(Route<dynamic> route) removeUntilPredicate,
    List<SailorTransition> transitions,
    Duration transitionDuration,
    Curve transitionCurve,
    Map<String, dynamic> params,
  ) {
    // Check if all the required parameters are provided
    final routeParams = _routeParamsMappings[name];
    if (routeParams != null) {
      routeParams.forEach((key, value) {
<<<<<<< HEAD
        bool isMissingRequiredParam = value.isRequired &&
            (params == null || !params.containsKey(value.name));

        if (isMissingRequiredParam) {
          AppLogger.instance.warning(ParameterNotProvidedError(
            paramKey: value.name,
            routeName: name,
          ).toString());
=======
        if (value.isRequired &&
            (params == null || !params.containsKey(value.name))) {
          print("WARNING: " +
              ParameterNotProvidedError(
                paramKey: value.name,
                routeName: name,
              ).toString());
>>>>>>> Add functionality to pass paramters.
        }
      });
    }

    final argsWrapper = ArgumentsWrapper(
      baseArguments: args,
      transitions: transitions,
      transitionDuration: transitionDuration,
      transitionCurve: transitionCurve,
      params: params,
      routeParams: _routeParamsMappings[name],
    );

    switch (navigationType) {
      case NavigationType.push:
        {
          return this
              .navigatorKey
              .currentState
              .pushNamed(name, arguments: argsWrapper);
        }
      case NavigationType.pushReplace:
        {
          return this.navigatorKey.currentState.pushReplacementNamed(name,
              result: result, arguments: argsWrapper);
        }
      case NavigationType.pushAndRemoveUntil:
        {
          return this.navigatorKey.currentState.pushNamedAndRemoveUntil(
              name, removeUntilPredicate,
              arguments: argsWrapper);
        }
      case NavigationType.popAndPushNamed:
        {
          return this
              .navigatorKey
              .currentState
              .popAndPushNamed(name, result: result, arguments: argsWrapper);
        }
    }

    return null;
  }

  /// If the route is not registered throw an error
  /// Make sure to use the correct name while calling navigate.
  void _checkAndThrowRouteNotFound(
    String name,
    BaseArguments args,
    NavigationType navigationType,
  ) {
    assert(name != null);

    if (!_routeNameMappings.containsKey(name)) {
      if (this.options.handleNameNotFoundUI) {
        this.navigatorKey.currentState.push(
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
  bool pop([dynamic result]) {
    return this.navigatorKey.currentState.pop(result);
  }

  /// Delegation for [Navigator.popUntil].
  void popUntil(void Function(Route<dynamic>) predicate) {
    this.navigatorKey.currentState.popUntil(predicate);
  }

  /// Generates the [RouteFactory] which builds a [Route] on request.
  ///
  /// These routes are built using the [SailorRoute]s provided using
  /// [addRoute] method.
  RouteFactory generator() {
    return (settings) {
      final route = _routeNameMappings[settings.name];

      if (route == null) return null;

      // TODO(gurleensethi): Check if this is a sailor route or a normal route.
      ArgumentsWrapper argsWrapper = settings.arguments as ArgumentsWrapper;

      // If for some reason the arguments passed themself are null.
      if (argsWrapper == null) {
        argsWrapper = ArgumentsWrapper();
      }

      final baseArgs = argsWrapper.baseArguments;

      // Select which transitions to use.
      // Priority:
      //   1. Transitions provided when route is called.
      //   2. Default transitions when route was registered.
      //   3. Default transition from SailorOptions.
      final List<SailorTransition> transitions = [];

      if (argsWrapper.transitions != null &&
          argsWrapper.transitions.isNotEmpty) {
        transitions.addAll(argsWrapper.transitions);
      } else if (route.defaultTransitions != null &&
          route.defaultTransitions.isNotEmpty) {
        transitions.addAll(route.defaultTransitions);
      } else if (this.options.defaultTransitions != null) {
        transitions.addAll(this.options.defaultTransitions);
      }

      final transitionDuration = argsWrapper.transitionDuration ??
          route.defaultTransitionDuration ??
          this.options.defaultTransitionDuration;

      final transitionCurve = argsWrapper.transitionCurve ??
          route.defaultTransitionCurve ??
          this.options.defaultTransitionCurve;

      RouteSettings routeSettings = RouteSettings(
        name: settings.name,
        isInitialRoute: settings.isInitialRoute,
        arguments: argsWrapper.copyWith(
          baseArguments: baseArgs != null ? baseArgs : route.defaultArgs,
        ),
      );

      return TransitionFactory.buildTransition(
        transitions: transitions,
        duration: transitionDuration,
        curve: transitionCurve,
        settings: routeSettings,
        builder: (context) => route.builder(
          context,
          baseArgs ?? route.defaultArgs,
          ParamMap(
            route.name,
            argsWrapper.routeParams,
            argsWrapper.params,
          ),
        ),
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

class ParamMap {
  final String _routeName;
  final Map<String, SailorParam> _routeParams;
  final Map<String, dynamic> _params;

  ParamMap(this._routeName, this._routeParams, this._params);

  T param<T>(String key) {
    final isParamNotRegistered =
        _routeParams == null || !_routeParams.containsKey(key);

    if (isParamNotRegistered) {
      throw ParamNotRegisteredError(
        paramKey: key,
        routeName: this._routeName,
      );
    }

    final defaultParamValue = _routeParams[key].defaultValue;
    final paramFromNavigationCall = _params != null ? _params[key] : null;
    return (paramFromNavigationCall ?? defaultParamValue) as T;
  }
}
