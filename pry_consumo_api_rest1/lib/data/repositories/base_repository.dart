import '../../domain/entities/producto_entity.dart';

abstract class BaseRepository {
  Future<List<ProductoEntity>> getProductos();
}