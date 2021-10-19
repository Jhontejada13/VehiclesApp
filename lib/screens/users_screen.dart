import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';
import 'package:vehicles_app/models/document_type.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/models/user.dart';
import 'package:vehicles_app/screens/user_info_screen.dart';
import 'package:vehicles_app/screens/user_screen.dart';

class UsersScreen extends StatefulWidget {
  final Token token;

  UsersScreen({required this.token});

  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User> _users = [];
  bool _showLoader = false;

  String _search = '';
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _getUsers();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        actions: <Widget>[
          _isFiltered ? IconButton(
            onPressed: _removeFilter,
            icon: Icon(Icons.filter_none_outlined),
          ) : 
          IconButton(
            onPressed: _showFilter,
            icon: Icon(Icons.filter_alt_outlined),
          )
        ]
      ),      
      body: Center(
        child: _showLoader ? LoaderComponent(text: 'Por favor espere ...') : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _goAdd(),
      ),
    );
  }

  Future<Null> _getUsers() async {

    setState(() {
      _showLoader = true;
    });

    Response response = await ApiHelper.getUsers(widget.token.token);

    setState(() {
      _showLoader = false;
    });

    if(!response.isSucces){
      await showAlertDialog(
        context: context,
        title: 'Error',
        message: response.message,
        actions: <AlertDialogAction>[
          const AlertDialogAction(
            key: null,
            label: 'Aceptar'
          ),
        ]
      );
      return;
    }

    setState(() {
     _users = response.result;
    });


  }

  Widget _getContent() {
    return _users.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(_isFiltered 
          ? 'Ningún usuario coincide con el criterio de búsqueda'
          : 'No existen Usuarios registrados',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
      ),

    );
  }

  _getListView() {
    return RefreshIndicator(
      onRefresh: _getUsers,
      child: ListView(
        children: _users.map((e) {
          return Card(          
            child: InkWell(
              onTap: () => _goInfoUser(e),
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: FadeInImage(
                        placeholder: AssetImage('assets/LogoTaller.png'), 
                        image: NetworkImage(e.imageFullPath),
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    e.fullName,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    e.email,
                                    style: const TextStyle(
                                      fontSize: 15
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    e.phoneNumber,
                                    style: const TextStyle(
                                      fontSize: 15
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined),
                  ],
                ),
              )
            ),
          );
        }).toList(),
      ),
    );
  }

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getUsers();
  }

  void _showFilter() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          title: const Text('Filtrar Usuarios'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Escriba las primeras letras del nombre o apellido del usuario'),
              const SizedBox(height: 10,),
              TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Criterio de búsqueda ...',
                  labelText: 'Buscar',
                  suffixIcon: Icon(Icons.search_outlined),
                ),
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });                  
                }
              )
            ],
          ),
          actions: <Widget> [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => _filter(),
              child: Text('Filtrar'),
            )
          ],
        );
      }
    );
  }

  void _filter() {
    if(_search.isEmpty){
      return;
    }

    List<User> filteredList = [];

    for (var user in _users) {
      if(user.fullName.toLowerCase().contains(_search.toLowerCase())){
        filteredList.add(user);
      }
    }

    setState(() {
      _users = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  void _goAdd() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserScreen(
          token: widget.token,
          user: User(
            firstName: '', 
            lastName: '', 
            documentType: DocumentType(id: 0, description: ''), 
            document: '', 
            address: '', 
            imageId: '', 
            imageFullPath: '', 
            userType: 1, 
            fullName: '', 
            vehicles: [], 
            vehiclesCount: 0, 
            id: '', 
            userName: '', 
            email: '', 
            phoneNumber: ''
          ),
        ) 
      )
    );

    if(result == 'yes'){
      _getUsers();
    }
  }

  void _goInfoUser(User user) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoScreen(
          token: widget.token,
          user: user
        ) 
      )
    );

    if(result == 'yes'){
      _getUsers();
    }
  }
}