import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../providers.dart';
import '../captura/captura_page.dart';
import '../historico/historico_page.dart';

class SelecaoPage extends ConsumerWidget {
  const SelecaoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(analiseSessionProvider);
    final pronto = session.variedade != null && session.modo != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('BPSEE'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Histórico',
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const HistoricoPage())),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Variedade fotografada',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            DropdownButton<Variedade>(
              value: session.variedade,
              hint: const Text('Escolha a variedade'),
              isExpanded: true,
              items: Variedade.values
                  .map((v) => DropdownMenuItem(value: v, child: Text(v.label)))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  ref.read(analiseSessionProvider.notifier).setVariedade(v);
                }
              },
            ),
            const SizedBox(height: 24),
            Text('Modo de captura',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: Modo.values
                  .map((m) => ChoiceChip(
                        label: Text(m.label),
                        selected: session.modo == m,
                        onSelected: (_) =>
                            ref.read(analiseSessionProvider.notifier).setModo(m),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            if (session.modo != null)
              Text(_descricaoModo(session.modo!),
                  style: Theme.of(context).textTheme.bodyMedium),
            const Spacer(),
            FilledButton(
              onPressed: pronto
                  ? () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const CapturaPage()))
                  : null,
              child: const Text('Continuar'),
            ),
          ],
        ),
      ),
    );
  }

  String _descricaoModo(Modo m) {
    switch (m) {
      case Modo.arvore:
        return 'Modo Árvore: contagem de frutos, maturação, estimativa e saúde geral.';
      case Modo.folha:
        return 'Modo Folha: detecção de greening (HLB) em folha próxima.';
      case Modo.fruta:
        return 'Modo Fruta: detecção de greening (HLB) em fruta próxima.';
    }
  }
}
