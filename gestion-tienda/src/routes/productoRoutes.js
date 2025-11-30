import { Router } from "express";
import {
  crearProducto,
  listarProductos,
  obtenerProducto,
  actualizarProducto,
  eliminarProducto
} from "../controllers/productoController.js";

const r = Router();

r.post("/", crearProducto);
r.get("/", listarProductos);
r.get("/:id", obtenerProducto);
r.put("/:id", actualizarProducto);
r.delete("/:id", eliminarProducto);

export default r;
