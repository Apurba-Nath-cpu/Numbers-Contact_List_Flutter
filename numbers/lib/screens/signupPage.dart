import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:numbers/screens/loginPage.dart';

import '../resources/auth_methods.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';
import 'home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Uint8List? _image;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _confirmPasswordController.dispose();
  }

  // Select an image
  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  // Sign Up user
  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select an image"),
      ));
    } else if (_usernameController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please give a username"),
      ));
    } else if (_emailController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please give an email"),
      ));
    } else if (_emailController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please give an email"),
      ));
    } else if (_passwordController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please give a password"),
      ));
    } else if (_passwordController.text == _confirmPasswordController.text) {
      String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        file: _image!,
      );
      if (res != 'success') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(res),
        ));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password and Confirm Password must match!"),
      ));
    }
    setState(() {
      _isLoading = false;
    });
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
                    const Text("Numbers",
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Pacifico',
                        )),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Hello. ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sign Up!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dheight * 0.02),
                    Material(
                      borderRadius: BorderRadius.circular(40),
                      child: InkWell(
                        onTap: () => selectImage(),
                        child: Container(
                          child: _image != null
                              ? Material(
                                  borderRadius: BorderRadius.circular(50),
                                  child: CircleAvatar(
                                    radius: 40,
                                    backgroundColor: Colors.greenAccent,
                                    child: CircleAvatar(
                                      radius: 38,
                                      backgroundImage: MemoryImage(_image!),
                                    ),
                                  ),
                                )
                              : Material(
                                  borderRadius: BorderRadius.circular(50),
                                  child: const CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        AssetImage('assets/imgvid/null_dp.png'),
                                  ),
                                ),
                        ),
                      ),
                    ),
                    _image == null
                        ? Container(
                            margin:
                                EdgeInsets.symmetric(vertical: Dheight * 0.01),
                            child: const Text("Chose a profile picture"),
                          )
                        : Container(),
                    SizedBox(
                      height: Dheight * 0.01,
                    ),
                    //Username
                    TextField(
                      controller: _usernameController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade900, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Email field
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade900, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
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
                          borderSide: BorderSide(
                              color: Colors.grey.shade900, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Confirm Password field
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey.shade900, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Remember me and forgot password
                    SizedBox(height: Dheight * 0.025),
                    // Login button
                    ElevatedButton(
                      onPressed: () => signUpUser(),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: Dwidth * 0.25,
                            vertical: Dheight * 0.02),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dheight * 0.04),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Sign Up'),
                    ),
                    SizedBox(
                      height: Dheight * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account ? "),
                        GestureDetector(
                          child: const Text(
                            "Log In!",
                            style: TextStyle(color: Colors.blue),
                          ),
                          onTap: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          )),
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

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        size.width * 3 / 4, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
