import 'package:agenda/app/modules/screens/admin_screen.dart';
import 'package:agenda/app/modules/screens/register_screen.dart';
import 'package:agenda/app/modules/screens/schedule_screen.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'home_page_screen.dart';

class HomeModule extends Module {

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => HomePage()),
    ChildRoute('/registro', child: (_, args) => RegisterPage()),
    ChildRoute('/agenda', child: (_,args) => TasksPage()),
    ChildRoute('/admin', child: (_,args) => AdminPage()),
  ];

}