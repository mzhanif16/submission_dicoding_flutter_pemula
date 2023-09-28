import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:submission_dicoding_flutter_pemula/home_screen.dart';
import 'package:submission_dicoding_flutter_pemula/register_screen.dart';

import 'database_helper.dart';

class LoginView extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const LoginView({super.key, required this.databaseHelper});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 30, 30),
              child: Column(
                children: [
                  Image.asset('assets/colorful.png'),
                  DView.spaceHeight(),
                  const Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  DView.spaceHeight(60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Email',
                          style: TextStyle(color: Colors.blue),
                        ),
                        DInput(
                          controller: edtEmail,
                          fillColor: Colors.grey.shade300,
                          radius: BorderRadius.circular(10),
                          hint: 'Email',
                        ),
                        DView.spaceHeight(12),
                        const Text(
                          'Password',
                          style: TextStyle(color: Colors.blue),
                        ),
                        DInputPassword(
                          controller: edtPassword,
                          fillColor: Colors.grey.shade300,
                          radius: BorderRadius.circular(10),
                          hint: 'Password',
                        ),
                        DView.spaceHeight(24),
                        ElevatedButton(
                          onPressed: () async {
                            final email = edtEmail.text;
                            final password = edtPassword.text;
                            if (email.isEmpty || password.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Email dan password tidak boleh kosong.'),
                                ),
                              );
                            } else {
                              final isLoggedIn = await widget.databaseHelper
                                  .loginUser(email, password);
                              if (isLoggedIn) {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return HomeView(databaseHelper: widget.databaseHelper);
                                }));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login Berhasil'),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Login gagal. Periksa email dan password.',
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('LOGIN'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Dont Have an account?'),
                            DView.spaceWidth(6),
                            GestureDetector(
                                onTap: () => Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return RegisterView(
                                          databaseHelper:
                                              widget.databaseHelper);
                                    })),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
