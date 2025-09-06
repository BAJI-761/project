import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'farmer/farmer_home.dart';
import 'retailer/retailer_home.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (authService.isAuthenticated) {
          // User is logged in, show appropriate home screen
          switch (authService.userType) {
            case 'farmer':
              return FarmerHome();
            case 'retailer':
              return RetailerHome();
            default:
              // Fallback to login screen if user type is not set
              return LoginScreen();
          }
        } else {
          // User is not logged in, show login screen
          return LoginScreen();
        }
      },
    );
  }
}
