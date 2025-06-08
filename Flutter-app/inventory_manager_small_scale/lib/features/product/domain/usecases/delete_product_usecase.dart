import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class DeleteProductUsecase extends UseCase<void, ProductEntity>
{
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<void> call(ProductEntity product) async
  {
    return await repository.deleteProduct(product.id);
  }
}