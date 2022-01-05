// ignore_for_file: prefer_const_constructors, deprecated_member_use, prefer_final_fields, non_constant_identifier_names, unused_field, avoid_print, must_call_super, prefer_collection_literals, prefer_const_literals_to_create_immutables

import 'package:admin_panel/database/brand.dart';
import 'package:admin_panel/database/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
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
  // File? _image1;
  // File? _image2;
  // File? _image3;

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
                        onPressed: () {},
                        borderSide: BorderSide(
                            color: grey.withOpacity(0.5), width: 2.5),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
                          child: Icon(
                            Icons.add,
                            color: grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        onPressed: () {
                          // _selectImage(ImagePicker.pickImagee(
                          //     source: ImageSource.gallery),2);
                        },
                        borderSide: BorderSide(
                            color: grey.withOpacity(0.5), width: 2.5),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
                          child: Icon(
                            Icons.add,
                            color: grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        onPressed: () {
                          // _selectImage(ImagePicker.pickImage(
                          //     source: ImageSource.gallery),3;
                        },
                        borderSide: BorderSide(
                            color: grey.withOpacity(0.5), width: 2.5),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
                          child: Icon(
                            Icons.add,
                            color: grey,
                          ),
                        ),
                      ),
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
              )

              // FloatButton(
              //   color: red,
              //   textColor: white,
              //   child: Text('add product'),
              //   onPressed: () {},
              // )
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

  // void _selectImage(Future<XFile?> pickImage, int imageNumber) async {
  //   File tempImg = (await pickImage) as File;
  //   switch (imageNumber) {
  //     case 1:
  //       setState(() => _image1 = tempImg);
  //       break;
  //     case 2:
  //       setState(() => _image2 = tempImg);
  //       break;
  //     case 3:
  //       setState(() => _image3 = tempImg);
  //       break;
  //   }
  // }

//  Widget  _displayChild() {
//   if(_image1 == null){
//     return Padding( padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
//                           child: Icon(
//                             Icons.add,
//                             color: grey,
//                           ),
//                         );
//   }
//   else{
//     return Padding(padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
//                           child: Image.file(_image1)
//                           );

//   }
// }
//  Widget  _displayChild2() {
//   if(_image2 == null){
//     return Padding( padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
//                           child: Icon(
//                             Icons.add,
//                             color: grey,
//                           ),
//                         );
//   }
//   else{
//     return Padding(padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
//                           child: Image.file(_image2)
//                           );

//   }
// }
//  Widget  _displayChild3() {
//   if(_image3 == null){
//     return Padding( padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
//                           child: Icon(
//                             Icons.add,
//                             color: grey,
//                           ),
//                         );
//   }
//   else{
//     return Padding(padding: const EdgeInsets.fromLTRB(14, 70, 14, 70),
//                           child: Image.file(_image3)
//                           );

//   }/

}
