import express from "express";
import cors from "cors";
import { connectDB } from "./config/mongo.js";
import productoRoutes from "./routes/productoRoutes.js";
import pedidoRoutes from "./routes/pedidoRoutes.js";
import 'dotenv/config';

const app = express();
app.use(cors());
app.use(express.json());

app.use("/api/productos", productoRoutes);
app.use("/api/pedidos", pedidoRoutes);

await connectDB();

app.listen(process.env.PORT, () => console.log(`Servidor en puerto ${process.env.PORT}`));
