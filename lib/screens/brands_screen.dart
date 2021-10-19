import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';
import 'package:vehicles_app/models/brand.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/screens/brand_screen.dart';

class BrandsScreen extends StatefulWidget {
  final Token token;

  BrandsScreen({required this.token});

  @override
  _BrandsScreenState createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  List<Brand> _brands = [];
  bool _showLoader = false;

  String _search = '';
  bool _isFiltered = false;

  @override
  void initState() {
    super.initState();
    _getBrands();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcas'),
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

  Future<Null> _getBrands() async {

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

    Response response = await ApiHelper.getBrands(widget.token.token);

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
     _brands = response.result;
    });


  }

  Widget _getContent() {
    return _brands.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(_isFiltered 
          ? 'Ninguna marca coincide con el criterio de búsqueda'
          : 'No existen marcas registradas',
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
      onRefresh: _getBrands,
      child: ListView(
        children: _brands.map((e) {
          return Card(          
            child: InkWell(
              onTap: () => _goEdit(e),
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.description,
                          style: const TextStyle(
                            fontSize: 20
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_outlined),
                      ],
                    ),               
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
    _getBrands();
  }

  void _showFilter() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          title: const Text('Filtrar Marcas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Escriba las primeras letras de la marca'),
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

    List<Brand> filteredList = [];

    for (var brand in _brands) {
      if(brand.description.toLowerCase().contains(_search.toLowerCase())){
        filteredList.add(brand);
      }
    }

    setState(() {
      _brands = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  void _goAdd() async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrandScreen(
          token: widget.token,
          brand: Brand(
            description: '',
            id: 0,
          ),
        ) 
      )
    );

    if(result == 'yes'){
      _getBrands();
    }
  }

  void _goEdit(Brand brand) async {
    String? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrandScreen(
          token: widget.token,
          brand: brand
        ) 
      )
    );

    if(result == 'yes'){
      _getBrands();
    }
  }
}