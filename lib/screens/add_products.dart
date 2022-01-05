// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_final_fields, non_constant_identifier_names, unused_field, avoid_print, must_call_super, prefer_collection_literals, prefer_const_literals_to_create_immutables, unnecessary_new, curly_braces_in_flow_control_structures, unused_local_variable, unused_element

import 'dart:io';
import 'package:admin_panel/database/brand.dart';
import 'package:admin_panel/database/category.dart';
import 'package:admin_panel/database/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService productService = ProductService();
  final priceController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();

  TextEditingController productQuantityController = TextEditingController();
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory = '';
  String _currentBrand = '';
  List<String> selectedSize = <String>[];
  File? image1;
  File? image2;
  File? image3;
  bool isLoading = false;

  Future pickImage(Widget widget) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => image1 = imageTemporary);
    } on PlatformException catch (e) {
      print('Faild to pick image: $e');
    }
  }

  Future pickImage2(Widget widget) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => image2 = imageTemporary);
    } on PlatformException catch (e) {
      print('Faild to pick image: $e');
    }
  }

  Future pickImage3(Widget widget) async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => image3 = imageTemporary);
    } on PlatformException catch (e) {
      print('Faild to pick image: $e');
    }
  }

  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;

  @override
  void initState() {
    _getCategories();
    _getBrands();
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
          0,
          DropdownMenuItem(
            child: Text(categories[i]['category']),
            value: categories[i]['category'],
          ),
        );
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandsDropDown() {
    List<DropdownMenuItem<String>> items = [];
    for (int i = 0; i < brands.length; i++) {
      setState(() {
        items.insert(
          0,
          DropdownMenuItem(
            child: Text(brands[i]['brand']),
            value: brands[i]['brand'],
          ),
        );
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: Icon(
          Icons.close,
          color: black,
        ),
        title: Text(
          "add product",
          style: TextStyle(color: black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                          onPressed: () {
                            // var _picker;
                            pickImage(image1 != null
                                ? Image.file(
                                    image1!,
                                  )
                                : _displayChild1());
                          },
                          borderSide: BorderSide(
                              color: grey.withOpacity(0.5), width: 2.5),
                          child: _displayChild1()),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        onPressed: () {
                          pickImage2(image2 != null
                              ? Image.file(
                                  image2!,
                                )
                              : _displayChild2());
                        },
                        borderSide: BorderSide(
                            color: grey.withOpacity(0.5), width: 2.5),
                        child: _displayChild2(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                          onPressed: () {
                            pickImage3(image3 != null
                                ? Image.file(
                                    image3!,
                                  )
                                : _displayChild3());
                          },
                          borderSide: BorderSide(
                              color: grey.withOpacity(0.5), width: 2.5),
                          child: _displayChild3()),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'enter a product name with 13 characters maximum',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: red, fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(
                    hintText: "product name",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 13) {
                      return 'Product name can"t have more then 13 letter';
                    }
                  },
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Category: ',
                      style: TextStyle(color: red),
                    ),
                  ),
                  DropdownButton(
                    items: categoriesDropDown,
                    onChanged: changeSelectedCategor,
                    value: _currentCategory,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Brands: ',
                      style: TextStyle(color: red),
                    ),
                  ),
                  DropdownButton(
                    items: brandsDropDown,
                    onChanged: changeSelectedBrand,
                    value: _currentBrand,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: productQuantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Quantity",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the product name';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Price",
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'You must enter the product price';
                    }
                  },
                ),
              ),
              Text('Available Size'),
              Row(
                children: [
                  Checkbox(
                      value: selectedSize.contains('S'),
                      onChanged: (value) => changeSelectedSize('S')),
                  Text('S'),
                  Checkbox(
                      value: selectedSize.contains('M'),
                      onChanged: (value) => changeSelectedSize('M')),
                  Text('M'),
                  Checkbox(
                      value: selectedSize.contains('L'),
                      onChanged: (value) => changeSelectedSize('L')),
                  Text('L'),
                  Checkbox(
                      value: selectedSize.contains('XXL'),
                      onChanged: (value) => changeSelectedSize('XXL')),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: selectedSize.contains('20'),
                      onChanged: (value) => changeSelectedSize('20')),
                  Text('28'),
                  Checkbox(
                      value: selectedSize.contains('30'),
                      onChanged: (value) => changeSelectedSize('30')),
                  Text('30'),
                  Checkbox(
                      value: selectedSize.contains('32'),
                      onChanged: (value) => changeSelectedSize('32')),
                  Text('32'),
                  Checkbox(
                      value: selectedSize.contains('34'),
                      onChanged: (value) => changeSelectedSize('34')),
                  Text('34'),
                  Checkbox(
                      value: selectedSize.contains('36'),
                      onChanged: (value) => changeSelectedSize('36')),
                  Text('36'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: selectedSize.contains('37'),
                      onChanged: (value) => changeSelectedSize('37')),
                  Text('37'),
                  Checkbox(
                      value: selectedSize.contains('38'),
                      onChanged: (value) => changeSelectedSize('38')),
                  Text('38'),
                  Checkbox(
                      value: selectedSize.contains('40'),
                      onChanged: (value) => changeSelectedSize('40')),
                  Text('40'),
                  Checkbox(
                      value: selectedSize.contains('42'),
                      onChanged: (value) => changeSelectedSize('42')),
                  Text('42'),
                  Checkbox(
                      value: selectedSize.contains('44'),
                      onChanged: (value) => changeSelectedSize('44')),
                  Text('44'),
                ],
              ),
              FlatButton(
                color: red,
                textColor: white,
                child: Text('add product'),
                onPressed: () {
                  validateAndUpload();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print(data.length);
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0]['category'];
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    print(data.length);
    setState(() {
      brands = data;
      brandsDropDown = getBrandsDropDown();
      _currentBrand = brands[0]['brand'];
    });
  }

  void changeSelectedCategor(String? selectedCategory) {
    setState(() => _currentCategory = selectedCategory!);
  }

  void changeSelectedBrand(String? selectedBrand) {
    setState(() => _currentBrand = selectedBrand!);
  }

  void changeSelectedSize(String size) {
    if (selectedSize.contains(size)) {
      setState(() {
        selectedSize.remove(size);
      });
    } else {
      setState(() {
        selectedSize.insert(0, size);
      });
    }
  }

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => image1 = tempImg);
        break;
      case 2:
        setState(() => image2 = tempImg);
        break;
      case 3:
        setState(() => image3 = tempImg);
    }
  }

  Widget _displayChild1() {
    if (image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 40, 14, 40),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        image1!,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild2() {
    if (image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 40, 14, 40),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        image2!,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild3() {
    if (image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 40, 14, 40),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        image3!,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  void validateAndUpload() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      if (image1 != null && image2 != null && image3 != null) {
        if (selectedSize.isNotEmpty) {
          String imageUrl1;
          String imageUrl2;
          String imageUrl3;

          FirebaseStorage storage = FirebaseStorage.instance;
          final String picture1 =
              "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";

          UploadTask task1 = storage.ref().child(picture1).putFile(image1!);
          final String picture2 =
              "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          UploadTask task2 = storage.ref().child(picture2).putFile(image2!);
          final String picture3 =
              "3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
          UploadTask task3 = storage.ref().child(picture3).putFile(image3!);

          TaskSnapshot snapshot1 = await task1.then((snapshot) => snapshot);
          TaskSnapshot snapshot2 = await task2.then((snapshot) => snapshot);

          task3.then((snapshot3) async {
            imageUrl1 = await snapshot1.ref.getDownloadURL();
            imageUrl2 = await snapshot2.ref.getDownloadURL();
            imageUrl3 = await snapshot3.ref.getDownloadURL();
            List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];

            productService.uploadProduct({
              "name": productNameController.text,
              "price": double.parse(priceController.text),
              "sizes": selectedSize,
              "images": imageList,
              "quantity": int.parse(productQuantityController.text),
              "brand": _currentBrand,
              "category": _currentCategory
            });
            _formKey.currentState!.reset();
            setState(() => isLoading = false);
//            Fluttertoast.showToast(msg: 'Product added');
            Navigator.pop(context);
          });
        } else {
          setState(() => isLoading = false);

//          Fluttertoast.showToast(msg: 'select atleast one size');
        }
      } else {
        setState(() => isLoading = false);

//        Fluttertoast.showToast(msg: 'all the images must be provided');
      }
    }
  }
}
