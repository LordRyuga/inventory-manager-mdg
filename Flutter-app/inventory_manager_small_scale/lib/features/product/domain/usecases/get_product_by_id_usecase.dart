import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';


class GetProductByIdUsecase extends UseCase<ProductEntity, int> {
  final ProductRepository repository;

  GetProductByIdUsecase(this.repository);

  @override
  Future<ProductEntity> call(int id) async 
  {
    return await repository.getProductById(id);
  }
}