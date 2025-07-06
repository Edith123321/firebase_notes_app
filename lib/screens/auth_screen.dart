import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

import '../services/auth_service.dart';
import 'landing_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _showMessage(String message, {bool isError = false}) async {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final User? user = _isLogin
          ? await _auth.signIn(email, password)
          : await _auth.signUp(email, password);

      if (user != null && mounted) {
        await _showMessage(_isLogin ? 'Login successful!' : 'Account created!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LandingScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        await _showMessage('Authentication failed: ${e.toString()}', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleAuthMode() {
    if (_isLoading) return;
    setState(() => _isLogin = !_isLogin);
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLogin ? 'Welcome Back' : 'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 40),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 30),
                _buildAuthButton(),
                _buildToggleAuthButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      validator: (value) =>
          (value == null || value.isEmpty) ? 'Enter an email' : null,
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(labelText: 'Password'),
      obscureText: true,
      validator: (value) =>
          (value == null || value.length < 6) ? 'Password too short' : null,
    );
  }

  Widget _buildAuthButton() {
    return _isLoading
        ? const CircularProgressIndicator()
        : ElevatedButton(
            onPressed: _submit,
            child: Text(_isLogin ? 'Login' : 'Sign Up'),
          );
  }

  Widget _buildToggleAuthButton() {
    return TextButton(
      onPressed: _toggleAuthMode,
      child: Text(
        _isLogin ? 'Create new account' : 'Already have an account? Login',
      ),
    );
  }
}
