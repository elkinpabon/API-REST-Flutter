import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/viewmodels/producto_viewmodel.dart';
import '../../config/app_theme.dart';
import '../../data/models/producto_model.dart';

class ProductosTab extends StatefulWidget {
  const ProductosTab({Key? key}) : super(key: key);

  @override
  State<ProductosTab> createState() => _ProductosTabState();
}

class _ProductosTabState extends State<ProductosTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductoViewModel>().cargarProductos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductoViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if ((viewModel.error ?? '').isNotEmpty) {
            return _buildErrorWidget(viewModel.error ?? '');
          }

          if (viewModel.productos.isEmpty) {
            return _buildEmptyWidget();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: viewModel.productos.length,
            itemBuilder: (context, index) {
              final producto = viewModel.productos[index];
              return _buildProductoCard(context, producto, viewModel);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductoModal(context, null),
        tooltip: 'Nuevo Producto',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProductoCard(
    BuildContext context,
    ProductoModel producto,
    ProductoViewModel viewModel,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        producto.nombre,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        producto.descripcion,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                  child: Icon(
                    Icons.shopping_cart,
                    color: AppTheme.primaryColor,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${producto.precio.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Chip(
                  label: Text('Stock: ${producto.stock}'),
                  backgroundColor: AppTheme.successColor.withOpacity(0.2),
                  labelStyle: const TextStyle(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
                  onPressed: () => _showProductoModal(context, producto),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppTheme.dangerColor),
                  onPressed: () =>
                      _showDeleteConfirmation(context, producto, viewModel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay productos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Presiona + para crear uno nuevo',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'Error al cargar',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductoModal(BuildContext context, ProductoModel? producto) {
    final isEditing = producto != null;
    final nombreController = TextEditingController(
      text: producto?.nombre ?? '',
    );
    final descripcionController = TextEditingController(
      text: producto?.descripcion ?? '',
    );
    final precioController = TextEditingController(
      text: producto?.precio.toString() ?? '',
    );
    final stockController = TextEditingController(
      text: producto?.stock.toString() ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? 'Editar Producto' : 'Nuevo Producto',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.label),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: precioController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Precio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.inventory),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                      label: const Text('Cancelar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[400],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _guardarProducto(
                        context,
                        isEditing,
                        producto?.id,
                        nombreController.text,
                        descripcionController.text,
                        double.tryParse(precioController.text) ?? 0,
                        int.tryParse(stockController.text) ?? 0,
                      ),
                      icon: Icon(isEditing ? Icons.edit : Icons.save),
                      label: Text(isEditing ? 'Actualizar' : 'Guardar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _guardarProducto(
    BuildContext context,
    bool isEditing,
    String? id,
    String nombre,
    String descripcion,
    double precio,
    int stock,
  ) {
    if (nombre.isEmpty || descripcion.isEmpty || precio <= 0 || stock < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos correctamente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final viewModel = context.read<ProductoViewModel>();

    if (isEditing && id != null) {
      final productoActualizado = ProductoModel(
        id: id,
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        stock: stock,
      );
      viewModel.actualizarProducto(productoActualizado);
    } else {
      final nuevoProducto = ProductoModel(
        id: '',
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        stock: stock,
      );
      viewModel.crearProducto(nuevoProducto);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Producto actualizado' : 'Producto creado'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    ProductoModel producto,
    ProductoViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: Text(
          '¿Estás seguro de que deseas eliminar "${producto.nombre}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              viewModel.eliminarProducto(producto.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Producto eliminado'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppTheme.dangerColor),
            ),
          ),
        ],
      ),
    );
  }
}
