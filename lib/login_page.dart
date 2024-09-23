import 'dart:convert';

import 'package:diario_app/bemvindo_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _verSenha = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      label: Text('e-mail'), hintText: 'nome@email.com'),
                  validator: (email) {
                    if (email == null || email.isEmpty) {
                      return 'Digite seu e-mail';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _senhaController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !_verSenha,
                  decoration: InputDecoration(
                      label: Text('senha'),
                      hintText: 'Digite sua senha',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _verSenha
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _verSenha = !_verSenha;
                          });
                        },
                      )),
                  validator: (senha) {
                    if (senha == null || senha.isEmpty) {
                      return 'Digite sua senha';
                    } else if (senha.length < 6) {
                      return 'Digite uma senha mais forte';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      logar();
                    }
                  },
                  child: Text('Entrar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  logar() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    var url = Uri.parse('https://emanuelseverino.com.br/login/');
    var response = await http.post(
      url,
      body: {
        'username': _emailController.text,
        'password': _senhaController.text,
      },
    );
    if (response.statusCode == 200) {
      String token = json.decode(response.body)['token'];
      await _sharedPreferences.setString('token', 'Token $token');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('E-mail ou senha invalidos'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
