import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:submission_dicoding_flutter_pemula/login_screen.dart';

import 'database_helper.dart';

class RegisterView extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const RegisterView({super.key, required this.databaseHelper});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 28,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  DView.spaceHeight(60),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
                              await widget.databaseHelper
                                  .addUser(email, password);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Pengguna dengan email $email telah ditambahkan.',
                                  ),
                                ),
                              );
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginView(
                                    databaseHelper: widget.databaseHelper);
                              }));
                            }
                          },
                          child: const Text('REGISTER'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Have an account?'),
                            DView.spaceWidth(6),
                            GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: const Text(
                                  'Sign In',
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
