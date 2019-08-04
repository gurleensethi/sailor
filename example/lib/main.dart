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
                final response = await Routes.sailor.navigate<bool>(
                  "/secondPage",
                  transitions: [
                    SailorTransition.slide_from_top,
                  ],
                );

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
                ]);

                print("Second Page Response ${responses[0]}");
                print("Third Page Response ${responses[1]}");
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(args?.text ?? 'Second Page'),
            RaisedButton(
              child: Text('Close Page'),
              onPressed: () {
                Routes.sailor.pop(true);
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
        builder: (context, args) => SecondPage(),
        defaultArgs: SecondPageArgs('From default arguments!'),
        defaultTransitions: [
          SailorTransition.slide_from_bottom,
          SailorTransition.zoom_in,
        ],
      ),
      SailorRoute(
        name: "/thirdPage",
        builder: (context, args) => ThirdPage(),
        defaultTransitions: [SailorTransition.slide_from_left],
      ),
      SailorRoute(
        name: "/pushReplacePage",
        builder: (context, args) => PushReplacePage(),
      ),
    ]);
  }
}
