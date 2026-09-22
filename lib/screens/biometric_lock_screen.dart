import 'package:flutter/material.dart';
import '../services/biometric_service.dart';
import '../services/auth_service.dart';

class BiometricLockScreen extends StatefulWidget {
  final Widget child; // The main app content to unlock

  const BiometricLockScreen({super.key, required this.child});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> {
  final BiometricService _biometricService = BiometricService();
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _authenticateUser();
  }

  Future<void> _authenticateUser() async {
    final canCheck = await _biometricService.canCheckBiometrics();
    if (!canCheck) {
      // If hardware isn't available/enrolled, unlock by default or fallback
      setState(() => _isAuthenticated = true);
      return;
    }

    final success = await _biometricService.authenticate();
    if (mounted) {
      setState(() => _isAuthenticated = success);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return widget.child;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80, color: Colors.deepPurple),
            const SizedBox(height: 16),
            const Text(
              'Vault Locked',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _authenticateUser,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Unlock with Biometrics'),
            ),
            TextButton(
              onPressed: () async {
                await _authService.signOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}