import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:status_alert/status_alert.dart';

class RegisterPage extends StatefulWidget {
  final String title;
  const RegisterPage({Key? key, this.title = 'Register'}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  late bool _passwordVisible;


  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
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
                      SizedBox(height: MediaQuery.of(context).size.width * 0.05),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .1,
                          vertical: MediaQuery.of(context).size.height * .02,
                        ),
                        child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Nome',
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
                              return 'Entre com o seu nome';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                        ),
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
                              StatusAlert.show(
                                context,
                                duration: Duration(seconds: 3),
                                subtitle: 'Insira um e-mail válido',
                                configuration: IconConfiguration(icon: Icons.error),
                                maxWidth: 200,
                              );
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

                      const SizedBox(
                        height: 15,
                      ),

                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            try {
                              final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text,
                              ).then((UserCredential userCredential) {
                                userCredential.user!.updateDisplayName(nameController.text);
                              });
                              StatusAlert.show(
                                context,
                                duration: Duration(seconds: 3),
                                subtitle: 'Registro com sucesso',
                                configuration: IconConfiguration(icon: Icons.error),
                                maxWidth: 200,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                                StatusAlert.show(
                                  context,
                                  duration: Duration(seconds: 3),
                                  subtitle: 'Senha muito curta',
                                  configuration: IconConfiguration(icon: Icons.error),
                                  maxWidth: 200,
                                );
                                passwordController.text = "";
                              } else if (e.code == 'email-already-in-use') {
                                print('The account already exists for that email.');
                                StatusAlert.show(
                                  context,
                                  duration: Duration(seconds: 3),
                                  subtitle: 'E-mail já cadastrado',
                                  configuration: IconConfiguration(icon: Icons.error),
                                  maxWidth: 200,
                                );
                                emailController.text = "";
                                passwordController.text = "";
                              }
                            } catch (e) {
                              print(e);
                            }
                            nameController.text = "";
                            emailController.text = "";
                            passwordController.text = "";
                            Modular.to.pushNamed('/');
                          },
                          borderRadius: BorderRadius.circular(20.0),
                          child: Ink(
                            padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.green,
                            ),
                            child: const Text(
                              'Registrar',
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
