import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:status_alert/status_alert.dart';

import '../constants/schedule_constants.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, this.title = 'Home'}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late bool _passwordVisible;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .1,
              vertical: MediaQuery.of(context).size.height * .1,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                Card(
                  color: Colors.white,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [

                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .1,
                          vertical: MediaQuery.of(context).size.height * .02,
                        ),
                        child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                              fontSize: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Entre com o seu email';
                            }
                            if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return 'Insira um email válido';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .1,
                          vertical: MediaQuery.of(context).size.height * .02,
                        ),
                        child: TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: const TextStyle(
                              fontSize: 15,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !_passwordVisible,
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Insira a senha';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * .1,
                              vertical: MediaQuery.of(context).size.height * .02,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                print('Texto clicado!');
                                // adicione aqui a ação que deseja executar quando o texto for clicado
                              },
                              child: const Text(
                                'Esqueci minha senha',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            try {
                              await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passwordController.text
                              );
                              updateCurrentUser();
                              if(emailController.text == "admin@gmail.com")
                                Modular.to.pushNamed('/admin');
                              else
                                Modular.to.pushNamed('/agenda');

                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                                StatusAlert.show(
                                  context,
                                  duration: Duration(seconds: 3),
                                  subtitle: 'Usuário não encontrado',
                                  configuration: IconConfiguration(icon: Icons.error),
                                  maxWidth: 200,
                                );
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                                StatusAlert.show(
                                  context,
                                  duration: Duration(seconds: 3),
                                  subtitle: 'Senha incorreta',
                                  configuration: IconConfiguration(icon: Icons.error),
                                  maxWidth: 200,
                                );
                              }
                            }
                            emailController.text = "";
                            passwordController.text = "";
                          },
                          borderRadius: BorderRadius.circular(20.0),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.red[300],
                            ),
                            child: const Text(
                              'ENTRAR',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      const Text(
                        'OU',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: (){
                            Modular.to.pushNamed('/registro');
                          },
                          borderRadius: BorderRadius.circular(20.0),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.blueAccent,
                            ),
                            child: const Text(
                              'Criar conta',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.width * 0.08),

                    ],
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
