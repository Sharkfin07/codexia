import 'package:codexia/presentation/widgets/global/logo.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../theme/app_palette.dart';

class MainNavBar extends StatelessWidget {
  const MainNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppPalette.darkSecondary,
      padding: const EdgeInsets.all(8.0),
      child: GNav(
        rippleColor: Colors.grey[300]!,
        hoverColor: Colors.grey[100]!,
        gap: 8,
        activeColor: AppPalette.lightPrimary,
        iconSize: 24,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        duration: Duration(milliseconds: 400),
        tabBackgroundColor: AppPalette.darkPrimary,
        tabActiveBorder: Border.all(color: AppPalette.lightPrimary),
        color: Colors.white,
        tabs: [
          GButton(
            icon: Icons.access_alarm_outlined,
            leading: LogoRegular(width: 30),
            text: 'Home',
          ),
          GButton(icon: Icons.heart_broken_outlined, text: 'Likes'),
          GButton(icon: Icons.thumb_down_alt_outlined, text: 'Search'),
          GButton(icon: Icons.person_2_outlined, text: 'Profile'),
        ],
      ),
    );
  }
}
