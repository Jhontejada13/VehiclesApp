import 'dart:convert';

import 'package:vehicles_app/models/brand.dart';
import 'package:vehicles_app/models/document_type.dart';
import 'package:vehicles_app/models/procedure.dart';
import 'package:vehicles_app/models/response.dart';
import 'package:vehicles_app/models/user.dart';
import 'package:vehicles_app/models/vehicle_type.dart';

import 'constants.dart';
import 'package:http/http.dart' as http;

class ApiHelper {

  static Future<Response> getProcedures(String token) async {
    var url = Uri.parse('${Constants.apiUrl}/api/procedures');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer $token'
      }
    );

    var body = response.body;

    if(response.statusCode >= 400){
      return Response(isSucces: false, message: body);
    }

    List<Procedure> list = [];
    var decodedJson = jsonDecode(body);
    if(decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Procedure.fromJson(item));
      }
    }

    return Response(isSucces: true, result: list);
  }

  static Future<Response> put(String controller, String id, Map<String, dynamic> request, String token) async {
    var url = Uri.parse('${Constants.apiUrl}$controller$id');
    var response = await http.put(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer $token'
      },
      body: jsonEncode(request),
    );

    if(response.statusCode >= 400){
      return Response(isSucces: false, message: response.body);
    }

    return Response(isSucces: true);
  }

  static Future<Response> post(String controller, Map<String, dynamic> request, String token) async {
    var url = Uri.parse('${Constants.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer $token'
      },
      body: jsonEncode(request),
    );

    if(response.statusCode >= 400){
      return Response(isSucces: false, message: response.body);
    }

    return Response(isSucces: true);
  }

  static Future<Response> delete(String controller, String id, String token) async {
    var url = Uri.parse('${Constants.apiUrl}$controller$id');
    var response = await http.delete(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer $token'
      },
    );

    if(response.statusCode >= 400){
      return Response(isSucces: false, message: response.body);
    }

    return Response(isSucces: true);
  }

  static Future<Response> getBrands(String token) async {
    var url = Uri.parse('${Constants.apiUrl}/api/Brands');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer $token'
      }
    );

    var body = response.body;

    if(response.statusCode >= 400){
      return Response(isSucces: false, message: body);
    }

    List<Brand> list = [];
    var decodedJson = jsonDecode(body);
    if(decodedJson != null) {
      for (var item in decodedJson) {
        list.add(Brand.fromJson(item));
      }
    }

    return Response(isSucces: true, result: list);
  }

  static Future<Response> getDocumentTypes(String token) async {
    var url = Uri.parse('${Constants.apiUrl}/api/DocumentTypes');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer $token'
      }
    );

    var body = response.body;

    if(response.statusCode >= 400){
      return Response(isSucces: false, message: body);
    }

    List<DocumentType> list = [];
    var decodedJson = jsonDecode(body);
    if(decodedJson != null) {
      for (var item in decodedJson) {
        list.add(DocumentType.fromJson(item));
      }
    }

    return Response(isSucces: true, result: list);
  }

  static Future<Response> getVehicleTypes(String token) async {
    var url = Uri.parse('${Constants.apiUrl}/api/VehicleTypes');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer $token'
      }
    );

    var body = response.body;

    if(response.statusCode >= 400){
      return Response(isSucces: false, message: body);
    }

    List<VehicleType> list = [];
    var decodedJson = jsonDecode(body);
    if(decodedJson != null) {
      for (var item in decodedJson) {
        list.add(VehicleType.fromJson(item));
      }
    }

    return Response(isSucces: true, result: list);
  }

  static Future<Response> getUsers(String token) async {
    var url = Uri.parse('${Constants.apiUrl}/api/Users');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer $token'
      }
    );

    var body = response.body;

    if(response.statusCode >= 400){
      return Response(isSucces: false, message: body);
    }

    List<User> list = [];
    var decodedJson = jsonDecode(body);
    if(decodedJson != null) {
      for (var item in decodedJson) {
        list.add(User.fromJson(item));
      }
    }

    return Response(isSucces: true, result: list);
  }
  
}
