import 'dart:convert';
import 'package:crud_app/model.dart';
import 'package:crud_app/screens/create_screen.dart';
import 'package:crud_app/screens/update_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> productList = [];
  bool inProgress = true;

  @override
  void initState() {
    getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CRUD APP",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: Colors.black.withOpacity(0.9),
            ),
            onPressed: () {
              getProductList();
            },
          )
        ],
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CreateScreen(),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add_box),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: inProgress
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : productList.isEmpty
                ? Center(
                    child: Text(
                      "Empty List",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black.withOpacity(0.9),
                      ),
                    ),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) {
                      return _buildContainer(productList[index]);
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                    itemCount: productList.length,
                  ),
      ),
    );
  }

  Future<void> getProductList() async {
    productList.clear();
    inProgress = true;
    setState(() {});
    const url = "http://164.68.107.70:6060/api/v1/ReadProduct";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final jsonBody = jsonDecode(response.body);
    for (final data in jsonBody["data"]) {
      productList.add(
        ProductModel(
          id: data["_id"] ?? '',
          productName: data["ProductName"] ?? '',
          productCode: data["ProductCode"] ?? '',
          img: data["Img"] ?? '',
          unitPrice: data["UnitPrice"] ?? '',
          qty: data["Qty"] ?? '',
          totalPrice: data["TotalPrice"] ?? '',
          createdDate: data["CreatedDate"] ?? '',
        ),
      );
    }
    inProgress = false;
    setState(() {});
  }

  Future<void> deleteProduct(String id) async {
    final url = "http://164.68.107.70:6060/api/v1/DeleteProduct/$id";
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Deleted Successfully"),
          ),
        );
        getProductList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: ${response.statusCode}"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to delete product: $e"),
        ),
      );
    }
  }

  Widget _buildContainer(product) {
    return Card(
      elevation: 3,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name: ${product.productName}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
              Text(
                "Code: ${product.productCode}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
              Text(
                "Price: ${product.unitPrice}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
              Text(
                "Quantity: ${product.qty}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
              Text(
                "Total Price: ${product.totalPrice}",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
              const Divider(
                thickness: 1.5,
                color: Colors.grey,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateScreen(
                            productName: product.productName,
                            productCode: product.productCode,
                            img: product.img,
                            unitPrice: product.unitPrice,
                            qty: product.qty,
                            totalPrice: product.totalPrice,
                            id: product.id,
                          ),
                        ),
                      );
                    },
                    icon: Row(
                      children: [
                        Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.black.withOpacity(0.9),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Edit',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    color: Colors.grey,
                    onPressed: () {
                      deleteProduct(product.id);
                    },
                    icon: Row(
                      children: [
                        const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Delete',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
