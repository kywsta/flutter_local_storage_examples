import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TokenStorageScreen());
  }
}

class TokenStorageScreen extends StatefulWidget {
  const TokenStorageScreen({super.key});

  @override
  State<TokenStorageScreen> createState() => _TokenStorageScreenState();
}

class _TokenStorageScreenState extends State<TokenStorageScreen> {
  final _tokenController = TextEditingController();

  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Secure Storage Sample')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Center(child: Text('Token: $_token'))),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _tokenController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Enter text to save"),
                ),
              ),
            ),
            Column(
              children: [
                TextButton(
                  onPressed: _saveToken,
                  child: const Text('Save Token'),
                ),
                TextButton(
                  onPressed: _loadToken,
                  child: const Text('Load Token'),
                ),
                TextButton(
                  onPressed: _clearToken,
                  child: const Text('Clear Token'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveToken() async {
    await TokenStorage.saveTokens(_tokenController.text);
    setState(() {
      _token = "Token changed, please reload";
    });
  }

  void _loadToken() async {
    final token = await TokenStorage.getToken();
    setState(() {
      _token = token;
    });
  }

  void _clearToken() async {
    await TokenStorage.clear();
    setState(() {
      _token = null;
    });
  }
}

class TokenStorage {
  static const String _tokenKey = 'auth_token';

  // Save authentication tokens
  static Future<void> saveTokens(String token) async {
    await SecureStorageService.saveSecureData(_tokenKey, token);
  }

  // Get authentication token
  static Future<String?> getToken() async {
    return await SecureStorageService.getSecureData(_tokenKey);
  }

  // Logout (clear tokens)
  static Future<void> clear() async {
    await SecureStorageService.deleteSecureData(_tokenKey);
  }
}

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Save secure data
  static Future<void> saveSecureData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  // Retrieve secure data
  static Future<String?> getSecureData(String key) async {
    return await _storage.read(key: key);
  }

  // Delete secure data
  static Future<void> deleteSecureData(String key) async {
    await _storage.delete(key: key);
  }

  // Clear all secure data
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Check if key exists
  static Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }
}
