import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service that handles data of the secure storage for the app.
class SecureStorageService {
  /// Instance of the secure storage service.
  static final SecureStorageService _instance = SecureStorageService._();

  /// Instance of the secure storage plugin to access the data from the
  /// secure storage.
  final _storage = const FlutterSecureStorage();

  /// Key under which the app key is persisted.
  static const String appKeyStorageKey = 'appKey';

  /// Key under which the client id is persisted.
  static const String clientIdStorageKey = 'clientId';

  /// Key under which the client secret is persisted.
  static const String clientSecretStorageKey = 'clientSecret';

  /// Key under which the private rsa key is stored.
  static const String rsaPrivateStorageKey = 'rsaPrivate';

  /// Key under which the servername is persisted.
  static const String serverNameStorageKey = 'serverName';

  /// Key under which the access token is persisted.
  static const String accessTokenStorageKey = 'a';

  /// Private constructor of the service.
  SecureStorageService._();

  /// Returns the singleton instance of the [SecureStorageService].
  static SecureStorageService getInstance() {
    return _instance;
  }

  /// Returns the value persisted under the given [key].
  Future<String?> get(String key) async {
    return await _storage.read(key: key);
  }

  /// Returns a boolean, that indicates whether a value is persisted under
  /// the given [key] or not.
  Future<bool> has(String key) async {
    return (await get(key)) != null;
  }

  /// Stores the [value] under the given [key].
  Future<void> set(String key, String? value) async {
    return await _storage.write(key: key, value: value);
  }

  /// Deletes the value under the given [key] from the secure storage.
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}
