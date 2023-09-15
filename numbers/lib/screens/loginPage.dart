import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:numbers/screens/signupPage.dart';
import 'package:flutter/material.dart';
import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (res != 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
          )
      );
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          )));
    }
  }

  Future<void> sendPasswordResetEmail() async {
    if(_emailController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please enter your email to reset your password."),
          )
      );
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset email sent'),
          )
      );
    } catch (e) {
      print(e);  // Print the error message if there's an error
    }
  }


  @override
  Widget build(BuildContext context) {
    dynamic Dheight = MediaQuery.of(context).size.height;
    dynamic Dwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              // Wave shape at the top
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: Dheight * 0.2,
                  color: Colors.green.shade200,
                ),
              ),
              // Login form
              Container(
                margin: EdgeInsets.only(top: Dheight * 0.16),
                padding: EdgeInsets.all(Dheight * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    const Text(
                        "Numbers",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico',
                      )
                    ),
                    SizedBox(
                      height: Dheight * 0.06,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Welcome Back. ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Log In!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dheight * 0.03),
                    // Email field
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade900, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Password field
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade900, width: 2.0),
                        ),
                      ),
                    ),
                    SizedBox(height: Dheight * 0.025,),
                    // Remember me and forgot password
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            sendPasswordResetEmail();
                          },
                          child: const Text('Forgot password?'),
                        ),
                      ],
                    ),
                    SizedBox(height: Dheight * 0.02),
                    // Login button
                    ElevatedButton(
                      onPressed: () => loginUser(),
                      style: ElevatedButton.styleFrom(
                        padding:
                        EdgeInsets.symmetric(horizontal: Dwidth * 0.25, vertical: Dheight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dheight * 0.04),
                        ),
                      ),
                      child: _isLoading ? const CircularProgressIndicator() : const Text('Log in'),
                    ),
                    SizedBox(height: Dheight * 0.016,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("New user ? "),
                        GestureDetector(
                          child: const Text(
                              "Sign up!",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const SignUp(),)
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom clipper for the wave shape
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(size.width * 3 / 4, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
