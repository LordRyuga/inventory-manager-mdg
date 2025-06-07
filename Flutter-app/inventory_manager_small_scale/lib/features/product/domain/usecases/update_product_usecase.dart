import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class UpdateProductUsecase extends UseCase<void, ProductEntity>
{
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<void> call(ProductEntity product) async
  {
    return await repository.updateProduct(product);
  }
}