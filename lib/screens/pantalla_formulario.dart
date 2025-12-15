import 'package:flutter/material.dart';
import 'package:supletorio/models/tarea.dart';

class PantallaFormulario extends StatefulWidget {
  final Tarea? tarea;
  const PantallaFormulario({super.key, this.tarea});

  @override
  State<PantallaFormulario> createState() => _PantallaFormularioState();
}

class _PantallaFormularioState extends State<PantallaFormulario> {
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.tarea != null) {
      _tituloController.text = widget.tarea!.titulo;
      _descripcionController.text = widget.tarea!.descripcion;
    }
  }

  void _guardar() {
    if (_tituloController.text.isEmpty) return;
    final nuevaTarea = Tarea(
      id: widget.tarea?.id ?? DateTime.now().toString(),
      titulo: _tituloController.text,
      descripcion: _descripcionController.text,
    );

    Navigator.pop(context, nuevaTarea);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tarea == null ? 'Nueva Tarea' : 'Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Titulo'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(labelText: 'Descripcion'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
