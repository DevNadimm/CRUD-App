import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _productName = TextEditingController();
  final TextEditingController _productCode = TextEditingController();
  final TextEditingController _img = TextEditingController();
  final TextEditingController _unitPrice = TextEditingController();
  final TextEditingController _qty = TextEditingController();
  final TextEditingController _totalPrice = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Product",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        surfaceTintColor: Colors.transparent,
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
                        _postProduct(context);
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
                        "Submit",
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
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black.withOpacity(0.9)),
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

  Future<void> _postProduct(context) async {
    const url = "http://164.68.107.70:6060/api/v1/CreateProduct";
    final uri = Uri.parse(url);
    Map<String, dynamic> data = {
      "ProductName": _productName.text,
      "ProductCode": _productCode.text,
      "Img": _img.text,
      "UnitPrice": _unitPrice.text,
      "Qty": _qty.text,
      "TotalPrice": _totalPrice.text,
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
            content: Text('Product created successfully!'),
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
            content: Text('Failed to create product: ${response.statusCode}'),
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
  dispose() {
    super.dispose();
    _productName.dispose();
    _productCode.dispose();
    _img.dispose();
    _unitPrice.dispose();
    _qty.dispose();
    _totalPrice.dispose();
  }
}
