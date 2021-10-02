import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/constants.dart';
import 'package:vehicles_app/models/procedure.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:http/http.dart' as http;

class ProceduresScreen extends StatefulWidget {
  final Token token;

  ProceduresScreen({required this.token});

  @override
  _ProceduresScreenState createState() => _ProceduresScreenState();
}

class _ProceduresScreenState extends State<ProceduresScreen> {
  List<Procedure> _procedures = [];
  bool _showLoader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProcedures();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procedimientos'),
      ),
      body: Center(
        child: _showLoader ? LoaderComponent(text: 'Por favor espere ...') : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }

  void _getProcedures() async {

    setState(() {
      _showLoader = true;
    });

    var url = Uri.parse('${Constants.apiUrl}/api/procedures');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer ${widget.token.token}'
      }
    );

    setState(() {
      _showLoader = false;
    });

    var body = response.body;
    var decodedJson = jsonDecode(body);
    if(decodedJson != null) {
      for (var item in decodedJson) {
        _procedures.add(Procedure.fromJson(item));
      }
    }

    print(_procedures);
  }

  Widget _getContent() {
    return _procedures.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: const Text(
            'No existen procedmientos almacenados',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
      ),

    );
  }

  _getListView() {
    return ListView(
      children: _procedures.map((e) {
        return Card(          
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.description,
                        style: const TextStyle(
                          fontSize: 16
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        '${NumberFormat.currency(symbol: '\$').format(e.price)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
        );
      }).toList(),
    );
  }
}