
    import 'package:flutter/material.dart';
    import 'package:google_sign_in/google_sign_in.dart';
    import 'package:nemo_mobile/main.dart';
    import 'package:nemo_mobile/screens/home/main_screen.dart';
    import 'package:supabase_flutter/supabase_flutter.dart';
    import 'package:shared_preferences/shared_preferences.dart';

    class LoginScreen extends StatefulWidget {
      const LoginScreen({super.key});

      @override
      State<LoginScreen> createState() => _LoginScreenState();
    }

    class _LoginScreenState extends State<LoginScreen> {
      final _emailController = TextEditingController();
      final _passwordController = TextEditingController();
      bool _isPasswordVisible = false;
      bool _isLoading = false;

      @override
      void initState() {
        _setupAuthListener();
        super.initState();
      }

      @override
      void dispose() {
        _emailController.dispose();
        _passwordController.dispose();
        super.dispose();
      }

      void _setupAuthListener() {
        supabase.auth.onAuthStateChange.listen((data) async {
          final event = data.event;
          if (event == AuthChangeEvent.signedIn) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const MainScreen(),
              ),
            );
          }
        });
      }

      Future<void> _emailSignIn() async {
        if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email dan password harus diisi')),
          );
          return;
        }

        setState(() {
          _isLoading = true;
        });

        try {
          await supabase.auth.signInWithPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
        } catch (e) {
          debugPrint('Email Sign-In error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login gagal: $e')),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }

      Future<void> _googleSignIn() async {
        setState(() {
          _isLoading = true;
        });

        try {
          const webClientId = '875919720477-uubbvahve38uf4k81od5avf8im21d9n5.apps.googleusercontent.com';

          final GoogleSignIn googleSignIn = GoogleSignIn(
            serverClientId: webClientId,
          );
          final googleUser = await googleSignIn.signIn();

          if (googleUser == null) {
            throw 'Google sign-in aborted.';
          }

          final googleAuth = await googleUser.authentication;
          final accessToken = googleAuth.accessToken;
          final idToken = googleAuth.idToken;

          if (accessToken == null) {
            throw 'No Access Token found.';
          }
          if (idToken == null) {
            throw 'No ID Token found.';
          }

          await supabase.auth.signInWithIdToken(
            provider: OAuthProvider.google,
            idToken: idToken,
            accessToken: accessToken,
          );
        } catch (e) {
          debugPrint('Google Sign-In error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login gagal: $e')),
          );
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            leading: const BackButton(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: const Text(
              'Masuk',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Logo Nemo
                  Image.asset(
                    'lib/assets/images/logo_kesamping.png',
                    height: 80,
                  ),

                  const SizedBox(height: 24),

                  // Ilustrasi
                  Image.asset(
                    'lib/assets/images/masuk.png',
                    height: 200,
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "Selamat datang kembali!\nMasuk untuk melanjutkan petualangan.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Email
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tombol Masuk
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _emailSignIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF45B1F9),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Masuk',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'atau',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tombol Google Sign In
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _googleSignIn,
                      icon: Image.asset(
                        'lib/assets/images/google_logo.png',
                        height: 24,
                        width: 24,
                      ),
                      label: const Text(
                        'Masuk dengan Google',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: const BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
