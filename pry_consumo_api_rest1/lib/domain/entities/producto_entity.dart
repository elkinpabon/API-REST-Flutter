// Es el primer paso, en Domain/Entities definir la entidad
class ProductoEntity {
  //Definición de atributos según el diseño para mongoDB
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final int stock;

  //Constructor con atributos para su inicialización required
  ProductoEntity({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.stock,
  });
}
