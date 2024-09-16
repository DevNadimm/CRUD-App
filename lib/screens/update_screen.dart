import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({
    super.key,
    required this.productName,
    required this.productCode,
    required this.img,
    required this.unitPrice,
    required this.qty,
    required this.totalPrice,
    required this.id,
  });

  final String id;
  final String productName;
  final String productCode;
  final String img;
  final String unitPrice;
  final String qty;
  final String totalPrice;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productCode = TextEditingController();
  final TextEditingController _img = TextEditingController();
  final TextEditingController _unitPrice = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _totalPrice = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productName.text = widget.productName;
    _productCode.text = widget.productCode;
    _img.text = widget.img;
    _unitPrice.text = widget.unitPrice;
    _qty.text = widget.qty;
    _totalPrice.text = widget.totalPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Update Product",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _formField("Product Name", _productName),
              _formField("Product Code", _productCode),
              _formField("Image URL", _img),
              _formField("Unit Price", _unitPrice),
              _formField("Product Quantity", _qty),
              _formField("Total Price", _totalPrice),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _updateProduct(context, widget.id);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "Update",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _formField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.9),),
        decoration: InputDecoration(
          label: Text(label),
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.8),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 2, color: Colors.red),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a $label';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Future<void> _updateProduct(context, String id) async {
    final url = "http://164.68.107.70:6060/api/v1/UpdateProduct/$id";
    final uri = Uri.parse(url);
    Map<String, dynamic> data = {
      "Img": _img.text.trim(),
      "ProductCode": _productCode.text.trim(),
      "ProductName": _productName.text.trim(),
      "Qty": _qty.text.trim(),
      "TotalPrice": _totalPrice.text.trim(),
      "UnitPrice": _unitPrice.text.trim(),
    };

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product updated successfully!'),
          ),
        );
        _productName.clear();
        _productCode.clear();
        _img.clear();
        _unitPrice.clear();
        _qty.clear();
        _totalPrice.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update product: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _productName.dispose();
    _productCode.dispose();
    _img.dispose();
    _unitPrice.dispose();
    _qty.dispose();
    _totalPrice.dispose();
    super.dispose();
  }
}
