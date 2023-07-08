import 'package:flutter/material.dart';

const Color _customColor = Color(0xFF5C11D4);

const List<Color> _colorThemes = [
  _customColor,
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
];

class AppTheme {
  final int selectedColor;
  final bool dark;

  AppTheme({
    this.selectedColor = 0,
    this.dark = false
  })
      : assert(selectedColor >= 0 && selectedColor <= _colorThemes.length - 1,
            'Colros must be between 0 and ${_colorThemes.length - 1}');

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      brightness: (dark) ?  Brightness.dark : null ,
      colorSchemeSeed: _colorThemes[selectedColor],
    );
  }
}
