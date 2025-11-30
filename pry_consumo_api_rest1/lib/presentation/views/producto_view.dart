import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../../data/models/producto_model.dart';

class ProductoView extends StatefulWidget {
  const ProductoView({Key? key}) : super(key: key);

  @override
  State<ProductoView> createState() => _ProductoViewState();
}

class _ProductoViewState extends State<ProductoView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductoViewModel>().cargarProductos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Productos'),
        backgroundColor: Colors.blue,
      ),
      body: Consumer<ProductoViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${viewModel.error}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => viewModel.cargarProductos(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.productos.isEmpty) {
            return const Center(child: Text('No hay productos'));
          }

          return ListView.builder(
            itemCount: viewModel.productos.length,
            itemBuilder: (context, index) {
              final producto = viewModel.productos[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(producto.nombre),
                  subtitle: Text(
                    'Precio: \$${producto.precio} | Stock: ${producto.stock}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _mostrarFormularioEditar(
                          context,
                          viewModel,
                          producto,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _confirmarEliminar(context, viewModel, producto.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarFormularioCrear(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _mostrarFormularioCrear(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _FormularioProducto(
        titulo: 'Crear Producto',
        onGuardar: (nombre, precio, stock, categoria) async {
          final viewModel = context.read<ProductoViewModel>();
          final producto = ProductoModel(
            id: '',
            nombre: nombre,
            descripcion: '',
            precio: double.parse(precio),
            stock: int.parse(stock),
          );
          await viewModel.crearProducto(producto);
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Producto creado')));
          }
        },
      ),
    );
  }

  void _mostrarFormularioEditar(
    BuildContext context,
    ProductoViewModel viewModel,
    producto,
  ) {
    showDialog(
      context: context,
      builder: (context) => _FormularioProducto(
        titulo: 'Editar Producto',
        nombreInicial: producto.nombre,
        precioInicial: producto.precio.toString(),
        stockInicial: producto.stock.toString(),
        categoriaInicial: '',
        onGuardar: (nombre, precio, stock, categoria) async {
          final productoActualizado = ProductoModel(
            id: producto.id,
            nombre: nombre,
            descripcion: '',
            precio: double.parse(precio),
            stock: int.parse(stock),
          );
          await viewModel.actualizarProducto(productoActualizado);
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Producto actualizado')),
            );
          }
        },
      ),
    );
  }

  void _confirmarEliminar(
    BuildContext context,
    ProductoViewModel viewModel,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Producto'),
        content: const Text('¿Estás seguro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await viewModel.eliminarProducto(id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Producto eliminado')),
                );
              }
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}

class _FormularioProducto extends StatefulWidget {
  final String titulo;
  final String? nombreInicial;
  final String? precioInicial;
  final String? stockInicial;
  final String? categoriaInicial;
  final Function(String, String, String, String) onGuardar;

  const _FormularioProducto({
    required this.titulo,
    required this.onGuardar,
    this.nombreInicial,
    this.precioInicial,
    this.stockInicial,
    this.categoriaInicial,
  });

  @override
  State<_FormularioProducto> createState() => _FormularioProductoState();
}

class _FormularioProductoState extends State<_FormularioProducto> {
  late TextEditingController _nombreCtrl;
  late TextEditingController _precioCtrl;
  late TextEditingController _stockCtrl;
  late TextEditingController _categoriaCtrl;

  @override
  void initState() {
    super.initState();
    _nombreCtrl = TextEditingController(text: widget.nombreInicial ?? '');
    _precioCtrl = TextEditingController(text: widget.precioInicial ?? '');
    _stockCtrl = TextEditingController(text: widget.stockInicial ?? '');
    _categoriaCtrl = TextEditingController(text: widget.categoriaInicial ?? '');
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    _categoriaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titulo),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _precioCtrl,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _stockCtrl,
              decoration: const InputDecoration(labelText: 'Stock'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _categoriaCtrl,
              decoration: const InputDecoration(labelText: 'Categoría'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            widget.onGuardar(
              _nombreCtrl.text,
              _precioCtrl.text,
              _stockCtrl.text,
              _categoriaCtrl.text,
            );
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
