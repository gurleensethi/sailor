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
        title: Text('Compass Example'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open New Page'),
          onPressed: () async {
            final response = await Routes.sailor.navigate<bool>(
                context, "/secondPage",
                args: SecondPageArgs('Args From First Page'));

            print("Response from SecondPage: $response");
          },
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
    final args = Sailor.arguments<SecondPageArgs>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Compass Example'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(args?.text ?? 'Second Page'),
            RaisedButton(
              child: Text('Close Page'),
              onPressed: () {
                Navigator.of(context).pop(true);
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
    ),
  );

  static void createRoutes() {
    sailor
      ..addRoute(SailorRoute(
        name: "/secondPage",
        builder: (context, args) {
          return SecondPage();
        },
      ));
  }
}
