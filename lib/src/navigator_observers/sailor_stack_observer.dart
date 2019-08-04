import 'package:flutter/widgets.dart';
import 'package:sailor/src/logger/app_logger.dart';

class SailorStackObserver extends NavigatorObserver {
  final NavigatorState navigatorState;
  final List<Route> _routeStack = [];

  SailorStackObserver({
    this.navigatorState,
  });

  @override
  void didPop(Route route, Route previousRoute) {
    _routeStack.removeLast();
  }

  @override
  void didPush(Route route, Route previousRoute) {
    _routeStack.add(route);
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    int oldIndex = _routeStack.indexOf(oldRoute);
    _routeStack.removeAt(oldIndex);
    _routeStack.insert(oldIndex, newRoute);
  }

  @override
  void didRemove(Route removedRoute, Route previousRoute) {
    _routeStack.removeWhere((route) => route == removedRoute);
  }

  void prettyPrintStack() {
    if (this._routeStack.isEmpty) {
      AppLogger.instance.info("Navigation stack is empty!");
    } else {
      String printableStack = _routeStack.fold("", (prevValue, route) {
        return "$prevValue ${route.isFirst ? "" : "--->"} ${route.settings.name}";
      });

      AppLogger.instance.info("Navigation Stack: " + printableStack);
    }
  }
}
