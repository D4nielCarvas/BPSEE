import '../database/database.dart';
import '../models/analise_model.dart';

class AnaliseRepository {
  final AppDatabase _db;
  AnaliseRepository(this._db);

  Future<int> salvar(AnaliseModel a) => _db.insertAnalise(a.toMap());

  Future<List<AnaliseModel>> listar() async {
    final rows = await _db.listAnalises();
    return rows.map(AnaliseModel.fromMap).toList();
  }

  Future<int> remover(int id) => _db.deleteAnalise(id);
}
