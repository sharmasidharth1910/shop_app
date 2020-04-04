import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const id = "EditProductScreen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  var _isInit = true;
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    description: " ",
    title: " ",
    imageUrl: " ",
    price: 0,
  );
  var _initValues = {
    "title": "",
    "description": "",
    "price": "",
    "imageUrl": "",
  };

  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute
          .of(context)
          .settings
          .arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<ProductsProvider>(context, listen: false)
            .findById(productId);
        _initValues = {
          "title": _editedProduct.title,
          "description": _editedProduct.description,
          "price": _editedProduct.price.toString(),
          //"imageUrl": _editedProduct.imageUrl,
          "imageUrl": "",
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith("http") &&
              !_imageUrlController.text.startsWith("https")) ||
          (!_imageUrlController.text.endsWith(".jpg") &&
              !_imageUrlController.text.endsWith(".jpeg") &&
              !_imageUrlController.text.endsWith(".png"))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.pop(context);
    } else {
      await Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        return showDialog(
            context: context,
            builder: (context) =>
                AlertDialog(
                  title: Text("An error occurred !"),
                  content:
                  Text("Something went wrong. Please try again later."),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Okay"))
                  ],
                ));
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm),
        ],
      ),
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
//                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
        ),
      )
          : Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues["title"],
                decoration: InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please provide a title";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                    title: value,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    price: _editedProduct.price,
                  );
                },
              ),
              TextFormField(
                initialValue: _initValues["price"],
                decoration: InputDecoration(labelText: "Price"),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Please enter a valid number";
                  }
                  if (double.parse(value) < 1) {
                    return "Please enter a valid price";
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode);
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    price: double.parse(value),
                    title: _editedProduct.title,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                  );
                },
                focusNode: _priceFocusNode,
              ),
              TextFormField(
                initialValue: _initValues["description"],
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                onSaved: (value) {
                  _editedProduct = Product(
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                    isFavourite: _editedProduct.isFavourite,
                    title: _editedProduct.title,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return "Please enter a description";
                  }
                  if (value.length < 20) {
                    return "Please enter a longer description";
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text("Enter a url")
                        : FittedBox(
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "ImageUrl"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please enter an imageUrl";
                        }
                        if (!value.startsWith("http") &&
                            !value.startsWith("https")) {
                          return "Please enter a valid url";
                        }
                        if (!value.endsWith(".png") &&
                            !value.endsWith(".jpg") &&
                            !value.endsWith(".jpeg")) {
                          return "Please enter a valid imageUrl";
                        }
                        return null;
                      },
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          imageUrl: value,
                          id: _editedProduct.id,
                          isFavourite: _editedProduct.isFavourite,
                          title: _editedProduct.title,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                        );
                      },
                      controller: _imageUrlController,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
