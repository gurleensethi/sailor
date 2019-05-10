import 'package:flutter/material.dart';
import 'package:compass/compass.dart';

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
      onGenerateRoute: Routes.compass.generator(),
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
            final response = await Routes.compass.navigate<bool>(
              context,
              "/secondPage",
              args: SecondPageArgs('Hey there'),
            );

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

class Fake extends BaseArguments {}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    final args = Compass.arguments<SecondPageArgs>(context);

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
  static final compass = Compass();

  static void createRoutes() {
    compass
      ..addRoute(CompassRoute(
        name: "/secondPage",
        builder: (context, args) {
          return SecondPage();
        },
      ));
  }
}
