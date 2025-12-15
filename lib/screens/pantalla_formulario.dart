import 'package:flutter/material.dart';
import 'package:s1_listatareas/models/tarea.dart';

class PantallaFormulario extends StatefulWidget {
  final Producto? producto;
  const PantallaFormulario({super.key, this.producto});

  @override
  State<PantallaFormulario> createState() => _PantallaFormularioState();
}

class _PantallaFormularioState extends State<PantallaFormulario> {
  final _nameController = TextEditingController();
  final _stockController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.producto != null) {
      _nameController.text = widget.producto!.name;
      _stockController.text = widget.producto!.unitsInStock.toString();
      _priceController.text = widget.producto!.unitPrice.toString();
    }
  }

  void _guardar() {
    if (_nameController.text.isEmpty ||
        _stockController.text.isEmpty ||
        _priceController.text.isEmpty)
      return;
    final nuevoProducto = Producto(
      id: widget.producto?.id ?? 0,
      name: _nameController.text,
      unitsInStock: int.parse(_stockController.text),
      unitPrice: double.parse(_priceController.text),
    );

    Navigator.pop(context, nuevoProducto);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.producto == null ? 'Nueva Producto' : 'Editar Producto',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Producto',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Unidades (Stock)'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _stockController,
              decoration: const InputDecoration(labelText: 'Precio Unitario'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _guardar, child: const Text('Guardar')),
          ],
        ),
      ),
    );
  }
}
