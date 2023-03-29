import 'package:appnotify_adm/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  String alert = "";
  bool progress = false;

  login(BuildContext context) async {
    Navigator.of(Routes.navigatorKey!.currentContext!)
        .pushReplacementNamed('/notificacao');
    /*
    try {
      setState(() {
        progress = true;
      });
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text.trim(), password: password.text.trim());

      setState(() {
        progress = false;
      });

      bool userLoged = await getUserLoged(credential.user?.uid.toString());

      userLoged
          ? Navigator.of(Routes.navigatorKey!.currentContext!)
              .pushReplacementNamed('/notificacao')
          : _showToast(context);
    } on FirebaseAuthException catch (e) {
      setState(() {
        progress = false;
      });
      if (e.code == 'user-not-found') {
        setState(() {
          alert = '* No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          alert = '* Wrong password provided for that user.';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          alert = '* Invalid Email.';
        });
      } else {
        setState(() {
          alert = '* ${e.code}';
        });
      }
    }
    */
  }

  Future getUserLoged(String? uid) async {
    bool status = false;
    final users = FirebaseFirestore.instance.collection('users').doc(uid);
    final user = await users.get();

    user.data()!.forEach((key, value) {
      if (key == 'status' && value) status = value;
    });

    return status;
  }

  void _showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('unauthorized user!'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LOGIN",
              style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 40,
                width: 40,
                child: progress
                    ? const CircularProgressIndicator(
                        strokeWidth: 1.5,
                      )
                    : Container()),
            const SizedBox(
              height: 20,
            ),
            Material(
              borderRadius: BorderRadius.circular(50),
              elevation: 5.0,
              shadowColor: Colors.grey.shade300,
              child: TextField(
                onTap: () => setState(() {
                  alert = "";
                }),
                controller: emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  label: const Text("Login"),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 8.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Material(
              borderRadius: BorderRadius.circular(50),
              elevation: 5.0,
              shadowColor: Colors.grey.shade300,
              child: TextField(
                onTap: () => setState(() {
                  alert = "";
                }),
                obscureText: true,
                controller: password,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_open_outlined),
                  label: const Text("Password"),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 8.0),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black54),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[50],
                elevation: 5.0,
                minimumSize: Size((MediaQuery.of(context).size.width) / 2, 50),
              ),
              onPressed: (() => login(context)),
              child: const Text(
                "LOGIN",
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(alert,
                style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 12))
          ],
        ),
      ),
    );
  }
}
