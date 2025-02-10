import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hungrx_app/core/constants/colors/app_colors.dart';

class RootLayout extends StatefulWidget {
  final Widget child;

  const RootLayout({
    super.key,
    required this.child,
  });

  @override
  State<RootLayout> createState() => _RootLayoutState();
}

class _RootLayoutState extends State<RootLayout> {
  DateTime? lastBackPressTime;

  Future<bool> _onWillPop() async {
    final location = GoRouterState.of(context).uri.toString();
    
    if (location == '/home') {
      final now = DateTime.now();
      if (lastBackPressTime == null || 
          now.difference(lastBackPressTime!) > const Duration(seconds: 2)) {
        lastBackPressTime = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Press back again to exit'),
            duration: Duration(seconds: 2),
          ),
        );
        return false;
      }
      return true;
    }
    
    if (!context.mounted) return false;
    context.go('/home');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          final shouldPop = await _onWillPop();
          if (shouldPop) {
            SystemNavigator.pop();
          }
        }
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: _BottomNavigationBarWidget(
          currentLocation: GoRouterState.of(context).uri.toString(),
        ),
      ),
    );
  }
}

class _BottomNavigationBarWidget extends StatelessWidget {
  final String currentLocation;

  const _BottomNavigationBarWidget({
    required this.currentLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.tileColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'Eat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
          ],
          currentIndex: _calculateSelectedIndex(currentLocation),
          selectedItemColor: AppColors.buttonColors,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          onTap: (index) => _onItemTapped(index, context),
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      ),
    );
  }

  int _calculateSelectedIndex(String location) {
    if (location == '/home') return 0;
    if (location == '/eatscreen') return 1;
    if (location == '/profile') return 2;
    if (location == '/foodcart') return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    HapticFeedback.mediumImpact();
    
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/eatscreen');
        break;
      case 2:
        context.go('/profile');
        break;
      case 3:
        context.go('/foodcart');
        break;
    }
    
  }
}