import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/analise_model.dart';
import '../../providers.dart';

class HistoricoPage extends ConsumerStatefulWidget {
  const HistoricoPage({super.key});

  @override
  ConsumerState<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends ConsumerState<HistoricoPage> {
  List<AnaliseModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    final repo = ref.read(analiseRepositoryProvider);
    final items = await repo.listar();
    if (mounted) {
      setState(() {
        _items = items;
        _loading = false;
      });
    }
  }

  Future<void> _remover(int id) async {
    await ref.read(analiseRepositoryProvider).remover(id);
    _carregar();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico')),
      body: _items.isEmpty
          ? const Center(child: Text('Nenhuma análise salva.'))
          : ListView.separated(
              itemCount: _items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (c, i) {
                final a = _items[i];
                return ListTile(
                  leading: const Icon(Icons.eco),
                  title: Text('${a.variedade.label} · ${a.modo.label}'),
                  subtitle: Text(
                      '${a.data.day}/${a.data.month}/${a.data.year} ${a.data.hour}:${a.data.minute.toString().padLeft(2, '0')}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _remover(a.id!),
                  ),
                );
              },
            ),
    );
  }
}
