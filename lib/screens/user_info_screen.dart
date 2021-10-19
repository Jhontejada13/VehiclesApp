import 'package:flutter/material.dart';
import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/models/user.dart';
import 'package:vehicles_app/screens/user_screen.dart';

class UserInfoScreen extends StatefulWidget {
  final Token token;
  final User user;

  UserInfoScreen({required this.token, required this.user});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  bool _showLoader = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.fullName),
      ),
      body: Stack(
        children: <Widget> [
          Column(
            children: <Widget> [
              _showUserInfo(),
              _showButtons(),
            ],
          ),
          _showLoader ? LoaderComponent(text: 'Por favor espere ...') : Container(),          
        ],

      )
    );
  }

  Widget _showUserInfo() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: FadeInImage(
              placeholder: AssetImage('assets/LogoTaller.png'), 
              image: NetworkImage(widget.user.imageFullPath),
              width: 100,
              height: 100,
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
                      children: <Widget> [                        
                        Row(
                          children: <Widget> [
                            const Text('Email: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Flexible(
                              child: Text(
                                widget.user.email,
                                style: const TextStyle(
                                  fontSize: 15
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: <Widget> [
                            const Text('Tipo documento: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Flexible(
                              child: Text(
                                widget.user.documentType.description,
                                style: const TextStyle(
                                  fontSize: 15
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: <Widget> [
                            const Text('Documento: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Flexible(
                              child: Text(
                                widget.user.document,
                                style: const TextStyle(
                                  fontSize: 15
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: <Widget> [
                            const Text('Dirección: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Flexible(
                              child: Text(
                                widget.user.address,
                                style: const TextStyle(
                                  fontSize: 15
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: <Widget> [
                            const Text('Teléfono: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              widget.user.phoneNumber,
                              style: const TextStyle(
                                fontSize: 15
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                        Row(
                          children: <Widget> [
                            const Text('Nro Vehículos: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              )
                            ),
                            Text(
                              widget.user.vehiclesCount.toString(),
                              style: const TextStyle(
                                fontSize: 15
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 3),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _showEditUserButton(),
          SizedBox(width: 20),
          _showAddVehicleButton(),
        ]
      ),
    );
  }

  Widget _showEditUserButton() {
    return Expanded(
      child: ElevatedButton(
        child: Text('Editar Usuario'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return Color(0xFF207398);
            }
          ),
        ),
        onPressed: () => _goEdit()
      ),
    );
  }

  Widget _showAddVehicleButton() {
    return Expanded(
      child: ElevatedButton(
        child: Text('Agregar Vehículo'),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return Color(0xFFE03B8B);
            }
          ),
        ),
        onPressed: () {}
      ),
    );
  }

  void _goEdit() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserScreen(
          token: widget.token,
          user: widget.user
        ) 
      )
    );

    if(result == 'yes'){
      //TODO: Pending refresh user info
    }
  }
}