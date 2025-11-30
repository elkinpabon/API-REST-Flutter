import mongoose from "mongoose";
const { Schema, model } = mongoose;

const pedidoSchema = new Schema({
  productoId: { type: String, required: true },
  cantidad: { type: Number, required: true },
  total: { type: Number, required: true },
  estado: { type: String, required: true, default: "pendiente" }
}, { timestamps: true });

export const Pedido = model("Pedido", pedidoSchema);
