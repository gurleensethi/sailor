class SailorParam {
  final String name;
  final dynamic defaultValue;
  final bool isRequired;

  SailorParam({
    this.name,
    this.defaultValue,
    this.isRequired = false,
  }) : assert(isRequired != null);

  @override
  operator ==(Object other) =>
      identical(other, this) || other is SailorParam && other.name == this.name;

  @override
  int get hashCode => name.hashCode;
}
