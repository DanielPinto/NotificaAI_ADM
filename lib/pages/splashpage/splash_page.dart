import 'package:appnotify_adm/Data/database_helper.dart';
import 'package:appnotify_adm/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _consultar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.amber.shade700,
          strokeWidth: 2,
        ),
      ),
    );
  }

  void _consultar() async {
    bool status = false;
    try {
      final allUsers = await dbHelper.queryAllRows();

      if (allUsers.isNotEmpty) {
        var user = allUsers.first;
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: user["email"].trim(), password: user["password"].trim());

        final users = FirebaseFirestore.instance
            .collection('users')
            .doc(credential.user?.uid.toString());
        final user_valid = await users.get();

        user_valid.data()!.forEach((key, value) {
          if (key == 'status' && value) status = value;
          //if (key == 'resetPassword' && value) resetPassword = value;
        });

        if (status) {
          Navigator.of(Routes.navigatorKey!.currentContext!)
              .pushReplacementNamed('/notificacao');
        } else {
          Navigator.of(Routes.navigatorKey!.currentContext!)
              .popAndPushNamed('/login');
        }
      } else {
        Navigator.of(Routes.navigatorKey!.currentContext!)
            .popAndPushNamed('/login');
      }
    } catch (e) {
      var erro = e.toString();
      print("ERRO: $erro");
      Navigator.of(Routes.navigatorKey!.currentContext!)
          .popAndPushNamed('/login');
    }
  }
}
