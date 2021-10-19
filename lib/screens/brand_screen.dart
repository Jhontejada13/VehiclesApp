import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';
import 'package:vehicles_app/models/brand.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';

class BrandScreen extends StatefulWidget {
  final Token token;
  final Brand brand;

  BrandScreen({required this.token, required this.brand});

  @override
  _BrandScreenState createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {

  bool _showLoader = false;  

  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowErrors = false;
  TextEditingController _descriptionController = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _description = widget.brand.description;
    _descriptionController.text = _description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.brand.id == 0 ? 'Nuevo Marca' : widget.brand.description
        ),        
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              _showDescriptio(),
              _showButtons(),
            ] ,
          ),
          _showLoader ? LoaderComponent(text: 'Por favor espere ...') : Container(), 
        ],
      )
    );
  }

  Widget _showDescriptio() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        controller: _descriptionController,
        decoration: InputDecoration(
          hintText: 'Ingresa una descripción ...',
          labelText: 'Descripción',
          errorText: _descriptionShowErrors ? _descriptionError : null,
          suffixIcon: const Icon(Icons.description),
          border: OutlineInputBorder (
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _description = value;
        },
      ),
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
              child: Text('Guadar'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Color(0xFF207398);
                  }
                ),
              ),
              onPressed: ()=> _save(),
            ),
          ),
          widget.brand.id == 0 ? Container() : SizedBox(width: 20),
          widget.brand.id == 0 
          ? Container() 
          : Expanded(
              child: ElevatedButton(
                child: Text('Borrar'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return Color(0xFFB4161B);
                    }
                  ),
                ),
                onPressed: () => _confirmDelete(),
            ),
          ),
        ]
      ),
    );
  }

  void _save() {
    if(!_validateFields()){
      return;
    }

    widget.brand.id == 0 ? _addRecord() : _saveRecord();
  }

  bool _validateFields() {
    bool isValid = true;

    if(_description.isEmpty){
      isValid = false;
      _descriptionShowErrors = true;
      _descriptionError = 'Debes ingresar una descripción';
    }else{
      _descriptionShowErrors = false;
    }       

    setState(() { });
    return isValid;
  }

  _addRecord() async{
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if(connectivityResult == ConnectivityResult.none){
      setState(() {
      _showLoader = false;
    });

      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estés conectado a internet',
        actions: <AlertDialogAction>[
          const AlertDialogAction(
            key: null,
            label: 'Aceptar'
          ),
        ]
      );
      return;
    }

    Map<String, dynamic> request = {
      'description': _description,
    };

    Response response = await ApiHelper.post(
      '/api/Brands/',
      request,
      widget.token.token 
    );

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

    Navigator.pop(context, 'yes');
  }

  _saveRecord() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if(connectivityResult == ConnectivityResult.none){
      setState(() {
      _showLoader = false;
    });

      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estés conectado a internet',
        actions: <AlertDialogAction>[
          const AlertDialogAction(
            key: null,
            label: 'Aceptar'
          ),
        ]
      );
      return;
    }

    Map<String, dynamic> request = {
      'id': widget.brand.id,
      'description': _description,
    };

    Response response = await ApiHelper.put(
      '/api/Brands/',
      widget.brand.id.toString(),
      request,
      widget.token.token 
    );

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

    Navigator.pop(context, 'yes');
  }

  _confirmDelete() async {
    var response = await showAlertDialog(
      context: context,
      title: 'Conrmación',
      message: '¿Estás seguro de borrar el registro?',
      actions: <AlertDialogAction>[
        const AlertDialogAction(
          key: 'no',
          label: 'No'
        ),
        const AlertDialogAction(
          key: 'yes',
          label: 'Si'
        ),
      ]
    );

    if(response == 'yes'){
      _deleteRecord();
    }

  }

  void _deleteRecord() async{
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();

    if(connectivityResult == ConnectivityResult.none){
      setState(() {
      _showLoader = false;
    });

      await showAlertDialog(
        context: context,
        title: 'Error',
        message: 'Verifica que estés conectado a internet',
        actions: <AlertDialogAction>[
          const AlertDialogAction(
            key: null,
            label: 'Aceptar'
          ),
        ]
      );
      return;
    }

    Response response = await ApiHelper.delete(
      '/api/Brands/',
      widget.brand.id.toString(),
      widget.token.token 
    );

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

    Navigator.pop(context, 'yes');
  }
}