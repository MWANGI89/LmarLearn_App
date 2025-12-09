import 'package:flutter/material.dart';
import '../../models/app_user.dart';
import 'auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      final userData = await _authService.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userData == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User not found')));
        return;
      }

      final role = (userData['role'] ?? '').toString().toLowerCase();

      final appUser = AppUser(
        id: userData['id'] ?? '',
        name: userData['name'] ?? '',
        email: userData['email'] ?? '',
        role: role,
        schoolId: userData['schoolId'] ?? '',
      );

      // Navigate to dashboard based on role
      String route;
      switch (role) {
        case 'student':
          route = '/student-dashboard';
          break;
        case 'lecturer':
          route = '/lecturer-dashboard';
          break;
        case 'admin':
          route = '/admin-dashboard';
          break;
        case 'superadmin':
          route = '/superadmin-dashboard';
          break;
        default:
          route = '/home';
      }

      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        route,
        arguments: {'loggedUser': appUser},
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (val) => val!.isEmpty ? 'Enter email' : null,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (val) => val!.isEmpty ? 'Enter password' : null,
              ),
              const SizedBox(height: 24),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48)),
                      child: const Text('Login'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
