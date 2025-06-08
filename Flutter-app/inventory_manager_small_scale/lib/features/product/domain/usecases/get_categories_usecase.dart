import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class GetCategoriesUseCase extends UseCase<List<String>, NoParams> {
  final ProductRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<List<String>> call(NoParams params) {
    return repository.getCategories();
  }
}
