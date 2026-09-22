import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLockScreen extends StatefulWidget {
  final Widget child;

  const BiometricLockScreen({super.key, required this.child});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen>
    with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _isAuthenticated = false;
  bool _isAuthenticating = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _authenticate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      setState(() {
        _isAuthenticated = false;
        _errorMessage = '';
      });
    } else if (state == AppLifecycleState.resumed && !_isAuthenticated && !_isAuthenticating) {
      _authenticate();
    }
  }

  Future<void> _authenticate() async {
    if (_isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
      _errorMessage = '';
    });

    // Web / Unsupported platforms check
    if (kIsWeb) {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
          _errorMessage = 'Biometric authentication is only supported on mobile devices (Android/iOS).';
        });
      }
      return;
    }

    try {
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      final bool isDeviceSupported = await _auth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        if (mounted) {
          setState(() {
            _isAuthenticating = false;
            _errorMessage = 'Biometric or PIN security is not enabled on this device.';
          });
        }
        return;
      }

      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: 'Authenticate with Fingerprint, Face ID, or PIN to unlock vault',
      );

      if (mounted) {
        setState(() {
          _isAuthenticated = didAuthenticate;
          _isAuthenticating = false;
          if (!didAuthenticate) {
            _errorMessage = 'Authentication failed or canceled.';
          }
        });
      }
    } on MissingPluginException {
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isAuthenticating = false;
          _errorMessage = 'Biometrics not supported on this platform/browser.';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAuthenticated = false;
          _isAuthenticating = false;
          _errorMessage = 'Authentication error: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return widget.child;
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.security, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 24),
              const Text(
                'Biometric Vault Locked',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Authentication required to view private journal entries.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 13),
                ),
              ],
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isAuthenticating ? null : _authenticate,
                icon: _isAuthenticating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.fingerprint),
                label: Text(_isAuthenticating ? 'Authenticating...' : 'Unlock Vault'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}