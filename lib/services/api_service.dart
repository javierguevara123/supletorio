import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supletorio/models/producto.dart';

class ApiService {
  final String baseUrl = "https://10.0.2.2:7176";

  String? _token;

  Future<bool> login(String usuario, String password) async {
    final url = Uri.parse("$baseUrl/user/Login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": usuario, // Ajusta según lo que pida tu API
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Asumimos que la API devuelve algo como { "token": "eyJh..." }
        _token = data['accessToken'];
        return true;
      } else {
        print("Error login: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error conexión login: $e");
      return false;
    }
  }

  Map<String, String> _getHeaders() {
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  //GET PRODUCTOS

  Future<List<Producto>> getProductos() async {
    if (_token == null) throw Exception('No hay token. Inicia sesión primero.');

    final url = Uri.parse("$baseUrl/api/products?PageNumber=1&PageSize=100&OrderDescending=true");

    final respuesta = await http.get(
      url,
      headers: _getHeaders(),
    );

    if (respuesta.statusCode == 200) {
      final Map<String, dynamic> respuestaJson = jsonDecode(respuesta.body);
      final List<dynamic> listaItems = respuestaJson['items']; 
      return listaItems.map((e) => Producto.fromJson(e)).toList();
    } else {
      throw Exception('Error: ${respuesta.statusCode} - ${respuesta.body}');
    }
  }

  //INSERTAR PRODUCTOS

  Future<bool> crearProducto(Producto producto) async {
    final Map<String, dynamic> data = {
      "name": producto.name,
      "unitsInStock": producto.unitsInStock,
      "unitPrice": producto.unitPrice,
    };

    final respuesta = await http.post(
      Uri.parse("$baseUrl/CreateProduct"),
      headers: _getHeaders(),
      body: jsonEncode(data),
    );

    return respuesta.statusCode == 200 || respuesta.statusCode == 201;
  }

  //ACTUALIZAR PRODUCTOS

  Future<bool> actualizarProducto(Producto producto) async {
    final respuesta = await http.put(
      Uri.parse("$baseUrl/UpdateProduct/${producto.id}"),
      headers: _getHeaders(),
      body: jsonEncode(producto.toJson()),
    );
    return respuesta.statusCode == 200;
  }

  Future<bool> eliminarProducto(int id) async {
    final respuesta = await http.delete(
      Uri.parse("$baseUrl/DeleteProduct/$id"),
      headers: _getHeaders(),
    );
    return respuesta.statusCode == 200;
  }
}
