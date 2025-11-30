import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pedido_model.dart';

class PedidoApiDataSource {
  final String baseURL = "http://10.40.24.75:3000/api/pedidos/";

  // Obtener todos los pedidos
  Future<List<PedidoModel>> fetchPedidos() async {
    final uri = Uri.parse(baseURL);
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception("Error al obtener pedidos");
    }

    final List data = json.decode(resp.body);
    return data.map((item) => PedidoModel.fromJson(item)).toList();
  }

  // Crear un pedido
  Future<PedidoModel> createPedido(PedidoModel pedido) async {
    final uri = Uri.parse(baseURL);
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pedido.toJson()),
    );

    if (resp.statusCode != 201 && resp.statusCode != 200) {
      throw Exception("Error al crear pedido");
    }

    final data = json.decode(resp.body);
    return PedidoModel.fromJson(data);
  }

  // Actualizar un pedido
  Future<PedidoModel> updatePedido(String id, PedidoModel pedido) async {
    final uri = Uri.parse('$baseURL$id');
    final resp = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pedido.toJson()),
    );

    if (resp.statusCode != 200) {
      throw Exception("Error al actualizar pedido");
    }

    final data = json.decode(resp.body);
    return PedidoModel.fromJson(data);
  }

  // Eliminar un pedido
  Future<void> deletePedido(String id) async {
    final uri = Uri.parse('$baseURL$id');
    final resp = await http.delete(uri);

    if (resp.statusCode != 200 && resp.statusCode != 204) {
      throw Exception("Error al eliminar pedido");
    }
  }

  // Obtener un pedido por ID
  Future<PedidoModel> getPedidoById(String id) async {
    final uri = Uri.parse('$baseURL$id');
    final resp = await http.get(uri);

    if (resp.statusCode != 200) {
      throw Exception("Error al obtener pedido");
    }

    final data = json.decode(resp.body);
    return PedidoModel.fromJson(data);
  }
}
