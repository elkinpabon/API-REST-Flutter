import { Producto } from "../models/producto.js";

// Crear producto
export const crearProducto = async (req, res) => {
  try {
    const prod = await Producto.create(req.body);
    res.status(201).json(prod);
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
};

// Listar productos
export const listarProductos = async (_req, res) => {
  const lista = await Producto.find();
  res.json(lista);
};

// Obtener producto por ID
export const obtenerProducto = async (req, res) => {
  const prod = await Producto.findById(req.params.id);
  if (!prod) return res.status(404).json({ error: "Producto no encontrado" });
  res.json(prod);
};

// Actualizar producto
export const actualizarProducto = async (req, res) => {
  const prod = await Producto.findByIdAndUpdate(req.params.id, req.body, { new: true });
  res.json(prod);
};

// Eliminar producto
export const eliminarProducto = async (req, res) => {
  const prod = await Producto.findByIdAndDelete(req.params.id);
  res.json({ eliminado: !!prod });
};
