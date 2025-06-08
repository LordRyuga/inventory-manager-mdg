import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_manager_small_scale/features/product/presentation/bloc/category_bloc.dart';
import '../bloc/product_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../../../../core/styles/app_styles.dart';
import '../../../../core/widgets/loading_widget.dart';

class AddEditProductPage extends StatefulWidget {
  final ProductEntity? product;

  const AddEditProductPage({super.key, this.product});

  @override
  State<AddEditProductPage> createState() => _AddEditProductPageState();
}

class _AddEditProductPageState extends State<AddEditProductPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  bool _isEditing = false;
  late List<String> _categories = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.product != null;

    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _categoryController = TextEditingController(text: widget.product?.category ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _quantityController = TextEditingController(text: widget.product?.quantity.toString() ?? '');

    if (widget.product != null) {
      _selectedCategory = widget.product!.category;
    }

    context.read<CategoryBloc>().add(GetCategoriesEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      final product = ProductEntity(
        id: widget.product?.id ?? 0,
        name: _nameController.text.trim(),
        category: _selectedCategory ?? _categoryController.text.trim(),
        quantity: int.parse(_quantityController.text),
        price: double.parse(_priceController.text),
      );

      if (_isEditing) {
        context.read<ProductBloc>().add(UpdateProductEvent(product));
      } else {
        context.read<ProductBloc>().add(CreateProductEvent(product));
      }
    }
  }

  Widget _buildCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Category', style: AppStyles.labelMedium),
        const SizedBox(height: AppStyles.spacingSM),
        _categories.isNotEmpty
            ? DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: AppStyles.inputDecoration(
                  labelText: '',
                  hintText: 'Select or enter category',
                ),
                items: [
                  ..._categories.map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      )),
                  const DropdownMenuItem(
                    value: 'custom',
                    child: Text('Add new category...'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    if (value == 'custom') {
                      _selectedCategory = null;
                    } else {
                      _selectedCategory = value;
                      _categoryController.text = value ?? '';
                    }
                  });
                },
                validator: (value) {
                  if (_selectedCategory == null && _categoryController.text.isEmpty) {
                    return 'Please select or create a category';
                  }
                  return null;
                },
              )
            : TextFormField(
                controller: _categoryController,
                decoration: AppStyles.inputDecoration(
                  labelText: '',
                  hintText: 'Enter category',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),
        if (_selectedCategory == null && _categories.isNotEmpty) ...[
          const SizedBox(height: AppStyles.spacingSM),
          TextFormField(
            controller: _categoryController,
            decoration: AppStyles.inputDecoration(
              labelText: '',
              hintText: 'Enter new category',
            ),
            validator: (value) {
              if (_selectedCategory == null && (value == null || value.isEmpty)) {
                return 'Please enter a category name';
              }
              return null;
            },
          )
        ]
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Create Product'),
        backgroundColor: AppStyles.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return TextButton(
                onPressed: state is ProductLoading ? null : _saveProduct,
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: state is ProductLoading ? Colors.blueGrey : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductSuccess) {
                Navigator.of(context).pop(true);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_isEditing ? 'Product updated successfully' : 'Product added successfully'),
                    backgroundColor: AppStyles.successColor,
                  ),
                );
              } else if (state is ProductError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppStyles.errorColor,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppStyles.spacingMD),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: AppStyles.inputDecoration(
                            labelText: 'Product Name',
                            hintText: 'Enter product name',
                            prefixIcon: const Icon(Icons.shopping_bag),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a product name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: AppStyles.spacingMD),
                        BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, categoryState) {
                            if (categoryState is CategoriesLoaded) {
                              _categories = categoryState.categories;
                            }
                            return _buildCategoryField();
                          },
                        ),
                        const SizedBox(height: AppStyles.spacingMD),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _priceController,
                                decoration: AppStyles.inputDecoration(
                                  labelText: 'Price',
                                  hintText: '0.00',
                                  prefixIcon: const Icon(Icons.currency_rupee),
                                ),
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a price';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid price';
                                  }
                                  if (double.parse(value) <= 0) {
                                    return 'Price must be greater than 0';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: AppStyles.spacingSM),
                            Expanded(
                              child: TextFormField(
                                controller: _quantityController,
                                decoration: AppStyles.inputDecoration(
                                  labelText: 'Quantity',
                                  hintText: '0',
                                  prefixIcon: const Icon(Icons.inventory),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter quantity';
                                  }
                                  if (int.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  if (int.parse(value) < 0) {
                                    return 'Quantity cannot be negative';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppStyles.spacingXL),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: state is ProductLoading ? null : _saveProduct,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppStyles.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: AppStyles.spacingMD),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppStyles.radiusMD),
                              ),
                            ),
                            child: Text(_isEditing ? 'Update Product' : 'Create Product'),
                          ),
                        ),
                        const SizedBox(height: AppStyles.spacingXL),
                      ],
                    ),
                  ),
                ),
                if (state is ProductLoading)
                  Container(
                    color: const Color.fromRGBO(0, 0, 0, 0.3),
                    child: const LoadingWidget(message: 'Saving product...'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
