import '../datasource/producto_api_datasource.dart';
import '../models/producto_model.dart';
import '../../domain/entities/producto_entity.dart';

class ProductoRepository {
  final ProductoApiDataSource _dataSource;

  ProductoRepository(this._dataSource);

  // Obtener todos los productos
  Future<List<ProductoEntity>> obtenerProductos() async {
    try {
      return await _dataSource.fetchProductos();
    } catch (e) {
      throw Exception("Error al obtener productos: $e");
    }
  }

  // Crear un nuevo producto
  Future<ProductoEntity> crearProducto({
    required String nombre,
    required String descripcion,
    required double precio,
    required int stock,
  }) async {
    try {
      final productoModel = ProductoModel(
        id: '',
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        stock: stock,
      );
      return await _dataSource.createProducto(productoModel);
    } catch (e) {
      throw Exception("Error al crear producto: $e");
    }
  }

  // Actualizar un producto
  Future<ProductoEntity> actualizarProducto({
    required String id,
    required String nombre,
    required String descripcion,
    required double precio,
    required int stock,
  }) async {
    try {
      final productoModel = ProductoModel(
        id: id,
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        stock: stock,
      );
      return await _dataSource.updateProducto(id, productoModel);
    } catch (e) {
      throw Exception("Error al actualizar producto: $e");
    }
  }

  // Eliminar un producto
  Future<void> eliminarProducto(String id) async {
    try {
      return await _dataSource.deleteProducto(id);
    } catch (e) {
      throw Exception("Error al eliminar producto: $e");
    }
  }

  // Obtener un producto por ID
  Future<ProductoEntity> obtenerProductoPorId(String id) async {
    try {
      return await _dataSource.getProductoById(id);
    } catch (e) {
      throw Exception("Error al obtener producto: $e");
    }
  }
}
