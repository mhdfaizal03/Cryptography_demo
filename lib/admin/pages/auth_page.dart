import 'package:cryptography_demo/admin/pages/admin_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(8, 8),
                  spreadRadius: 0.2,
                  blurRadius: 20,
                  color: Colors.black87,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 500,
                  width: 500,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/encryption.png', width: 150),
                        SizedBox(height: 10),
                        Text(
                          'Encrypta',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 500,
                  width: 500,
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isRegister ? 'ADMIN REGISTER' : 'ADMIN LOGIN',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Column(
                            children: [
                              TextFormField(
                                controller: emailController,
                                decoration: InputDecoration(
                                  fillColor: Colors.black26,
                                  filled: true,
                                  hintText: 'Enter Email',
                                  hintStyle: TextStyle(color: Colors.grey[200]),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!RegExp(
                                    r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+",
                                  ).hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  fillColor: Colors.black26,
                                  filled: true,
                                  hintText: 'Enter Password',
                                  hintStyle: TextStyle(color: Colors.grey[200]),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  } else if (value.length < 6) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                              ),
                              if (isRegister) ...[
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: confirmPasswordController,
                                  decoration: InputDecoration(
                                    fillColor: Colors.black26,
                                    filled: true,
                                    hintText: 'Confirm Password',
                                    hintStyle: TextStyle(
                                      color: Colors.grey[200],
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please confirm your password';
                                    } else if (value !=
                                        passwordController.text) {
                                      return 'Passwords do not match';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                              SizedBox(height: 10),
                              if (!isRegister)
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Text(
                                      'Forgot Password ?',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          MaterialButton(
                            height: 50,
                            minWidth: 150,
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (isRegister) {
                                  // Handle registration logic
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AdminPage(),
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              isRegister ? 'REGISTER' : 'LOGIN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            color: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              setState(() {
                                isRegister = !isRegister;
                              });
                            },
                            child: Text(
                              isRegister
                                  ? 'Already have an account? Login'
                                  : 'Don\'t have an account? Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
