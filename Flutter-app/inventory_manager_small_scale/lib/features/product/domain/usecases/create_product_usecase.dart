import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class CreateproductUsecase extends UseCase<void, ProductEntity> {
  final ProductRepository repository;

  CreateproductUsecase(this.repository);

  @override
  Future<void> call(ProductEntity product) async {
    return await repository.createProduct(product);
  }
}