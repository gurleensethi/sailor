import 'package:flutter/widgets.dart';

class SailorLoggingObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    print("[Sailor] Route Pushed: "
        "(New Route='${route?.settings?.name}', "
        "Previous Route='${previousRoute?.settings?.name}', "
        "Arguments=${route?.settings?.arguments}"
        ")");
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);

    print("[Sailor] Route Popped: "
        "(New Route='${route?.settings?.name}', "
        "Previous Route='${previousRoute?.settings?.name}', "
        "Arguments=${route?.settings?.arguments}"
        ")");
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    print("[Sailor] Route Replaced: "
        "(New Route='${newRoute?.settings?.name}', "
        "Old Route='${oldRoute?.settings?.name}', "
        "Arguments=${newRoute?.settings?.arguments}"
        ")");
  }
}
