class ImposterPacksFailure implements Exception {
  const ImposterPacksFailure({required this.message, this.code});

  final String message;
  final String? code;

  @override
  String toString() => code == null ? message : '$message [$code]';
}
