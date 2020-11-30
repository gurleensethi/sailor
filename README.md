# sailor

![anchor_image](https://raw.githubusercontent.com/gurleensethi/sailor/master/images/anchor-icon.png)

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
[![pub_package](https://img.shields.io/pub/vpre/sailor.svg)](https://pub.dev/packages/sailor)

A Flutter package for easy navigation management.

#### Warning: Package is still under development, there might be breaking changes in future.

## Index

- [Setup and Usage](#setup-and-usage)
- [Passing Parameters](#passing-parameters)
- [Passing Arguments](#passing-arguments)
- [Route Guards (Experimental)](#route-guards-experimental)
- [Transitions](#transitions)
- [Pushing Multiple Routes](#pushing-multiple-routes)
- [Log Navigation](#log-navigation)
- [Support](#support)

## Setup and Usage

1. Create an instance of `Sailor` and add routes.

```dart
// Routes class is created by you.
class Routes {
  static final sailor = Sailor();

  static void createRoutes() {
    sailor.addRoute(SailorRoute(
        name: "/secondPage",
        builder: (context, args, params) {
          return SecondPage();
        },
      ));
  }
}
```

2. Register the routes in `onGenerateRoute` using the `generate` function of `Sailor` and also `Sailor`'s `navigatorKey`.

```dart
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sailor Example',
      home: Home(),
      navigatorKey: Routes.sailor.navigatorKey,  // important
      onGenerateRoute: Routes.sailor.generator(),  // important
    );
  }
}
```

3. Make sure to create routes before starting the application.

```dart
void main() async {
  Routes.createRoutes();
  runApp(App());
}
```

4. Use the instance of `Sailor` to navigate.

```dart
Routes.sailor.navigate("/secondPage");
```

- TIP: `Sailor` is a callable class, so you can omit `navigate` and directly call the method.

```dart
Routes.sailor("/secondPage");
```

## Passing Parameters

`Sailor` allows you to pass parameters to the page that you are navigating to.

- Before passing the parameter itself, you need to declare it while declaring your route. Let's declare a parameter named `id` that has a default value of `1234`.

```dart
sailor.addRoutes([
  SailorRoute(
    name: "/secondPage",
    builder: (context, args, params) => SecondPage(),
    params: [
      SailorParam<int>(
        name: 'id',
        defaultValue: 1234,
      ),
    ],
  ),
);
```

- Pass the actual parameter when navigating to the new route.

```dart
Routes.sailor.navigate<bool>("/secondPage", params: {
  'id': 4321,
});
```

- Parameters can be retrieved from two places, first, the route builder and second, the opened page itself.

**Route Builder:**

```dart
sailor.addRoutes([
  SailorRoute(
    name: "/secondPage",
    builder: (context, args, params) {
      // Getting a param
      final id = params.param<int>('id');
      return SecondPage();
    },
    params: [
      SailorParam(
        name: 'id',
        defaultValue: 1234,
      ),
    ],
  ),
);
```

**Opened page:**

```dart
class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final id = Sailor.param<int>(context, 'id');

    ...

  }
}
```

Make sure to specify the type of paramter when declaring `SailorParam<T>`. This type is used to make sure when the route is being opened, it is passed the correct param type. Right now `Sailor` logs a warning if the type of declared and passed param is not same. In future version this might throw an error.

## Passing Arguments

`Sailor` allows you to pass arguments to the page that you are navigating to.

- Create a class that extends from `BaseArguments`.

```dart
class SecondPageArgs extends BaseArguments {
  final String text;

  SecondPageArgs(this.text);
}
```

- When calling the `navigate` method pass these arguments.

```dart
final response = Routes.sailor.navigate(
  "/secondPage",
  args: SecondPageArgs('Hey there'),
);
```

- When in the SecondPage, use `Sailor.args` to get the passed arguments.

```dart
class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args = Sailor.args<SecondPageArgs>(context);

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

## Route Guards (Experimental)

Routes can be protected from being opened when `navigate` is called using `route guard`.

A route guard can be added when declaring a `SailorRoute`.

```dart
sailor.addRoutes([
  SailorRoute(
    name: "/secondPage",
    builder: (context, args, params) => SecondPage(),
    routeGuards: [
      SailorRouteGuard.simple((context, args, params) async {
        // Can open logic goes here.
        if (sharedPreferences.getToken() != null) {
          return true;
        }
        return false;
      }),
    ],
  ),
);
```

`routeGuards` takes an array of `SailorRouteGuard`.

There are two ways to create a route guard:

- Using `SailorRouteGuard.simple`, as shown above.
```dart
SailorRouteGuard.simple((context, args, params) async {
  // Can open logic goes here.
  if (sharedPreferences.getToken() != null) {
    return true;
  }
  return false;
});
```
- Extending `SailorRouteGuard` class.
```dart
class CustomRouteGuard extends SailorRouteGuard {
  @override
  Future<bool> canOpen(
    BuildContext context,
    BaseArguments args,
    ParamMap paramMap,
  ) async {
    return false;
  }
}
```

The result from each rotue guard is `Future<bool>`. If the value returned __by each route__ is `true` the route is accepted and opened, anything else will result in route being rejected and not being opened.

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
  "/secondPage",
  transitions: [SailorTransition.fade_in],
);
```

More than one transition can be provided when navigating a single route. These transitions are composed on top of each other, so in some cases changing the order will change the animation.

```dart
Routes.sailor.navigate(
  "/secondPage",
  transitions: [
    SailorTransition.fade_in,
    SailorTransition.slide_from_right,
  ],
  transitionDuration: Duration(milliseconds: 500),
  transitionCurve: Curves.bounceOut,
);
```

`Duration` and `Curve` can be provided using `transitionDuration` and `transitionCurve` respectively.

```dart
Routes.sailor.navigate(
  "/secondPage",
  transitions: [
    SailorTransition.fade_in,
    SailorTransition.slide_from_right,
  ],
  transitionDuration: Duration(milliseconds: 500),
  transitionCurve: Curves.bounceOut,
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
  defaultTransitionCurve: Curves.decelerate,
  defaultTransitionDuration: Duration(milliseconds: 500),
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
  defaultTransitionCurve: Curves.decelerate,
  defaultTransitionDuration: Duration(milliseconds: 500),
)
```

Priority: Transitions provided while adding a route or when navigating using `navigate`, will override these transitions.

### Custom Transitions

Although `sailor` provides you with a number of out of the box transitions, you can still provide your own custom transitions.

- To create a custom transition, extend the class `CustomSailorTransition` and implement `buildTransition` method.

```dart
class MyCustomTransition extends CustomSailorTransition {
  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
```

This transition can now be provided at 3 places:

- While calling `navigate`.

```dart
Routes.sailor.navigate<bool>(
  "/secondPage",
  customTransition: MyCustomTransition(),
);
```

- When declaring a `SailorRoute`.

```dart
SailorRoute(
  name: "/secondPage",
  builder: (context, args, params) => SecondPage(),
  customTransition: MyCustomTransition(),
),
```

- In `SailorOptions`:

```dart
static final sailor = Sailor(
  options: SailorOptions(
    customTransition: MyCustomTransition(),
  ),
);
```

#### Custom Transition Priority

_NOTE: Custom transitions have the highest priority, if you provide a custom transition, they will be used over Sailor's inbuilt transitions._

The same priority rules apply to custom transitions as inbuilt sailor transitions, with the added rule that at any step if both transitions are provided (i.e. Sailor's inbuilt transitions and a CustomSailorTransition), the custom transition will be used over inbuilt one.

For example, in the below code, `MyCustomTransition` will be used instead of `SailorTransition.slide_from_top`.

```dart
Routes.sailor.navigate<bool>(
  "/secondPage",
  transitions: [
    SailorTransition.slide_from_top,
  ],
  customTransition: MyCustomTransition(),
);
```

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

## Remove routes and clean navigation

If you want navigate and remove other routes (for example, the login route), use the methods `navigationType` and `removeUntilPredicate`.
For remove all routes in navigator:
```
Routes.sailor.navigate<bool>(
  "/secondPage",
  navigationType: NavigationType.pushAndRemoveUntil,
  removeUntilPredicate: (route) {
    return false;
  },
);
```

## Support

If you face any issue or want a new feature to be added to the package, please [create an issue](https://github.com/gurleensethi/sailor/issues/new).
I will be more than happy to resolve your queries.
