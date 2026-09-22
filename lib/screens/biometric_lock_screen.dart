import 'package:flutter/material.dart';
import '../services/biometric_service.dart';

class BiometricLockScreen extends StatefulWidget {
  final Widget child;

  const BiometricLockScreen({super.key, required this.child});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> {
  final BiometricService _biometricService = BiometricService();
  
  bool _isLocked = false;
  bool _isAuthenticating = false;

  Future<void> _authenticateAndUnlock() async {
    setState(() => _isAuthenticating = true);

    final authenticated = await _biometricService.authenticate();

    if (mounted) {
      setState(() {
        _isAuthenticating = false;
        if (authenticated) {
          _isLocked = false;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Biometric authentication unavailable or canceled. Use bypass below for testing.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    }
  }

  void _lockVault() {
    setState(() {
      _isLocked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocked) {
      return Stack(
        children: [
          widget.child,
          Positioned(
            top: 40,
            right: 60,
            child: FloatingActionButton.small(
              heroTag: 'lock_btn',
              tooltip: 'Lock Vault',
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              onPressed: _lockVault,
              child: const Icon(Icons.lock),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 80,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 24),
              const Text(
                'Vault Locked',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Authenticate with your biometric or passcode to unlock your private journal.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isAuthenticating ? null : _authenticateAndUnlock,
                icon: const Icon(Icons.fingerprint),
                label: Text(_isAuthenticating ? 'Authenticating...' : 'Unlock Vault'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  setState(() => _isLocked = false);
                },
                child: const Text('Bypass / Unlock Vault'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}