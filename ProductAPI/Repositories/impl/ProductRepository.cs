using Microsoft.EntityFrameworkCore;
using ProductAPI.Data;
using ProductAPI.Models;

namespace ProductAPI.Repositories.impl
{
    public class ProductRepository : IProductRepository
    {
        private readonly InventoryContext _context;

        public ProductRepository(InventoryContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<Product>> GetAllAsync()
        {
            return await _context.Products
                .OrderBy(p => p.Name)
                .ToListAsync();
        }

        public async Task<Product?> GetByIdAsync(int id)
        {
            return await _context.Products
                .FirstOrDefaultAsync(p => p.Id == id);
        }

        public async Task<IEnumerable<Product>> GetByCategoryAsync(string category)
        {
            return await _context.Products
                .Where(p => p.Category.ToLower().Equals(category.ToLower()))
                .OrderBy(p => p.Name)
                .ToListAsync();
        }

        public async Task<IEnumerable<Product>> GetByStockStatusAsync(bool inStock)
        {
            return await _context.Products
                .Where(p => inStock ? p.Quantity > 0 : p.Quantity == 0)
                .OrderBy(p => p.Name)
                .ToListAsync();
        }

        public async Task<IEnumerable<string>> GetCategoriesAsync()
        {
            return await _context.Products
                .Select(p => p.Category)
                .Distinct()
                .OrderBy(c => c)
                .ToListAsync();
        }

        public async Task<Product> CreateAsync(Product product)
        {
            _context.Products.Add(product);
            await _context.SaveChangesAsync();
            return product;
        }

        public async Task<Product?> UpdateAsync(int id, Product product)
        {
            var existingProduct = await _context.Products.FindAsync(id);
            if (existingProduct == null)
                return null;

            existingProduct.Name = product.Name;
            existingProduct.Category = product.Category;
            existingProduct.Quantity = product.Quantity;
            existingProduct.Price = product.Price;
            existingProduct.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            return existingProduct;
        }


        public async Task<bool> DeleteAsync(int id)
        {
            var product = await _context.Products.FindAsync(id);
            if (product == null)
                return false;

            _context.Products.Remove(product);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ExistsAsync(int id)
        {
            return await _context.Products.AnyAsync(p => p.Id == id);
        }

        public async Task<IEnumerable<Product>> SearchByNameAsync(string searchTerm)
        {
            return await _context.Products
                .Where(p => p.Name.ToLower().Contains(searchTerm.ToLower()))
                .OrderBy(p => p.Name)
                .ToListAsync();
        }
    }
}
