using ProductAPI.DTO;
using ProductAPI.Models;
using ProductAPI.Repositories;

namespace ProductAPI.services
{
    namespace InventoryManagement.Services
    {
        public class ProductService : IProductService
        {
            private readonly IProductRepository _productRepository;

            public ProductService(IProductRepository productRepository)
            {
                _productRepository = productRepository;
            }

            public async Task<IEnumerable<ProductDTO>> GetAllProductsAsync()
            {
                var products = await _productRepository.GetAllAsync();
                return products.Select(MapToDto);
            }

            public async Task<ProductDTO?> GetProductByIdAsync(int id)
            {
                var product = await _productRepository.GetByIdAsync(id);
                return product != null ? MapToDto(product) : null;
            }

            public async Task<IEnumerable<ProductDTO>> GetProductsByCategoryAsync(string category)
            {
                var products = await _productRepository.GetByCategoryAsync(category);
                return products.Select(MapToDto);
            }

            public async Task<IEnumerable<ProductDTO>> GetProductsByStockStatusAsync(bool inStock)
            {
                var products = await _productRepository.GetByStockStatusAsync(inStock);
                return products.Select(MapToDto);
            }

            public async Task<IEnumerable<string>> GetCategoriesAsync()
            {
                return await _productRepository.GetCategoriesAsync();
            }

            public async Task<ProductDTO> CreateProductAsync(CreateProductDTO createProductDto)
            {
                var product = new Product
                {
                    Name = createProductDto.Name.Trim(),
                    Category = createProductDto.Category.Trim(),
                    Quantity = createProductDto.Quantity,
                    Price = createProductDto.Price
                };

                var createdProduct = await _productRepository.CreateAsync(product);
                return MapToDto(createdProduct);
            }

            public async Task<ProductDTO?> UpdateProductAsync(int id, UpdateProductDTO updateProductDto)
            {
                var productToUpdate = new Product
                {
                    Name = updateProductDto.Name.Trim(),
                    Category = updateProductDto.Category.Trim(),
                    Quantity = updateProductDto.Quantity,
                    Price = updateProductDto.Price
                };

                var updatedProduct = await _productRepository.UpdateAsync(id, productToUpdate);
                return updatedProduct != null ? MapToDto(updatedProduct) : null;
            }

            public async Task<bool> DeleteProductAsync(int id)
            {
                return await _productRepository.DeleteAsync(id);
            }

            public async Task<IEnumerable<ProductDTO>> SearchProductsAsync(string searchTerm)
            {
                if (string.IsNullOrWhiteSpace(searchTerm))
                    return await GetAllProductsAsync();

                var products = await _productRepository.SearchByNameAsync(searchTerm.Trim());
                return products.Select(MapToDto);
            }

            private static ProductDTO MapToDto(Product product)
            {
                return new ProductDTO
                {
                    Id = product.Id,
                    Name = product.Name,
                    Category = product.Category,
                    Quantity = product.Quantity,
                    Price = product.Price,
                    CreatedAt = product.CreatedAt,
                    UpdatedAt = product.UpdatedAt
                };
            }

            public async Task<Dictionary<string, object>> GetInventoryStatsAsync()
            {
                var allProducts = await _productRepository.GetAllAsync();
                var productList = allProducts.ToList();

                return new Dictionary<string, object>
                {
                    ["totalProducts"] = productList.Count,
                    ["totalValue"] = productList.Sum(p => p.Price * p.Quantity),
                    ["outOfStockCount"] = productList.Count(p => p.Quantity == 0),
                    ["lowStockCount"] = productList.Count(p => p.Quantity > 0 && p.Quantity <= 5),
                    ["categoriesCount"] = productList.Select(p => p.Category).Distinct().Count(),
                    ["averagePrice"] = productList.Count != 0 ? productList.Average(p => p.Price) : 0
                };
            }
            

        }
    }
}
