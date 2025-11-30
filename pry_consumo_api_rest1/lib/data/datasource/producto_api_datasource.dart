//Consume la api con http + Future
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_datasource.dart';
import '../models/producto_model.dart';

class ProductoApiDataSource implements BaseDataSource {
  final String baseURL = "http://10.40.24.75:3000/api/productos/";

  @override
  Future<List<ProductoModel>> fetchProductos() async {
    final uri = Uri.parse(baseURL);
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception("Error al obtener datos de la api");
    }

    //decodificación JSON
    final List data = json.decode(resp.body);

    //mapear el JSON a modelo
    return data.map((item) => ProductoModel.fromJson(item)).toList();
  }

  @override
  Future<ProductoModel> createProducto(ProductoModel producto) async {
    final uri = Uri.parse(baseURL);
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': producto.nombre,
        'descripcion': producto.descripcion,
        'precio': producto.precio,
        'stock': producto.stock,
      }),
    );

    if (resp.statusCode != 201 && resp.statusCode != 200) {
      throw Exception("Error al crear producto");
    }

    final data = json.decode(resp.body);
    return ProductoModel.fromJson(data);
  }

  @override
  Future<ProductoModel> updateProducto(
    String id,
    ProductoModel producto,
  ) async {
    final uri = Uri.parse('$baseURL$id');
    final resp = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': producto.nombre,
        'descripcion': producto.descripcion,
        'precio': producto.precio,
        'stock': producto.stock,
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception("Error al actualizar producto");
    }

    final data = json.decode(resp.body);
    return ProductoModel.fromJson(data);
  }

  @override
  Future<void> deleteProducto(String id) async {
    final uri = Uri.parse('$baseURL$id');
    final resp = await http.delete(uri);

    if (resp.statusCode != 200 && resp.statusCode != 204) {
      throw Exception("Error al eliminar producto");
    }
  }

  @override
  Future<ProductoModel> getProductoById(String id) async {
    final uri = Uri.parse('$baseURL$id');
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception("Error al obtener producto");
    }

    final data = json.decode(resp.body);
    return ProductoModel.fromJson(data);
  }
}
