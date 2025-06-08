import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';
import '../../../../core/usecases/usecase.dart';

class GetProductByStockStatus extends UseCase<List<ProductEntity>, bool>
{
    final ProductRepository repository;

    GetProductByStockStatus(this.repository);

    @override
    Future<List<ProductEntity>> call(bool inStock) async
    {
        return await repository.getProductsByStockStatus(inStock);
    }
}