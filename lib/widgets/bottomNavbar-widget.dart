import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:curiosityclash/main-page/shop-page.dart';
import 'package:curiosityclash/main-page/train-page.dart';
import 'package:curiosityclash/main-page/profile-page.dart';
import 'package:curiosityclash/theme.dart';

class BottomNavBar extends StatefulWidget {
  final String? sessionId;

  const BottomNavBar({super.key, this.sessionId});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 1; // Default index to ProfilePage
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      ShopPage(sessionId: widget.sessionId),
      TrainPage(sessionId: widget.sessionId),
      Profilepage(sessionId: widget.sessionId),
    ];
  }

  // Method to navigate programmatically to Profile tab
  void goToProfile() {
    setState(() {
      _currentIndex = 2; // Switch to Profile tab (index 2)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        color: AppTheme.lightTheme.colorScheme.surface,
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(context, Icons.shop, "Shop", 0),
            const SizedBox(width: 5),
            _buildNavItem(context, MdiIcons.brain, "Train", 1),
            const SizedBox(width: 5),
            _buildNavItem(context, Icons.person, "Profile", 2),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, String label, int index) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
        // print('Navigated to $label with sessionId: ${widget.sessionId}');
      },
      child: Container(
        height: 70,
        width: 80,
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.darkTheme.colorScheme.surface
              : AppTheme.darkTheme.colorScheme.surface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.surface
                  : AppTheme.darkTheme.colorScheme.surface.withOpacity(0.6),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.surface
                    : AppTheme.darkTheme.colorScheme.surface.withOpacity(0.6),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
