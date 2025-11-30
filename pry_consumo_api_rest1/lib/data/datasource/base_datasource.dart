// Este Solo se encarga de enviar y extraer datos, no tiene nada de lógica
import '../models/producto_model.dart';

abstract class BaseDataSource {
  Future<List<ProductoModel>> fetchProductos();
  Future<ProductoModel> createProducto(ProductoModel producto);
  Future<ProductoModel> updateProducto(String id, ProductoModel producto);
  Future<void> deleteProducto(String id);
  Future<ProductoModel> getProductoById(String id);
}
