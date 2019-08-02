class SailorOptions {
  final bool handleNameNotFoundUI;
  final bool isLoggingEnabled;

  const SailorOptions({
    this.handleNameNotFoundUI = false,
    this.isLoggingEnabled = false,
  })  : assert(handleNameNotFoundUI != null),
        assert(isLoggingEnabled != null);
}
