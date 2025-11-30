import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../presentation/viewmodels/pedido_viewmodel.dart';
import '../../config/app_theme.dart';
import '../../data/models/pedido_model.dart';

class PedidosTab extends StatefulWidget {
  const PedidosTab({Key? key}) : super(key: key);

  @override
  State<PedidosTab> createState() => _PedidosTabState();
}

class _PedidosTabState extends State<PedidosTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<PedidoViewModel>().cargarPedidos());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PedidoViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if ((viewModel.error ?? '').isNotEmpty) {
            return _buildErrorWidget(viewModel.error ?? '');
          }

          if (viewModel.pedidos.isEmpty) {
            return _buildEmptyWidget();
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: viewModel.pedidos.length,
            itemBuilder: (context, index) {
              final pedido = viewModel.pedidos[index] as PedidoModel;
              return _buildPedidoCard(context, pedido, viewModel);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showPedidoModal(context, null),
        tooltip: 'Nuevo Pedido',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPedidoCard(
    BuildContext context,
    PedidoModel pedido,
    PedidoViewModel viewModel,
  ) {
    final estadoColor = pedido.estado == 'completado'
        ? AppTheme.successColor
        : pedido.estado == 'pendiente'
        ? AppTheme.warningColor
        : AppTheme.dangerColor;

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
                        'Pedido #${pedido.id.substring(0, 8)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Producto: ${pedido.productoId}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 32,
                  backgroundColor: estadoColor.withOpacity(0.2),
                  child: Icon(Icons.receipt, color: estadoColor, size: 32),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cantidad: ${pedido.cantidad}',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total: \$${pedido.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(pedido.estado.toUpperCase()),
                  backgroundColor: estadoColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: estadoColor,
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
                  onPressed: () => _showPedidoModal(context, pedido),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppTheme.dangerColor),
                  onPressed: () =>
                      _showDeleteConfirmation(context, pedido, viewModel),
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
          Icon(Icons.receipt_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No hay pedidos',
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

  void _showPedidoModal(BuildContext context, PedidoModel? pedido) {
    final isEditing = pedido != null;
    final productoIdController = TextEditingController(
      text: pedido?.productoId ?? '',
    );
    final cantidadController = TextEditingController(
      text: pedido?.cantidad.toString() ?? '',
    );
    final totalController = TextEditingController(
      text: pedido?.total.toString() ?? '',
    );
    String estadoSeleccionado = pedido?.estado ?? 'pendiente';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => Padding(
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
                  isEditing ? 'Editar Pedido' : 'Nuevo Pedido',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: productoIdController,
                  decoration: InputDecoration(
                    labelText: 'ID del Producto',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.shopping_bag),
                  ),
                  readOnly: isEditing,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.numbers),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: totalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Total',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  readOnly: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: estadoSeleccionado,
                  decoration: InputDecoration(
                    labelText: 'Estado',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.info),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'pendiente',
                      child: Text('Pendiente'),
                    ),
                    DropdownMenuItem(
                      value: 'completado',
                      child: Text('Completado'),
                    ),
                    DropdownMenuItem(
                      value: 'cancelado',
                      child: Text('Cancelado'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      estadoSeleccionado = value ?? 'pendiente';
                    });
                  },
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
                        onPressed: () => _guardarPedido(
                          context,
                          isEditing,
                          pedido?.id,
                          productoIdController.text,
                          int.tryParse(cantidadController.text) ?? 0,
                          double.tryParse(totalController.text) ?? 0,
                          estadoSeleccionado,
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
      ),
    );
  }

  void _guardarPedido(
    BuildContext context,
    bool isEditing,
    String? id,
    String productoId,
    int cantidad,
    double total,
    String estado,
  ) {
    if (productoId.isEmpty || cantidad <= 0 || total <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos correctamente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final viewModel = context.read<PedidoViewModel>();

    if (isEditing && id != null) {
      final pedidoActualizado = PedidoModel(
        id: id,
        productoId: productoId,
        cantidad: cantidad,
        total: total,
        estado: estado,
      );
      viewModel.actualizarPedido(pedidoActualizado);
    } else {
      final nuevoPedido = PedidoModel(
        id: '',
        productoId: productoId,
        cantidad: cantidad,
        total: total,
        estado: estado,
      );
      viewModel.crearPedido(nuevoPedido);
    }

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isEditing ? 'Pedido actualizado' : 'Pedido creado'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    PedidoModel pedido,
    PedidoViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Pedido'),
        content: Text(
          '¿Estás seguro de que deseas eliminar el pedido #${pedido.id.substring(0, 8)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              viewModel.eliminarPedido(pedido.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pedido eliminado'),
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
