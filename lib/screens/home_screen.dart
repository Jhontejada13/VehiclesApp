import 'package:flutter/material.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  final Token token;

  HomeScreen({required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicles'),        
      ),
      body: _getBody(),
      drawer: _getMechanicMenu(),
    );
  }

Widget _getBody() {
  return Container(
    margin: EdgeInsets.all(30),
    child: Center(
      child: Text(
        'Bienvenid@ ${widget.token.user.fullName}',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold
        )
      )
    ),
  );
}

  Widget _getMechanicMenu() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image(
              image: AssetImage('assets/LogoTaller.png'),
            )
          ),
          ListTile(
            leading: Icon(Icons.two_wheeler_outlined),
            title: const Text('Marcas'),
            onTap: () {}
          ),
          ListTile(
            leading: Icon(Icons.precision_manufacturing_outlined),
            title: const Text('Procedimientos'),
            onTap: () {}
          ),
          ListTile(
            leading: Icon(Icons.badge_outlined),
            title: const Text('Tipos de documento'),
            onTap: () {}
          ),
          ListTile(
            leading: Icon(Icons.toys_outlined),
            title: const Text('Tipos de vehículo'),
            onTap: () {}
          ),
          ListTile(
            leading: Icon(Icons.people_alt_outlined),
            title: const Text('Usuarios'),
            onTap: () {}
          ),
          const Divider(
            color: Colors.black,
            height: 2,
          ),
          ListTile(
            leading: Icon(Icons.face_outlined),
            title: const Text('Editar Perfil'),
            onTap: () {}
          ),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                )
              );
            },
          ),

        ],
      ),
    );
  }
}