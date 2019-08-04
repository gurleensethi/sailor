import 'package:flutter/material.dart';
import 'package:sailor/sailor.dart';

void main() async {
  Routes.createRoutes();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compass Example',
      home: Home(),
      onGenerateRoute: Routes.sailor.generator(),
      navigatorKey: Routes.sailor.navigatorKey,
      navigatorObservers: [
        SailorLoggingObserver(),
        Routes.sailor.navigationStackObserver,
      ],
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              child: Text('Open Second Page'),
              onPressed: () async {
                final response = await Routes.sailor
                    .navigate<bool>("/secondPage", transitions: [
                  SailorTransition.slide_from_top,
                ], params: {
                  'id': 123,
                });

                print("Response from SecondPage: $response");
              },
            ),
            RaisedButton(
              child: Text('Open Multi Page (Second and Third)'),
              onPressed: () async {
                final responses = await Routes.sailor.navigateMultiple([
                  RouteArgsPair(
                    "/secondPage",
                    args: SecondPageArgs("Multi Page!"),
                  ),
                  RouteArgsPair(
                    "/thirdPage",
                    args: ThirdPageArgs(10),
                  ),
                  RouteArgsPair("/pushReplacePage"),
                ]);

                print("Second Page Response ${responses[0]}");
                print("Third Page Response ${responses[1]}");
                print("Third Page Response ${responses[2]}");
              },
            ),
            RaisedButton(
              child: Text('Push Replace Page'),
              onPressed: () async {
                Routes.sailor.navigate("/pushReplacePage");
              },
            ),
            RaisedButton(
              child: Text('Print navigation stack!'),
              onPressed: () {
                Routes.sailor.navigationStackObserver.prettyPrintStack();
              },
            ),
            RaisedButton(
              child: Text('Push Replace Page'),
              onPressed: () async {
                Routes.sailor.navigate("/pushReplacePage");
              },
            ),
            RaisedButton(
              child: Text('Push Replace Page'),
              onPressed: () async {
                Routes.sailor.navigate("/pushReplacePage");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPageArgs extends BaseArguments {
  final String text;

  SecondPageArgs(this.text) : assert(text != null);
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Sailor.args<SecondPageArgs>(context);
    final id = Sailor.param<int>(context, 'id');

    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(args?.text ?? 'Second Page'),
            Text("Param('id'): $id"),
            RaisedButton(
              child: Text('Close Page'),
              onPressed: () {
                Routes.sailor.pop(true);
              },
            ),
            RaisedButton(
              child: Text('Print navigation stack!'),
              onPressed: () {
                Routes.sailor.navigationStackObserver.prettyPrintStack();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ThirdPageArgs extends BaseArguments {
  final int count;

  ThirdPageArgs(this.count);
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Sailor.args<ThirdPageArgs>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Third Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Count from args is :${args?.count}"),
            RaisedButton(
              child: Text('Close Page'),
              onPressed: () {
                Routes.sailor.pop(10);
              },
            ),
            RaisedButton(
              child: Text('Print navigation stack!'),
              onPressed: () {
                Routes.sailor.navigationStackObserver.prettyPrintStack();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PushReplacePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RaisedButton(
              child: Text('Push Replace'),
              onPressed: () {
                Routes.sailor.navigate(
                  "/secondPage",
                  navigationType: NavigationType.pushReplace,
                );
              },
            ),
            RaisedButton(
              child: Text('Push Unitl First and Replace'),
              onPressed: () {
                Routes.sailor.navigate(
                  "/thirdPage",
                  navigationType: NavigationType.pushAndRemoveUntil,
                  removeUntilPredicate: (route) => route.isFirst,
                );
              },
            ),
            RaisedButton(
              child: Text('Print navigation stack!'),
              onPressed: () {
                Routes.sailor.navigationStackObserver.prettyPrintStack();
              },
            ),
            Text(Routes.sailor.navigationStackObserver
                .getRouteStack()[0]
                .toString())
          ],
        ),
      ),
    );
  }
}

class Routes {
  static final sailor = Sailor(
    options: SailorOptions(
      handleNameNotFoundUI: true,
      isLoggingEnabled: true,
      defaultTransitions: [
        SailorTransition.slide_from_bottom,
        SailorTransition.zoom_in,
      ],
      defaultTransitionCurve: Curves.decelerate,
      defaultTransitionDuration: Duration(milliseconds: 500),
    ),
  );

  static void createRoutes() {
    sailor.addRoutes([
      SailorRoute(
        name: "/secondPage",
        builder: (context, args, params) => SecondPage(),
        defaultArgs: SecondPageArgs('From default arguments!'),
        params: [
          SailorParam(
            name: 'id',
            defaultValue: 1234,
          ),
        ],
        defaultTransitions: [
          SailorTransition.slide_from_bottom,
          SailorTransition.zoom_in,
        ],
      ),
      SailorRoute(
        name: "/thirdPage",
<<<<<<< HEAD
        builder: (context, args, params) => ThirdPage(),
=======
        builder: (context, args) => ThirdPage(),
>>>>>>> Remove context requirement by using MaterialApp/CupertinoApp's navigator.
        defaultTransitions: [SailorTransition.slide_from_left],
      ),
      SailorRoute(
        name: "/pushReplacePage",
        builder: (context, args, params) => PushReplacePage(),
      ),
    ]);
  }
}
