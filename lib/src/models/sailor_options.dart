class SailorOptions {
  final bool handlePageNotFound;

  const SailorOptions({
    this.handlePageNotFound = false,
  }) : assert(handlePageNotFound != null);
}
