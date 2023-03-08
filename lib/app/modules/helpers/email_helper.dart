// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mailer/mailer.dart';
// import 'package:mailer/smtp_server/gmail.dart';
// import 'package:agenda/app/modules/constants/schedule_constants.dart';
// import 'dart:async';
// import 'package:agenda/app/modules/screens/schedule_screen.dart';
//
// String? data;
//
// Future<void> sendNotificationEmail() async {
//   final smtpServer = gmail('appimpactus_notification@gmail.com', 'agenda2023');
//   final message = Message()
//     ..from = Address('appimpactus_notification@gmail.com')
//     ..recipients.add(displayEmail)
//     ..subject = 'ALARME DE TAREFA'
//     ..text = 'A tarefa recorrente foi acionada! Checar o aplicativo.';
//
//   try {
//     final sendReport = await send(message, smtpServer);
//     print('Message sent: ' + sendReport.toString());
//   } on MailerException catch (e) {
//     print('Message not sent.');
//     print(e);
//   }
// }
//
// void scheduleTask() {
//   Timer.periodic(Duration(days: 1), (Timer timer) {
//     final now = DateTime.now();
//     if (now.day == data) {
//       sendNotificationEmail();
//     }
//   });
// }
//
// Future<void> fetchData() async {
//   final docRef = FirebaseFirestore.instance.collection('Users').doc(user?.uid);
//   final subDocRef = docRef.collection('Task').doc();
//   final subDocSnapshot = await subDocRef.get();
//   final timestamp = subDocSnapshot.data()?['Dia'] as String;
//   final data = timestamp;
//   print('A data do subdocumento é $data');
// }
//
// Future<void> fetchMonth() async {
//   final docRef = FirebaseFirestore.instance.collection('Users').doc(user?.uid);
//   final subDocRef = docRef.collection('Task').doc();
//   final subDocSnapshot = await subDocRef.get();
//   final timestamp = subDocSnapshot.data()?['Dia'] as String;
//   final data = timestamp;
//   print('A data do subdocumento é $data');
// }
//
// Future<void> fetchYear() async {
//   final docRef = FirebaseFirestore.instance.collection('Users').doc(user?.uid);
//   final subDocRef = docRef.collection('Task').doc();
//   final subDocSnapshot = await subDocRef.get();
//   final timestamp = subDocSnapshot.data()?['Ano'] as String;
//   final data = timestamp;
//   print('O ano do subdocumento é $data');
// }
//
//
//
//
