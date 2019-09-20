## [0.5.0] - 20 September 2019

* Add support for providing your own custom transitions.

## [0.4.0] - 3 September 2019

* Add support for passing parameters when navigating route.

## [0.3.0] - August 2019
* **BREAKING CHANGE**: `Sailor.arguments` method is removed and replaced with `Sailor.args`.

## [0.3.0] - 19 August 2019

* `SailorStackObserver` lets you get the current stack of routes.
* Fix` crashing while retrieving `arguments` when using `NavigationType.pushAndRemoveUntil`.
* Refactor logs in `SailorLoggingObserver`.

## [0.2.0] - 4 August 2019

* **BREAKING CHANGE**: `Sailor` now uses a `navigatorKey` to carry out all navigation operations, there is no need of passing `context` any more in any of sailor's instance methods. Make sure to add Sailor's `navigatorKey` in your `MaterialApp` or `CupertinoApp`.

## [0.1.0] - 2 August 2019

## [0.0.5] - 2 August 2019

* Inbuilt page transitions.


## [0.0.4] - 18 May 2019

* Launch multiple routes at the same time using `navigateMultiple`.
* Ability to add default arguments when registering routes with `addRoute`.
