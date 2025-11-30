import { Pedido } from "../models/pedido.js";

// Crear pedido
export const crearPedido = async (req, res) => {
  try {
    const pedido = await Pedido.create(req.body);
    res.status(201).json(pedido);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};

// Listar pedidos
export const listarPedidos = async (_req, res) => {
  try {
    const lista = await Pedido.find();
    res.json(lista);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};

// Obtener pedido por ID
export const obtenerPedido = async (req, res) => {
  try {
    const pedido = await Pedido.findById(req.params.id);
    if (!pedido) return res.status(404).json({ error: "Pedido no encontrado" });
    res.json(pedido);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};

// Actualizar pedido
export const actualizarPedido = async (req, res) => {
  try {
    const pedido = await Pedido.findByIdAndUpdate(req.params.id, req.body, { new: true });
    res.json(pedido);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};

// Eliminar pedido
export const eliminarPedido = async (req, res) => {
  try {
    const pedido = await Pedido.findByIdAndDelete(req.params.id);
    res.json({ eliminado: !!pedido });
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};
