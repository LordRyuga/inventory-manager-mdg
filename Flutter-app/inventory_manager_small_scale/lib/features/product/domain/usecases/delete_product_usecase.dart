import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteProductUsecase extends UseCase<void, int>
{
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<void> call(int id) async
  {
    return await repository.deleteProduct(id);
  }
}