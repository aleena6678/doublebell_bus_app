import 'package:flutter/material.dart';

class SettingsToggle extends StatefulWidget {
  final String title;
  final bool defaultValue;

  static final Map<String, _SettingsToggleState> _instances = {};

  SettingsToggle({super.key, required this.title, required this.defaultValue});

  static void resetAllSettings() {
    for (var instance in _instances.values) {
      instance.resetToDefault();
    }
  }

  @override
  _SettingsToggleState createState() {
    final state = _SettingsToggleState();
    _instances[title] = state;
    return state;
  }
}

class _SettingsToggleState extends State<SettingsToggle> {
  late bool isToggled;

  @override
  void initState() {
    super.initState();
    isToggled = widget.defaultValue;
  }

  void resetToDefault() {
    setState(() {
      isToggled = widget.defaultValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.title, style: const TextStyle(fontSize: 16)),
      trailing: Switch(
        value: isToggled,
        onChanged: (value) {
          setState(() {
            isToggled = value;
          });
        },
        activeColor: Colors.green,
      ),
    );
  }
}
