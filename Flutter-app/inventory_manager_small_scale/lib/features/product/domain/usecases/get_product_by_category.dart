import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class GetProductByCategory extends UseCase<List<ProductEntity>, String>
{
    final ProductRepository repository;

    GetProductByCategory(this.repository);

    @override
    Future<List<ProductEntity>> call(String category) async
    {
        return await repository.getProductsByCategory(category);
    }
}