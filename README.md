# sailor
![anchor_image](https://raw.githubusercontent.com/gurleensethi/sailor/master/images/anchor-icon.png)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
[![pub_package](https://img.shields.io/pub/vpre/sailor.svg)](https://pub.dev/packages/sailor)

A Flutter package for easy navigation management.

#### Warning: Package is still under development, there might be breaking changes in future.

## Roadmap
- [x] Core Navigation Features.
- [x] Proper logging when navigating.
- [x] Basic Transitions.
- [ ] More Transitions.
- [ ] Pretty printing navigation stack.

## Index
- [Usage](#usage)
- [Passing Arguments](#passing-arguments)
- [Transitions](#transitions)
- [Pushing Multiple Routes](#pushing-multiple-routes)

## Usage

* Create an instance of `Sailor` and add routes.

```dart
// Routes class is created by you.
class Routes {
  static final sailor = Sailor();

  static void createRoutes() {
    sailor.addRoute(SailorRoute(
        name: "/secondPage",
        builder: (context, args) {
          return SecondPage();
        },
      ));
  }
}
```

* Make sure to create routes before starting the application.

```dart
void main() async {
  Routes.createRoutes();
  runApp(App());
}
```

* Register the routes in `onGenerateRoute` using the `generate` function of `Sailor`.

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compass Example',
      home: Home(),
      onGenerateRoute: Routes.sailor.generator(),
    );
  }
}
```

* Use the instance of `Sailor` to navigate.

```dart
Routes.sailor.navigate(context, "/secondPage");
```

* TIP: `Sailor` is a callable class, so you can omit `navigate` and directly call the method.

```dart
Routes.sailor(context, "/secondPage");
```

## Passing Arguments
`Sailor` allows you to pass arguments to the page that you are navigating to.

* Create a class that extends from `BaseArguments`.

```dart
class SecondPageArgs extends BaseArguments {
  final String text;

  SecondPageArgs(this.text);
}
```

* When calling the `navigate` method pass these arguments.

```dart

final response = Routes.sailor.navigate(
  context,
  "/secondPage",
  args: SecondPageArgs('Hey there'),
);
```

* When in the SecondPage, use `Sailor.arguments` to get the passed arguments.

```dart
class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Sailor.arguments<SecondPageArgs>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Compass Example'),
      ),
      body: Center(
        child: Text(args.text),
      ),
    );
  }
}
```

## Transitions
Sailor has inbuilt support for page transitions. A transition is specified using `SailorTransition`.

Transition can be specified at 3 levels (ordered in priority from highest to lowest):

- When Navigating (using `Sailor.navigate`).
- While adding routes (`SailorRoute`).
- Global transitions (`SailorOptions`).

### When navigating
Specify which transitions to use when calling the `navigate` method.

```dart
Routes.sailor.navigate(
  context,
  "/secondPage",
  transitions: [SailorTransition.fade_in],
);
```

More than one transition can be provided when navigating a single route. These transitions are composed on top of each other, so in some cases changing the order will change the animation.

```dart
Routes.sailor.navigate(
  context,
  "/secondPage",
  transitions: [
    SailorTransition.fade_in,
    SailorTransition.slide_from_right,
  ],
);
```

In the above example the page will slide in from right with a fade in animation. You can specify as many transitions as you want.

### When adding routes
You can specify the default transition for a route, so you don't have to specify it again and again when navigating.

```dart
sailor.addRoute(SailorRoute(
  name: "/secondPage",
  defaultTransitions: [
    SailorTransition.slide_from_bottom,
    SailorTransition.zoom_in,
  ],
  builder: (context, args) => SecondPage(),
));
```

Priority: Transitions provided in `Sailor.navigate` while navigating to this route, will override these transitions.

### Global transitions
You can specify default transition to be used for all routes in `Sailor`.

```dart
SailorOptions(
  defaultTransitions: [
    SailorTransition.slide_from_bottom,
    SailorTransition.zoom_in,
  ],
)
```

Priority: Transitions provided while adding a route or when navigating using `navigate`, will override these transitions.

## Pushing Multiple Routes

Sailor allows you to push multiple pages at the same time and get collected response from all.

```dart
final responses = await Routes.sailor.navigateMultiple(context, [
  RouteArgsPair("/secondPage", SecondPageArgs("Multi Page!")),
  RouteArgsPair("/thirdPage", ThirdPageArgs(10)),
]);

print("Second Page Response ${responses[0]}");
print("Third Page Response ${responses[1]}");
```

## Log Navigation
Use `SailorLoggingObserver` to log the `push`/`pop` navigation inside the application.
Add the `SailorLoggingObserver` to the `navigatorObservers` list inside your `MaterialApp`.

```dart
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
```

Once added, start navigating in your app and check the logs. You will see something like this.
```
flutter: [Sailor] Route Pushed: (Pushed Route='/', Previous Route='null', New Route Args=null, Previous Route Args=null)
flutter: [Sailor] Route Pushed: (Pushed Route='/secondPage', Previous Route='/', New Route Args=Instance of 'SecondPageArgs', Previous Route Args=null)
flutter: [Sailor] Route Popped: (New Route='/', Popped Route='/secondPage', New Route Args=null, Previous Route Args=Instance of 'SecondPageArgs')
```

## Support
If you face any issue or want a new feature to be added to the package, please [create an issue](https://github.com/gurleensethi/sailor/issues/new).
I will be more than happy to resolve your queries.