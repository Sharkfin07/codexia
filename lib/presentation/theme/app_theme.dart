import 'package:flutter/material.dart';
import './app_palette.dart';

/*
 * Palettes: 
 * Light Primary: #FFFDFE
 * Light Secondary: #FFE9F2
 * Dark Primary: #10082D
 * Dark Secondary: #180161
 * Light Pink: #FFCCE4
 * Dark Pink: #EB3678
 */

class AppTheme {
  static ThemeData lightTheme() =>
      ThemeData(useMaterial3: true, brightness: Brightness.light);

  static ThemeData darkTheme() =>
      ThemeData(useMaterial3: true, brightness: Brightness.dark);
}
