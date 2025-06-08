import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class GetStatsUseCase extends UseCase<Map<String, dynamic>, NoParams> {
  final ProductRepository repository;

  GetStatsUseCase(this.repository);

  @override
  Future<Map<String, dynamic>> call(NoParams params) async {
    return await repository.getStats();
  }
}