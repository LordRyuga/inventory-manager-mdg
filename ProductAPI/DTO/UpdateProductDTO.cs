using System.ComponentModel.DataAnnotations;

namespace ProductAPI.DTO
{
    public class UpdateProductDTO
    {
        [Required(ErrorMessage = "Product name is required")]
        [StringLength(100, ErrorMessage = "Product name cannot exceed 100 characters")]
        public string Name { get; set; } = string.Empty;

        [Required(ErrorMessage = "Category is required")]
        [StringLength(50, ErrorMessage = "Category cannot exceed 50 characters")]
        public string Category { get; set; } = string.Empty;

        [Range(0, int.MaxValue, ErrorMessage = "Quantity must be 0 or greater")]
        public int Quantity { get; set; }

        [Range(0.01, double.MaxValue, ErrorMessage = "Price must be greater than 0")]
        public decimal Price { get; set; }
    }
}
