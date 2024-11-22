import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  double _fontSize = 14.0; // Font size setting
  String _language = 'en'; // Language setting
  bool _privacyAccepted = false; // Privacy acceptance
  bool _syncEnabled = false; // Sync and backup setting

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _fontSize = prefs.getDouble('fontSize') ?? 14.0;
      _language = prefs.getString('language') ?? 'en';
      _privacyAccepted = prefs.getBool('privacyAccepted') ?? false;
      _syncEnabled = prefs.getBool('syncEnabled') ?? false;
    });
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setDouble('fontSize', _fontSize);
    await prefs.setString('language', _language);
    await prefs.setBool('privacyAccepted', _privacyAccepted);
    await prefs.setBool('syncEnabled', _syncEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Color(0xFF6563A5),
        iconTheme: IconThemeData(
          color: Colors.white, // Change back arrow color to white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Dark Mode Switch
            Row(
              children: [
                Icon(Icons.dark_mode), // 放置图标
                Expanded(
                  child: SwitchListTile(
                    title: Text(
                      '深色模式',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    value: _isDarkMode,
                    onChanged: (value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      _saveSettings();
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),
            // Notifications Switch
            Row(
              children: [
                Icon(Icons.notifications), // 放置图标
                Expanded(
                  child: SwitchListTile(
                    title: Text(
                      '允許通知',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    value: _notificationsEnabled,
                    onChanged: (value) {
                      setState(() {
                        _notificationsEnabled = value;
                      });
                      _saveSettings();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Privacy & Security Button
            TextButton(
              onPressed: () {
                setState(() {
                  _privacyAccepted = !_privacyAccepted;
                });
                _saveSettings();
              },
              child: Row(
                children: [
                  Icon(Icons.privacy_tip, color: Colors.black87),
                  SizedBox(width: 16),
                  Text(
                    '隱私與安全',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent, // Transparent background
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(height: 20),
            // Sync & Backup Button
            TextButton(
              onPressed: () {
                setState(() {
                  _syncEnabled = !_syncEnabled;
                });
                _saveSettings();
              },
              child: Row(
                children: [
                  Icon(Icons.sync, color: Colors.black87),
                  SizedBox(width: 16),
                  Text(
                    '資料同步與備份',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent, // Transparent background
                padding: const EdgeInsets.symmetric(vertical: 20),
                alignment: Alignment.centerLeft,
              ),
            ),
            SizedBox(height: 25),
            // Font Size Slider
            ListTile(
              leading: Icon(Icons.text_fields),
              title: Text(
                '調整文字大小: ${_fontSize.toStringAsFixed(1)}',
              ),
              subtitle: Slider(
                value: _fontSize,
                min: 10.0,
                max: 24.0,
                divisions: 14,
                label: _fontSize.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                  _saveSettings();
                },
              ),
            ),
            SizedBox(height: 10),
            // Language Dropdown
            ListTile(
              leading: Icon(Icons.language),
              title: Text('語言設定'),
              subtitle: DropdownButton<String>(
                value: _language,
                items: [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'zh', child: Text('繁體中文')),
                  DropdownMenuItem(value: 'jp', child: Text('日本語')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _language = newValue!;
                  });
                  _saveSettings();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
