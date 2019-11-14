import 'package:flutter/material.dart';
import 'package:sailor/sailor.dart';
import 'package:sailor/src/models/base_arguments.dart';
import 'package:sailor/src/sailor.dart';

typedef RouteGuard = Future<bool> Function(
  BuildContext context,
  BaseArguments args,
  ParamMap paramMap,
);

abstract class SailorRouteGuard {
  SailorRouteGuard();

  Future<bool> canOpen(
    BuildContext context,
    BaseArguments args,
    ParamMap paramMap,
  );

  factory SailorRouteGuard.simple(RouteGuard canOpen) {
    return _SimpleRouteGuard(canOpen);
  }
}

class _SimpleRouteGuard extends SailorRouteGuard {
  final RouteGuard routeGuard;

  _SimpleRouteGuard(this.routeGuard) : super();

  @override
  Future<bool> canOpen(
    BuildContext context,
    BaseArguments args,
    ParamMap paramMap,
  ) {
    return this.routeGuard(context, args, paramMap);
  }
}
