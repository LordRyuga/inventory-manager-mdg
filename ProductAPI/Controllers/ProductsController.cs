using ProductAPI.services;
using Microsoft.AspNetCore.Mvc;
using ProductAPI.DTO;
using System.ComponentModel.DataAnnotations;

namespace ProductAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ProductsController : ControllerBase
    {
        private readonly IProductService _productService;
        private readonly ILogger<ProductsController> _logger;

        public ProductsController(IProductService productService, ILogger<ProductsController> logger)
        {
            _productService = productService;
            _logger = logger;
        }

        [HttpGet]
        public async Task<ActionResult<ApiResponse<IEnumerable<ProductDTO>>>> GetProducts(
            [FromQuery] string? category = null,
            [FromQuery] bool? inStock = null,
            [FromQuery] string? search = null)
        {
            try
            {
                IEnumerable<ProductDTO> products;

                if (!string.IsNullOrWhiteSpace(search))
                {
                    products = await _productService.SearchProductsAsync(search);
                }
                else if (!string.IsNullOrWhiteSpace(category))
                {
                    products = await _productService.GetProductsByCategoryAsync(category);
                }
                else if (inStock.HasValue)
                {
                    products = await _productService.GetProductsByStockStatusAsync(inStock.Value);
                }
                else
                {
                    products = await _productService.GetAllProductsAsync();
                }

                return Ok(ApiResponse<IEnumerable<ProductDTO>>.SuccessResponse(products));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving products");
                return StatusCode(500, ApiResponse<IEnumerable<ProductDTO>>.ErrorResponse("An error occurred while retrieving products"));
            }
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<ApiResponse<ProductDTO>>> GetProduct(int id)
        {
            try
            {
                var product = await _productService.GetProductByIdAsync(id);

                if (product == null)
                {
                    return NotFound(ApiResponse<ProductDTO>.ErrorResponse($"Product with ID {id} not found"));
                }

                return Ok(ApiResponse<ProductDTO>.SuccessResponse(product));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving product {ProductId}", id);
                return StatusCode(500, ApiResponse<ProductDTO>.ErrorResponse("An error occurred while retrieving the product"));
            }
        }

        [HttpPost]
        public async Task<ActionResult<ApiResponse<ProductDTO>>> CreateProduct([FromBody] CreateProductDTO createProductDto)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values
                        .SelectMany(v => v.Errors)
                        .Select(e => e.ErrorMessage)
                        .ToList();

                    return BadRequest(ApiResponse<ProductDTO>.ErrorResponse("Validation failed", errors));
                }

                var product = await _productService.CreateProductAsync(createProductDto);
                return CreatedAtAction(
                    nameof(GetProduct),
                    new { id = product.Id },
                    ApiResponse<ProductDTO>.SuccessResponse(product, "Product created successfully"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error creating product");
                return StatusCode(500, ApiResponse<ProductDTO>.ErrorResponse("An error occurred while creating the product"));
            }
        }

        [HttpPut("{id}")]
        public async Task<ActionResult<ApiResponse<ProductDTO>>> UpdateProduct(int id, [FromBody] UpdateProductDTO updateProductDto)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    var errors = ModelState.Values
                        .SelectMany(v => v.Errors)
                        .Select(e => e.ErrorMessage)
                        .ToList();

                    return BadRequest(ApiResponse<ProductDTO>.ErrorResponse("Validation failed", errors));
                }

                var updatedProduct = await _productService.UpdateProductAsync(id, updateProductDto);

                if (updatedProduct == null)
                {
                    return NotFound(ApiResponse<ProductDTO>.ErrorResponse($"Product with ID {id} not found"));
                }

                return Ok(ApiResponse<ProductDTO>.SuccessResponse(updatedProduct, "Product updated successfully"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating product {ProductId}", id);
                return StatusCode(500, ApiResponse<ProductDTO>.ErrorResponse("An error occurred while updating the product"));
            }
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult<ApiResponse<object>>> DeleteProduct(int id)
        {
            try
            {
                var result = await _productService.DeleteProductAsync(id);

                if (!result)
                {
                    return NotFound(ApiResponse<object>.ErrorResponse($"Product with ID {id} not found"));
                }

                return Ok(ApiResponse<object>.SuccessResponse(null, "Product deleted successfully"));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting product {ProductId}", id);
                return StatusCode(500, ApiResponse<object>.ErrorResponse("An error occurred while deleting the product"));
            }
        }

        [HttpGet("categories")]
        public async Task<ActionResult<ApiResponse<IEnumerable<string>>>> GetCategories()
        {
            try
            {
                var categories = await _productService.GetCategoriesAsync();
                return Ok(ApiResponse<IEnumerable<string>>.SuccessResponse(categories));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving categories");
                return StatusCode(500, ApiResponse<IEnumerable<string>>.ErrorResponse("An error occurred while retrieving categories"));
            }
        }

        [HttpGet("stats")]
        public async Task<ActionResult<ApiResponse<Dictionary<string, object>>>> GetInventoryStats()
        {
            try
            {
                var stats = await _productService.GetInventoryStatsAsync();
                return Ok(ApiResponse<Dictionary<string, object>>.SuccessResponse(stats));
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving inventory stats");
                return StatusCode(500, ApiResponse<Dictionary<string, object>>.ErrorResponse("An error occurred while retrieving inventory statistics"));
            }
        }
    }
}