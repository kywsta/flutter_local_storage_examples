import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SettingsScreen());
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  void _loadPreferences() {
    setState(() {
      _isDarkMode = PreferencesService.getBool('isDarkMode') ?? false;
    });
    debugPrint('isDarkMode: $_isDarkMode');
  }

  void _savePreferences() {
    debugPrint('savePreferences: isDarkMode: $_isDarkMode');
    PreferencesService.saveBool('isDarkMode', _isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Column(
        children: [
          SwitchListTile(
            title: Text('Dark Mode'),
            value: _isDarkMode,
            onChanged: (value) {
              setState(() {
                _isDarkMode = value;
              });
              _savePreferences();
            },
          ),
          Expanded(
            child: Center(
              child: CardTheme(
                data: CardThemeData(
                  color: _isDarkMode
                      ? ThemeData.dark().colorScheme.surfaceContainer
                      : ThemeData.light().colorScheme.surfaceContainer,
                ),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _isDarkMode ? "Dark Mode" : "Light Mode",
                      style: TextStyle(
                        color: _isDarkMode
                            ? ThemeData.dark().colorScheme.onSurface
                            : ThemeData.light().colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Additional settings widgets...
        ],
      ),
    );
  }
}

class PreferencesService {
  static SharedPreferences? _preferences;

  // Initialize SharedPreferences
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Save data
  static Future<void> saveString(String key, String value) async {
    await _preferences?.setString(key, value);
  }

  static Future<void> saveInt(String key, int value) async {
    await _preferences?.setInt(key, value);
  }

  static Future<void> saveBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  // Retrieve data
  static String? getString(String key) {
    return _preferences?.getString(key);
  }

  static int? getInt(String key) {
    return _preferences?.getInt(key);
  }

  static bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  // Remove data
  static Future<void> remove(String key) async {
    await _preferences?.remove(key);
  }

  // Clear all data
  static Future<void> clear() async {
    await _preferences?.clear();
  }
}
