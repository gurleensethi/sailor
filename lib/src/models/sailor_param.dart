class SailorParam<T> {
  final String? name;
  final T? defaultValue;
  final bool? isRequired;
  final Type paramType;

  SailorParam({
    required this.name,
    this.defaultValue,
    this.isRequired = false,
  })  : assert(name != null),
        assert(isRequired != null),
        paramType = T;

  @override
  operator ==(Object other) =>
      identical(other, this) || other is SailorParam && other.name == this.name;

  @override
  int get hashCode => name.hashCode;
}
