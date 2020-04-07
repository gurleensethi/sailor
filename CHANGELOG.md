## [0.7.0] - 7 April 2020

- Fix Sailor API's to be compatible with latest Flutter API's.
- `Breaking Change`: `Sailor.pop` returns `void` instead of `bool`.

## [0.6.0] - 14 November 2019

- Route Guards: Prevent routes from being opened based on a condition.
- More type checking for `SailorParams`: `SailorParams<T>` now accept a generic type `T`, of the type of paramter that is required to be passed. When opening a route, `runtimeType` of the passed value is compred to the `T` passed when declaring `SailorParam<T>`.
- Provider `navigationKey`: An external `navigatorKey` can be provided to sailor using `SailorOptions`.

## [0.5.0] - 20 September 2019

- Add support for providing your own custom transitions.

## [0.4.0] - 3 September 2019

- Add support for passing parameters when navigating route.

## [0.3.0] - August 2019

- **BREAKING CHANGE**: `Sailor.arguments` method is removed and replaced with `Sailor.args`.

## [0.3.0] - 19 August 2019

- `SailorStackObserver` lets you get the current stack of routes.
- Fix`crashing while retrieving`arguments`when using`NavigationType.pushAndRemoveUntil`.
- Refactor logs in `SailorLoggingObserver`.

## [0.2.0] - 4 August 2019

- **BREAKING CHANGE**: `Sailor` now uses a `navigatorKey` to carry out all navigation operations, there is no need of passing `context` any more in any of sailor's instance methods. Make sure to add Sailor's `navigatorKey` in your `MaterialApp` or `CupertinoApp`.

## [0.1.0] - 2 August 2019

## [0.0.5] - 2 August 2019

- Inbuilt page transitions.

## [0.0.4] - 18 May 2019

- Launch multiple routes at the same time using `navigateMultiple`.
- Ability to add default arguments when registering routes with `addRoute`.
