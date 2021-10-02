import 'package:flutter/material.dart';
import 'package:vehicles_app/models/procedure.dart';
import 'package:vehicles_app/models/token.dart';

class ProcedureScreen extends StatefulWidget {
  final Token token;
  final Procedure procedure;

  ProcedureScreen({required this.token, required this.procedure});

  @override
  _ProcedureScreenState createState() => _ProcedureScreenState();
}

class _ProcedureScreenState extends State<ProcedureScreen> {
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
      body: Column(
        children: <Widget>[
          _showDescriptio(),
          _showPrice(),
          _showButtons(),
        ] ,
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
              onPressed: () {}
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
                onPressed: () {}
            ),
          ),
        ]
      ),
    );
  }
}