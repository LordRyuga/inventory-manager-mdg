using ProductAPI.DTO;
using ProductAPI.Repositories;

namespace ProductAPI.services
{
    public interface IProductService
    {
        Task<IEnumerable<ProductDTO>> GetAllProductsAsync();
        Task<ProductDTO?> GetProductByIdAsync(int id);
        Task<IEnumerable<ProductDTO>> GetProductsByCategoryAsync(string category);
        Task<IEnumerable<ProductDTO>> GetProductsByStockStatusAsync(bool inStock);
        Task<IEnumerable<string>> GetCategoriesAsync();
        Task<ProductDTO> CreateProductAsync(CreateProductDTO createProductDto);
        Task<ProductDTO?> UpdateProductAsync(int id, UpdateProductDTO updateProductDto);
        Task<bool> DeleteProductAsync(int id);
        Task<IEnumerable<ProductDTO>> SearchProductsAsync(string searchTerm);
        Task<Dictionary<string, object>> GetInventoryStatsAsync();
    }
}
