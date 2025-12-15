import 'package:flutter/material.dart';
import 'package:supletorio/models/tarea.dart';
import 'package:supletorio/screens/pantalla_formulario.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  List<Tarea> tareas = [];

  void _navegarAlFormulario({Tarea? tareaExistente}) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PantallaFormulario(tarea: tareaExistente),
      ),
    );

    if (resultado != null && resultado is Tarea) {
      setState(() {
        if (tareaExistente != null) {
          final index = tareas.indexWhere((t) => t.id == tareaExistente.id);
          tareas[index] = resultado;
        } else {
          tareas.add(resultado);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tareas')),
      body: tareas.isEmpty
          ? const Center(child: Text('Sin Tareas'))
          : ListView.builder(
              itemCount: tareas.length,
              itemBuilder: (context, index) {
                final item = tareas[index];
                return ListTile(
                  title: Text(item.titulo),
                  subtitle: Text(item.descripcion),
                  onTap: () => _navegarAlFormulario(tareaExistente: item),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        tareas.removeAt(index);
                      });
                    },
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
