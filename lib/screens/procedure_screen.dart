import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';
import 'package:vehicles_app/models/procedure.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';

class ProcedureScreen extends StatefulWidget {
  final Token token;
  final Procedure procedure;

  ProcedureScreen({required this.token, required this.procedure});

  @override
  _ProcedureScreenState createState() => _ProcedureScreenState();
}

class _ProcedureScreenState extends State<ProcedureScreen> {

  bool _showLoader = false;  

  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowErrors = false;
  TextEditingController _descriptionController = TextEditingController();

  String _price = '';
  String _priceError = '';
  bool _priceShowErrors = false;
  TextEditingController _priceController = TextEditingController();
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _description = widget.procedure.description;
    _descriptionController.text = _description;

    _price = widget.procedure.price.toString();
    _priceController.text = _price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.procedure.id == 0 ? 'Nuevo Procedimiento' : widget.procedure.description
        ),        
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              _showDescriptio(),
              _showPrice(),
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

  Widget _showPrice() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(
          decimal: true,
          signed: false
        ),
        controller: _priceController,
        decoration: InputDecoration(
          hintText: 'Ingresa un precio ...',
          labelText: 'Descripción',
          errorText: _priceShowErrors ? _priceError : null,
          suffixIcon: const Icon(Icons.attach_money_outlined),
          border: OutlineInputBorder (
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _price = value;
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
          widget.procedure.id == 0 ? Container() : SizedBox(width: 20),
          widget.procedure.id == 0 
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

    widget.procedure.id == 0 ? _addRecord() : _saveRecord();
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

    if(_price.isEmpty){
      isValid = false;
      _priceShowErrors = true;
      _priceError = 'Debes ingresar un precio';
    }else{
      double price = double.parse(_price);
      if(price <= 0){
        isValid = false;
        _priceShowErrors = true;
        _priceError = 'Debes ingresar un precio mayor a cero';
      }else{
        _priceShowErrors = false;
      }
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
      'price' : double.parse(_price)
    };

    Response response = await ApiHelper.post(
      '/api/Procedures/',
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
      'id': widget.procedure.id,
      'description': _description,
      'price' : double.parse(_price)
    };

    Response response = await ApiHelper.put(
      '/api/Procedures/',
      widget.procedure.id.toString(),
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
      '/api/Procedures/',
      widget.procedure.id.toString(),
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