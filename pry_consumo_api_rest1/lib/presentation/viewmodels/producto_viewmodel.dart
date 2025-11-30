import 'package:flutter/foundation.dart';
import '../../data/repositories/producto_repository.dart';
import '../../data/models/producto_model.dart';

class ProductoViewModel extends ChangeNotifier {
  final ProductoRepository _repository;

  ProductoViewModel(this._repository);

  // Estados
  List<ProductoModel> _productos = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ProductoModel> get productos => _productos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Obtener todos los productos
  Future<void> cargarProductos() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final productosEntities = await _repository.obtenerProductos();
      _productos = productosEntities.cast<ProductoModel>();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Crear producto
  Future<void> crearProducto(ProductoModel producto) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final nuevoProducto =
          await _repository.crearProducto(
                nombre: producto.nombre,
                descripcion: producto.descripcion,
                precio: producto.precio,
                stock: producto.stock,
              )
              as ProductoModel;
      _productos.add(nuevoProducto);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar producto
  Future<void> actualizarProducto(ProductoModel producto) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.actualizarProducto(
        id: producto.id,
        nombre: producto.nombre,
        descripcion: producto.descripcion,
        precio: producto.precio,
        stock: producto.stock,
      );

      final index = _productos.indexWhere((p) => p.id == producto.id);
      if (index >= 0) {
        _productos[index] = producto;
      }
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eliminar producto
  Future<void> eliminarProducto(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _repository.eliminarProducto(id);
      _productos.removeWhere((p) => p.id == id);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
