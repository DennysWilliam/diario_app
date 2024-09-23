import 'package:diario_app/home_page.dart';
import 'package:diario_app/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BemVindoPage extends StatefulWidget {
  const BemVindoPage({super.key});

  @override
  State<BemVindoPage> createState() => _BemVindoPageState();
}

class _BemVindoPageState extends State<BemVindoPage> {
  @override
  initState() {
    super.initState();
    verificarUsuario().then((temUsuario) {
      if (temUsuario) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Bem Vindo Page'),
      ),
    );
  }

  Future<bool> verificarUsuario() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    String? token = _sharedPreferences.getString('token');
    if (token == null) {
      return false;
    } else {
      return true;
    }
  }
}
