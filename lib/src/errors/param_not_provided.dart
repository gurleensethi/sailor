// import 'package:meta/meta.dart';

class ParameterNotProvidedError extends Error {
  final String paramKey;
  final String routeName;

  ParameterNotProvidedError({
    required this.routeName,
    required this.paramKey,
  });

  @override
  String toString() {
    return "Param '$paramKey' is required for '$routeName', it should be provided while navigating to this route.";
  }
}
