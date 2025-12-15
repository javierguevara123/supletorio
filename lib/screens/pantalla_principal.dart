import 'package:flutter/material.dart';
import 'package:s1_listatareas/models/tarea.dart';
import 'package:s1_listatareas/screens/pantalla_formulario.dart';
import 'package:s1_listatareas/services/api_service.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final ApiService apiService = ApiService();
  List<Producto> productos = [];
  bool isLoading = true;
  String mensajeEstado = "Iniciando sesión...";

  @override
  void initState() {
    super.initState();
    _inicializarApp();
  }

  void _inicializarApp() async {
    bool logueado = await apiService.login(
      "superuser@northwind.com",
      "SuperUser123!",
    );

    if (logueado) {
      _cargarProductos();
    } else {
      setState(() {
        isLoading = false;
        mensajeEstado = "Fallo al iniciar sesión. Revisa usuario/pass.";
      });
    }
  }

  void _cargarProductos() async {
    try {
      setState(() => mensajeEstado = "Cargando productos...");
      final lista = await apiService.getProductos();
      setState(() {
        productos = lista;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        mensajeEstado = "Error: $e";
      });
    }
  }

  void _navegarAlFormulario({Producto? productoExistente}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaFormulario(producto: productoExistente),
      ),
    );

    if (resultado != null && resultado is Producto) {
      setState(() => isLoading = true);
      if (productoExistente != null) {
        //EDITAR
        await apiService.actualizarProducto(resultado);
      } else {
        //CREAR
        await apiService.crearProducto(resultado);
      }
      _cargarProductos();
    }
  }

  void _eliminar(int id) async {
    setState(() => isLoading = true);
    await apiService.eliminarProducto(id);
    _cargarProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventario")),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(mensajeEstado),
                ],
              ),
            )
          : productos.isEmpty
          ? Center(child: Text(mensajeEstado))
          : ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final item = productos[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      item.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Stock: ${item.unitsInStock} | Precio: \$${item.unitPrice}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _eliminar(item.id),
                    ),
                    onTap: () => _navegarAlFormulario(productoExistente: item),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _navegarAlFormulario(),
      ),
    );
  }
}
