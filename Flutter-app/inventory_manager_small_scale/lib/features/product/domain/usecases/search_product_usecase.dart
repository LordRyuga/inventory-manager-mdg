import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class GetProductBySearch extends UseCase<List<ProductEntity>, String>
{
    final ProductRepository repository;

    GetProductBySearch(this.repository);

    @override
    Future<List<ProductEntity>> call(String keyWord) async
    {
        return await repository.getProductsByCategory(keyWord);
    }
}