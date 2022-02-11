import 'dart:collection';
import 'package:flutter/widgets.dart';
import 'package:sailor/src/logger/app_logger.dart';

/// Experimental! might be removed or changed.
class SailorStackObserver extends NavigatorObserver {
  final NavigatorState? navigatorState;
  final List<Route?> _routeStack = [];

  SailorStackObserver({
    this.navigatorState,
  });

  @override
  void didPop(Route route, Route? previousRoute) {
    _routeStack.removeLast();
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _routeStack.add(route);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    int oldIndex = _routeStack.indexOf(oldRoute);
    _routeStack.removeAt(oldIndex);
    _routeStack.insert(oldIndex, newRoute);
  }

  @override
  void didRemove(Route removedRoute, Route? previousRoute) {
    _routeStack.removeWhere((route) => route == removedRoute);
  }

  /// Returns the list of [Route]s represented as a stack of routes currently
  /// push by Navigator.
  ///
  /// Head and tail of list are bottom and top of stack respectively.
  UnmodifiableListView<Route?> getRouteStack() {
    final stack = this._routeStack.reversed.toList();
    return UnmodifiableListView(stack);
  }

  /// Returns the list of route names represented as a stack of routes currently
  /// push by Navigator.
  ///
  /// Head and tail of list are bottom and top of stack respectively.
  UnmodifiableListView<String?> getRouteNameStack() {
    final stack =
        this._routeStack.reversed.map((route) => route!.settings.name).toList();
    return UnmodifiableListView(stack);
  }

  void prettyPrintStack() {
    if (!AppLogger.instance!.isLoggerEnabled!) {
      print("`AppLogger` should be enabled to print any Sailor logs.");
    }

    if (this._routeStack.isEmpty) {
      AppLogger.instance!.info("Navigation stack is empty!");
    } else {
      String printableStack = _routeStack.fold("", (prevValue, route) {
        return "$prevValue ${route!.isFirst ? "" : "--->"} ${route.settings.name}";
      });

      AppLogger.instance!.info("Navigation Stack: " + printableStack);
    }
  }
}
