// import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email = "";
  String _emailError = "";
  bool _emailShowErrors = false;
  String _password = "";
  String _passwordError = "";
  bool _passwordShowErrors = false;
  bool _remeberMe = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _showLogo(),
            SizedBox(height: 20,),
            _showEmail(),
            _showPassword(),
            _showRememberMe(),
            _showButtons(),

          ],
        )
      ),
    );
  }

  Widget _showLogo() {
    return const Image(
      image: AssetImage('assets/LogoTaller.png'),
      width: 300,
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa tu email ...',
          labelText: 'Email',
          errorText: _emailShowErrors ? _emailError : null,
          suffixIcon: Icon(Icons.email),
          border: OutlineInputBorder (
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _email = value;
        },
      ),
    );
  }

  Widget _showPassword() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          hintText: 'Ingresa tu contraseña ...',
          labelText: 'Contraseña',
          errorText: _passwordShowErrors ? _passwordError : null,
          suffixIcon: Icon(Icons.lock),
          border: OutlineInputBorder (
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _password = value;
        },
      ),
    ); 
  }

  Widget _showRememberMe() {
    return CheckboxListTile(
      title: Text('Recordarme'),
      value: _remeberMe, 
      onChanged: (value){
        setState((){
          _remeberMe = value!;
        });
      }
    );
  }

  Widget _showButtons() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: ElevatedButton(
              child: Text('Iniciar sesión'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Color(0xFF207398);
                  }
                ),
              ),
              onPressed: () => _login()
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              child: Text('Nuevo usuario'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Color(0xFFE03B8B);
                  }
                ),
              ),
              onPressed: () {}
            ),
          ),
        ]
      ),
    );
  }

  void _login() {
    if(!_validateFields()) {
      return;
    }
  }

  bool _validateFields() {
    bool hasErrors = false;

    if(_email.isEmpty){
      hasErrors = true;
      _emailShowErrors = true;
      _emailError = 'Debes ingresar tu email';
    // }else if(!EmailValidator.validate(_email)){
    //   hasErrors = true;
    //   _emailShowErrors = true;
    //   _emailError = 'Debes ingresar un email válido';
    }else{
      _emailShowErrors = false;
    }

    if(_password.isEmpty){
      hasErrors = true;
      _passwordShowErrors = true;
      _passwordError = 'Debes ingresar tu contraseñal';
    }else if(_password.length < 6){
      hasErrors = true;
      _passwordShowErrors = true;
      _passwordError = 'Debes ingresar una contraseña de al menos 6 caracteres';
    }else{
      _passwordShowErrors = false;
    }

    setState(() { });
    return hasErrors;
  }
}