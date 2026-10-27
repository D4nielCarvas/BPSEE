import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants.dart';
import 'data/database/database.dart';
import 'data/models/analise_model.dart';
import 'data/repositories/analise_repository.dart';
import 'features/analise/analise_service.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final analiseRepositoryProvider = Provider<AnaliseRepository>(
    (ref) => AnaliseRepository(ref.read(databaseProvider)));
final analiseServiceProvider =
    Provider<AnaliseService>((ref) => AnaliseService());

/// Sessão de análise em andamento (variedade → modo → foto → resultado).
class AnaliseSessionNotifier extends Notifier<AnaliseSessionState> {
  @override
  AnaliseSessionState build() => const AnaliseSessionState();

  void setVariedade(Variedade v) => state = state.copyWith(variedade: v);
  void setModo(Modo m) => state = state.copyWith(modo: m);
  void setImage(String p) => state = state.copyWith(imagePath: p);
  void setResultado(AnaliseResult r) => state = state.copyWith(resultado: r);
  void setProcessing(bool b) => state = state.copyWith(processing: b);
  void reset() => state = const AnaliseSessionState();
}

final analiseSessionProvider =
    NotifierProvider<AnaliseSessionNotifier, AnaliseSessionState>(
        AnaliseSessionNotifier.new);
