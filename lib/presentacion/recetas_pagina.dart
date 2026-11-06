import 'package:flutter/material.dart';
import 'package:recetario_utez/presentacion/recetas_view_model.dart';
import 'package:recetario_utez/presentacion/tarjeta_receta.dart';

class RecetasPagina extends StatefulWidget {
  const RecetasPagina({super.key, required this.vm});

  final RecetasViewModel vm;

  @override
  State<RecetasPagina> createState() => _RecetasPaginaState();
}

class _RecetasPaginaState extends State<RecetasPagina> {
  final _controlador = TextEditingController();

  void _buscar() => widget.vm.buscar(_controlador.text);

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetario UTEZ')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListenableBuilder(
          listenable: widget.vm,
          builder: (context, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                key: const Key('busqueda'),
                controller: _controlador,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _buscar(),
                decoration: const InputDecoration(
                  labelText: 'Receta',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('buscar'),
                onPressed: widget.vm.cargando ? null : _buscar,
                child: const Text('Buscar recetas'),
              ),
              const SizedBox(height: 16),
              Expanded(child: _contenido(widget.vm.estado)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contenido(EstadoRecetas estado) {
    return switch (estado) {
      RecetasInicial() => const Center(
        child: Text('Escribe una receta o déjalo vacío y toca Buscar recetas.'),
      ),
      RecetasCargando() => const Center(child: CircularProgressIndicator()),
      RecetasVacias(:final busqueda) => Center(
        child: Text(
          busqueda.isEmpty
              ? 'No hay recetas disponibles.'
              : 'No encontramos recetas para "$busqueda".',
        ),
      ),
      RecetasFallidas(:final mensaje) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: widget.vm.reintentar,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
      RecetasListas(:final recetas, :final total) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Mostrando ${recetas.length} de $total recetas · '
            'Rápidas: ${widget.vm.rapidas}',
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [for (final r in recetas) TarjetaReceta(receta: r)],
            ),
          ),
        ],
      ),
    };
  }
}
