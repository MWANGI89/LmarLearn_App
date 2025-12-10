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

      if (!mounted) return;

      if (userData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
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

      Navigator.pushReplacementNamed(
        context,
        route,
        arguments: {'loggedUser': appUser},
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email first')),
      );
      return;
    }

    setState(() => _loading = true);
    try {
      await _authService.sendPasswordResetEmail(email: email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    double buttonWidth = size.width * 0.8; // Set button width to 80% of screen width
    double buttonHeight = isMobile ? 50.0 : 60.0; // Adjust height based on screen size
    double fontSize = isMobile ? 16.0 : 18.0; // Adjust font size based on screen size

    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent.shade400, Colors.lightBlue.shade200],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Center the form and adjust size
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Card(
                elevation: 16,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/logo/Lmar_Logo_icon-nobg.png',
                        height: 60,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: isMobile ? 24 : 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Login to continue to your dashboard',
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter email' : null,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.lock),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              obscureText: true,
                              validator: (val) =>
                                  val!.isEmpty ? 'Enter password' : null,
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _forgotPassword,
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: buttonWidth, // Set dynamic width
                              height: buttonHeight, // Set dynamic height
                              child: _loading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(fontSize: fontSize), // Set dynamic font size
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),

                      // Back Button Below the Login Button
                      const SizedBox(height: 20),

                      SizedBox(
                        width: buttonWidth, // Set dynamic width
                        height: buttonHeight, // Set dynamic height
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Back Home',
                            style: TextStyle(fontSize: fontSize), // Set dynamic font size
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Don’t have an account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/sign-up');
                            },
                            child: const Text('Sign Up'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
