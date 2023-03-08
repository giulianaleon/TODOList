import 'package:agenda/app/modules/screens/schedule_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:agenda/app/modules/constants/schedule_constants.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';


class AdminPage extends StatefulWidget {
  final String title;
  const AdminPage({Key? key, this.title = 'Task'}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  @override
  void initState() {
    super.initState();
  }

  Future openDialogTask(Map data, String id) => showDialog(
    context: context,
    builder: (context) => SingleChildScrollView(
      child: AlertDialog(
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                children: [
                  Text('Título: ' + data!['Titulo'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  Text('Descrição: ' + data!['Descricao'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  Text('Status: ' + data!['Status'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  Text('Recorrência: ' + data!['Recorrência'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  Text('Data: ' + data!['Data'],
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),

                  if(recurrenceController.text == "Única")
                    Text('Dia: ' + data!['Dia'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                  if(recurrenceController.text == "Recorrente")
                    Text('Mês: ' + data!['Mês'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                  if(recurrenceController.text == "Anual")
                    Text('Ano: ' + data!['Ano'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                ],
              );
            }
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: Text("FECHAR"),
          )
        ],
      ),
    ),
  );

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget> [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .1,
                vertical: MediaQuery.of(context).size.height * .05,
              ),
              color: Colors.red[300],
              child: Column(
                children: [
                  const Text (
                    'Seja bem-vindo(a)!',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    displayName!,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.person_2_outlined),
              title: const Text('Editar perfil'),
              onTap: () {

              },
            ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                await logout();
                Modular.to.pushNamed('/');
              },
            ),

          ],
        ),
      ),
      backgroundColor: Colors.blueGrey,
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .1,
              vertical: MediaQuery.of(context).size.height * .05,
            ),
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                  //stream: taskRef.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Ocorreu um erro ao buscar os dados');
                    }

                    final documents = snapshot.data!.docs;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final document = documents[index];
                        final data = document.data() as Map;
                        DocumentSnapshot snap = snapshot.data!.docs[index];

                        return GestureDetector(
                          onTap: (){
                            openDialogTask(data, snap.id);
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              title: Text(
                                data!['Titulo'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(data!['Descricao']),
                              trailing: Text(data!['Status']),
                              leading: Text(data!['Recorrência'] + '\n' + data!['Data']),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


