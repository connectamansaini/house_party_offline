abstract interface class AuthTokenProvider {
  Future<String?> getToken();
}

class EmptyAuthTokenProvider implements AuthTokenProvider {
  const EmptyAuthTokenProvider();

  @override
  Future<String?> getToken() async => null;
}
