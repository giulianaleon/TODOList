import 'package:agenda/app/modules/screens/schedule_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

TextEditingController titleController = TextEditingController();
TextEditingController descriptionController = TextEditingController();
TextEditingController dayController = TextEditingController();
TextEditingController monthController = TextEditingController();
TextEditingController statusController = TextEditingController();
TextEditingController recurrenceController = TextEditingController();
TextEditingController dateController = TextEditingController();

late DateTime dateControl;
DateFormat formatter = DateFormat('dd/MM/yy');
DateFormat formatterDay = DateFormat('dd');
DateFormat formatterMonth = DateFormat('MM');

enum statusTask {Aguardando, Realizado}
statusTask? status = statusTask.Aguardando;

FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;
CollectionReference usersRef = FirebaseFirestore.instance.collection('Users');
DocumentReference companyDocRef = usersRef.doc(user?.uid);
CollectionReference taskRef = companyDocRef.collection('Tasks');

String? displayName = user?.displayName;
String? displayEmail = user?.email;

void updateCurrentUser() async {
  await user?.reload();
  user = auth.currentUser;
  print(user);
}













