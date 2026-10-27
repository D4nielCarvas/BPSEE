import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../data/models/analise_model.dart';
import '../../providers.dart';
import '../historico/historico_page.dart';

class ResultadoPage extends ConsumerStatefulWidget {
  const ResultadoPage({super.key});

  @override
  ConsumerState<ResultadoPage> createState() => _ResultadoPageState();
}

class _ResultadoPageState extends ConsumerState<ResultadoPage> {
  bool _processando = true;
  AnaliseResult? _r;

  @override
  void initState() {
    super.initState();
    _analisar();
  }

  Future<void> _analisar() async {
    final s = ref.read(analiseSessionProvider);
    if (s.modo == null || s.imagePath == null) {
      if (mounted) setState(() => _processando = false);
      return;
    }
    final service = ref.read(analiseServiceProvider);
    final r = await service.analisar(
        File(s.imagePath!), s.modo!, s.variedade ?? Variedade.pera);
    ref.read(analiseSessionProvider.notifier).setResultado(r);
    if (mounted) {
      setState(() {
        _r = r;
        _processando = false;
      });
    }
  }

  Future<void> _salvar() async {
    final s = ref.read(analiseSessionProvider);
    if (_r == null || s.modo == null) return;
    final repo = ref.read(analiseRepositoryProvider);
    await repo.salvar(AnaliseModel(
      variedade: s.variedade ?? Variedade.pera,
      modo: s.modo!,
      data: DateTime.now(),
      imagePath: s.imagePath,
      resultado: _r!,
    ));
    ref.read(analiseSessionProvider.notifier).reset();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HistoricoPage()),
        (r) => r.isFirst,
      );
    }
  }

  void _descartar() {
    ref.read(analiseSessionProvider.notifier).reset();
    if (mounted) Navigator.popUntil(context, (r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(analiseSessionProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado')),
      body: _processando
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Analisando...'),
                ],
              ),
            )
          : _r == null
              ? const Center(child: Text('Não foi possível analisar.'))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (s.imagePath != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(File(s.imagePath!),
                            height: 220, fit: BoxFit.cover),
                      ),
                      const SizedBox(height: 12),
                    ],
                    _card('Variedade', s.variedade?.label ?? '-'),
                    _card('Modo', s.modo?.label ?? '-'),
                    if (_r!.mock)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Chip(
                          label: Text(
                              'Modo demonstração (modelo real ainda não treinado)',
                              style: Theme.of(context).textTheme.bodySmall),
                        ),
                      ),
                    if (_r!.modo.isDoenca)
                      _card(
                          'Diagnóstico',
                          _r!.doenca == DiagnosticoDoenca.greening
                              ? 'Greening (HLB) suspeito'
                              : 'Saudável')
                    else ...[
                      _card('Contagem de frutos', '${_r!.contagemFrutos ?? 0}'),
                      _card('Estimativa de frutos', '${_r!.estimativaFrutos ?? 0}'),
                      _card(
                          'Maturação',
                          _r!.maturacao == null
                              ? '-'
                              : _r!.maturacao!.entries
                                  .map((e) => '${_rotMaturacao(e.key)}: ${e.value}')
                                  .join('  ·  ')),
                      _card('Saúde da árvore',
                          _r!.saude == SaudeArvore.doente ? 'Doente' : 'Saudável'),
                    ],
                    _card('Confiança', '${(_r!.confianca * 100).toStringAsFixed(0)} %'),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                              onPressed: _salvar,
                              child: const Text('Salvar análise')),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                              onPressed: _descartar,
                              child: const Text('Descartar')),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }

  String _rotMaturacao(Maturacao m) => switch (m) {
        Maturacao.verde => 'Verde',
        Maturacao.maduro => 'Maduro',
        Maturacao.sobremaduro => 'Sobremaduro',
      };

  Widget _card(String titulo, String valor) => Card(
        child: ListTile(
          title: Text(titulo),
          subtitle: Text(valor,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ),
      );
}
