import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllProductsUsecase extends UseCase<List<ProductEntity>, NoParams>{
  final ProductRepository repository;

  GetAllProductsUsecase(this.repository);

  @override
  Future<List<ProductEntity>> call(NoParams params) async
  {
    return await repository.getAllProducts();
  } 

}