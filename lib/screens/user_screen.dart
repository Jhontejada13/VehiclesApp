import 'dart:convert';
import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:camera/camera.dart';
import 'package:connectivity/connectivity.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vehicles_app/components/loader_component.dart';
import 'package:vehicles_app/helpers/api_helper.dart';
import 'package:vehicles_app/models/document_type.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/token.dart';
import 'package:vehicles_app/models/user.dart';
import 'package:vehicles_app/screens/take_picture_screen.dart';

class UserScreen extends StatefulWidget {
  final Token token;
  final User user;

  UserScreen({required this.token, required this.user});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  bool _showLoader = false;
  bool _photoChanged = false;
  late XFile _image;


  String _firstName = '';
  String _firstNameError = '';
  bool _firstNameShowErrors = false;
  TextEditingController _firstNameController = TextEditingController();

  String _lastName = '';
  String _lastNameError = '';
  bool _lastNameShowErrors = false;
  TextEditingController _lastNameController = TextEditingController();

  int _documentTypeId = 0;
  String _documentTypeIdError = '';
  bool _documentTypeIdShowErrors = false;
  List<DocumentType> _documentTypes = [];
  
  String _document = '';
  String _documentError = '';
  bool _documentShowErrors = false;
  TextEditingController _documentController = TextEditingController();

  String _address = '';
  String _addressError = '';
  bool _addressShowErrors = false;
  TextEditingController _addressController = TextEditingController();

  String _email = '';
  String _emailError = '';
  bool _emailShowErrors = false;
  TextEditingController _emailController = TextEditingController();

  String _phoneNumber = '';
  String _phoneNumberError = '';
  bool _phoneNumberShowErrors = false;
  TextEditingController _phoneNumberController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
     _getDocumentTypes();

    _firstName = widget.user.firstName;
    _firstNameController.text = _firstName;

    _lastName = widget.user.lastName;
    _lastNameController.text = _lastName;

    _documentTypeId = widget.user.documentType.id;

    _document = widget.user.document;
    _documentController.text = _document;

    _email = widget.user.email;
    _emailController.text = _email;

    _address = widget.user.address;
    _addressController.text = _address;

    _phoneNumber = widget.user.phoneNumber;
    _phoneNumberController.text = _phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user.id.isEmpty ? 'Nuevo Usuario' : widget.user.fullName
        ),        
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                _showPhoto(),
                _showFirsName(),
                _showLastName(),
                _showDocumentType(),
                _showDocument(),
                _showEmail(),
                _showAddress(),
                _showPhoneNumber(),
                _showButtons(),
              ] ,
            ),
          ),
          _showLoader ? LoaderComponent(text: 'Por favor espere ...') : Container(), 
        ],
      )
    );
  }

  Widget _showFirsName() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        controller: _firstNameController,
        decoration: InputDecoration(
          hintText: 'Ingresa nombres ...',
          labelText: 'Nombres',
          errorText: _firstNameShowErrors ? _firstNameError : null,
          suffixIcon: const Icon(Icons.person),
          border: OutlineInputBorder (
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _firstName = value;
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
          widget.user.id.isEmpty ? Container() : SizedBox(width: 20),
          widget.user.id.isEmpty
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

    widget.user.id.isEmpty ? _addRecord() : _saveRecord();
  }

  bool _validateFields() {
    bool isValid = true;

    if(_firstName.isEmpty){
      isValid = false;
      _firstNameShowErrors = true;
      _firstNameError = 'Debes ingresar al menos un nombre';
    }else{
      _firstNameShowErrors = false;
    }

    if(_lastName.isEmpty){
      isValid = false;
     _lastNameShowErrors = true;
     _lastNameError = 'Debes ingresar al menos un apellido';
    }else{
     _lastNameShowErrors = false;
    }

    if(_documentTypeId == 0){
       isValid = false;
    _documentTypeIdShowErrors = true;
    _documentTypeIdError = 'Debes seleccionar un tipo de documento';
    }else{
     _documentTypeIdShowErrors = false;
    }

    if(_document.isEmpty){
      isValid = false;
     _documentShowErrors = true;
     _documentError = 'Debes ingresar el número de documento';
    }else{
     _documentShowErrors = false;
    }

    if(_email.isEmpty){
      isValid = false;
      _emailShowErrors = true;
      _emailError = 'Debes ingresar un email';
    }else if(!EmailValidator.validate(_email)){
      isValid = false;
      _emailShowErrors = true;
      _emailError = 'Debes ingresar un email válido';
    }else{
      _emailShowErrors = false;
    }

    if(_address.isEmpty){
      isValid = false;
     _addressShowErrors = true;
     _addressError = 'Debes ingresar una dirección';
    }else{
     _addressShowErrors = false;
    }

    if(_phoneNumber.isEmpty){
      isValid = false;
     _phoneNumberShowErrors = true;
     _phoneNumberError = 'Debes ingresar un número de teléfono';
    }else{
     _phoneNumberShowErrors = false;
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

    String base64Image = '';

    if(_photoChanged){
      List<int> imageBytes = await _image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'firstName': _firstName,
      'lastname': _lastName,
      'documentTypeId': _documentTypeId,
      'document': _document,
      'email': _email,
      'address': _address,
      'phoneNumber': _phoneNumber,
      'image': base64Image,
    };

    Response response = await ApiHelper.post(
      '/api/Users/',
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

    String base64Image = '';

    if(_photoChanged){
      List<int> imageBytes = await _image.readAsBytes();
      base64Image = base64Encode(imageBytes);
    }

    Map<String, dynamic> request = {
      'id': widget.user.id,
      'firstName': _firstName,
      'lastname': _lastName,
      'documentTypeId': _documentTypeId,
      'document': _document,
      'email': _email,
      'address': _address,
      'phoneNumber': _phoneNumber,
      'image': base64Image,
    };

    Response response = await ApiHelper.put(
      '/api/Users/',
      widget.user.id,
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
      '/api/Users/',
      widget.user.id,
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

  Widget _showPhoto() {
    return Stack(
      children: <Widget>[
        Container(
        margin: const EdgeInsets.only(top: 10),
        child: widget.user.id.isEmpty && !_photoChanged ? 
          const Image(
            image: AssetImage('assets/no-image.png'),
            width: 160,
            height: 160,
            fit: BoxFit.cover
          ) 
          : ClipRRect(    
            borderRadius: BorderRadius.circular(80),
            child: _photoChanged ? 
              Image.file(
                File(_image.path),
                height: 160,
                width: 160,
                fit: BoxFit.cover
              )
              : FadeInImage(
                placeholder: const AssetImage('assets/LogoTaller.png'), 
                image: NetworkImage(widget.user.imageFullPath),
                width: 160,
                height: 160,
                fit: BoxFit.cover
              ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 100,
          child: InkWell(
            onTap: () => _takePicture(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.grey[200],
                height: 60,
                width: 60,
                child: Icon(
                  Icons.photo_camera_outlined,
                  size: 40,
                  color: Colors.blue[300]
                ),
              )
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: InkWell(
            onTap: () => _selectPicture(),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.grey[200],
                height: 60,
                width: 60,
                child: Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: Colors.blue[300]
                ),
              )
            ),
          ),
        )
      ]
      
    );
  }

  Widget _showLastName() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _lastNameController,
        decoration: InputDecoration(
          hintText: 'Ingresa apellidos ...',
          labelText: 'Apellidos',
          errorText: _lastNameShowErrors ? _lastNameError : null,
          suffixIcon: const Icon(Icons.person),
          border: OutlineInputBorder (
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _lastName = value;
        },
      ),
    );
  }

  Widget _showDocumentType() {
    return Container(
      margin: EdgeInsets.all(10),
      child: _documentTypes.length == 0 
        ? Text('Cargando tipos de documentos')
        : DropdownButtonFormField(
          items: _getComboDocumentTypes(),
          value: _documentTypeId,
          onChanged: (option) {
            setState(() {
              _documentTypeId = option as int;
            });
          },
          decoration: InputDecoration(
            hintText: 'Seleccione un tipo de documento',
            labelText: 'Tipos de documento',
            errorText: _documentTypeIdShowErrors ? _documentTypeIdError : null,
            border: OutlineInputBorder (
              borderRadius: BorderRadius.circular(10)
            ),
          )
        )
    );
  }

  Widget _showDocument() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _documentController,
        decoration: InputDecoration(
          hintText: 'Ingresa docuement ...',
          labelText: 'Documento',
          errorText: _documentShowErrors ? _documentError : null,
          suffixIcon: const Icon(Icons.assignment_ind_outlined),
          border: OutlineInputBorder (
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _document = value;
        },
      ),
    );
  }

  Widget _showEmail() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        enabled: widget.user.id.isEmpty,
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa email ...',
          labelText: 'Email',
          errorText: _emailShowErrors ? _emailError : null,
          suffixIcon: const Icon(Icons.email_outlined),
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

  Widget _showAddress() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _addressController,
        keyboardType: TextInputType.streetAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa dirección ...',
          labelText: 'Direccion',
          errorText: _addressShowErrors ? _addressError : null,
          suffixIcon: const Icon(Icons.home_outlined),
          border: OutlineInputBorder (
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _address = value;
        },
      ),
    );
  }

  Widget _showPhoneNumber() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        controller: _phoneNumberController,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          hintText: 'Ingresa teléfono ...',
          labelText: 'teléfono',
          errorText: _phoneNumberShowErrors ? _phoneNumberError : null,
          suffixIcon: const Icon(Icons.phone),
          border: OutlineInputBorder (
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onChanged: (value) {
          _phoneNumber = value;
        },
      ),
    );
  }

  Future<Null> _getDocumentTypes() async {

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

    Response response = await ApiHelper.getDocumentTypes(widget.token.token);

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
     _documentTypes = response.result;
    });
  }

  List<DropdownMenuItem<int>> _getComboDocumentTypes() {
    List<DropdownMenuItem<int>> list = [];

    list.add(DropdownMenuItem(
      child: Text('Seleccione un tipo de documento ... '),
      value: 0
    ));

    _documentTypes.forEach((docuemtType) {
      list.add(DropdownMenuItem(
        child: Text(docuemtType.description),
        value: docuemtType.id
      ));
    });
    return list;
  }

  void _takePicture() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    Response? response = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TakePictureScreen(camera: firstCamera)
      )
    );
    if(response != null) {
      setState(() {
        _photoChanged = true;
        _image = response.result;
      });
    }
  }

  void _selectPicture() async {
    final ImagePicker _picker = ImagePicker(); 
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery
    );
    if(image != null) {
      setState(() {
        _photoChanged = true;
        _image = image;
      });       
    }
  }
}