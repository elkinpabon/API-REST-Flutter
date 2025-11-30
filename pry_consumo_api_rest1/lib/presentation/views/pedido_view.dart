import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pedido_viewmodel.dart';
import '../../data/models/pedido_model.dart';

class PedidoView extends StatefulWidget {
  const PedidoView({Key? key}) : super(key: key);

  @override
  State<PedidoView> createState() => _PedidoViewState();
}

class _PedidoViewState extends State<PedidoView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PedidoViewModel>().cargarPedidos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Pedidos'),
        backgroundColor: Colors.green,
      ),
      body: Consumer<PedidoViewModel>(
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
                    onPressed: () => viewModel.cargarPedidos(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (viewModel.pedidos.isEmpty) {
            return const Center(child: Text('No hay pedidos'));
          }

          return ListView.builder(
            itemCount: viewModel.pedidos.length,
            itemBuilder: (context, index) {
              final pedido = viewModel.pedidos[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text('Pedido: ${pedido.id}'),
                  subtitle: Text(
                    'Producto: ${pedido.productoId} | Cantidad: ${pedido.cantidad} | Total: \$${pedido.total}\nEstado: ${pedido.estado}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _mostrarFormularioEditar(
                          context,
                          viewModel,
                          pedido,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _confirmarEliminar(context, viewModel, pedido.id),
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
      builder: (context) => _FormularioPedido(
        titulo: 'Crear Pedido',
        onGuardar: (productoId, cantidad, total, estado) async {
          final viewModel = context.read<PedidoViewModel>();
          final pedido = PedidoModel(
            id: '',
            productoId: productoId,
            cantidad: int.parse(cantidad),
            total: double.parse(total),
            estado: estado,
          );
          await viewModel.crearPedido(pedido);
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Pedido creado')));
          }
        },
      ),
    );
  }

  void _mostrarFormularioEditar(
    BuildContext context,
    PedidoViewModel viewModel,
    pedido,
  ) {
    showDialog(
      context: context,
      builder: (context) => _FormularioPedido(
        titulo: 'Editar Pedido',
        productoIdInicial: pedido.productoId,
        cantidadInicial: pedido.cantidad.toString(),
        totalInicial: pedido.total.toString(),
        estadoInicial: pedido.estado,
        onGuardar: (productoId, cantidad, total, estado) async {
          final pedidoActualizado = PedidoModel(
            id: pedido.id,
            productoId: productoId,
            cantidad: int.parse(cantidad),
            total: double.parse(total),
            estado: estado,
          );
          await viewModel.actualizarPedido(pedidoActualizado);
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Pedido actualizado')));
          }
        },
      ),
    );
  }

  void _confirmarEliminar(
    BuildContext context,
    PedidoViewModel viewModel,
    String id,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Pedido'),
        content: const Text('¿Estás seguro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await viewModel.eliminarPedido(id);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pedido eliminado')),
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

class _FormularioPedido extends StatefulWidget {
  final String titulo;
  final String? productoIdInicial;
  final String? cantidadInicial;
  final String? totalInicial;
  final String? estadoInicial;
  final Function(String, String, String, String) onGuardar;

  const _FormularioPedido({
    required this.titulo,
    required this.onGuardar,
    this.productoIdInicial,
    this.cantidadInicial,
    this.totalInicial,
    this.estadoInicial,
  });

  @override
  State<_FormularioPedido> createState() => _FormularioPedidoState();
}

class _FormularioPedidoState extends State<_FormularioPedido> {
  late TextEditingController _productoIdCtrl;
  late TextEditingController _cantidadCtrl;
  late TextEditingController _totalCtrl;
  late TextEditingController _estadoCtrl;

  @override
  void initState() {
    super.initState();
    _productoIdCtrl = TextEditingController(
      text: widget.productoIdInicial ?? '',
    );
    _cantidadCtrl = TextEditingController(text: widget.cantidadInicial ?? '');
    _totalCtrl = TextEditingController(text: widget.totalInicial ?? '');
    _estadoCtrl = TextEditingController(
      text: widget.estadoInicial ?? 'pendiente',
    );
  }

  @override
  void dispose() {
    _productoIdCtrl.dispose();
    _cantidadCtrl.dispose();
    _totalCtrl.dispose();
    _estadoCtrl.dispose();
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
              controller: _productoIdCtrl,
              decoration: const InputDecoration(labelText: 'ID Producto'),
            ),
            TextField(
              controller: _cantidadCtrl,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _totalCtrl,
              decoration: const InputDecoration(labelText: 'Total'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _estadoCtrl,
              decoration: const InputDecoration(labelText: 'Estado'),
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
              _productoIdCtrl.text,
              _cantidadCtrl.text,
              _totalCtrl.text,
              _estadoCtrl.text,
            );
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
