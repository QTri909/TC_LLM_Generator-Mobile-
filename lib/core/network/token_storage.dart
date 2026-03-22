/// A simple static holder for the current user's access token.
/// Set once on login, cleared on logout. Used by all API data sources.
class TokenStorage {
  static String? _accessToken;

  static void setToken(String token) {
    _accessToken = token;
  }

  static String? getToken() => _accessToken;

  static void clearToken() {
    _accessToken = null;
  }

  static Map<String, String> get authHeaders {
    final token = _accessToken;
    if (token == null || token.isEmpty)
      return {'Content-Type': 'application/json'};
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}
