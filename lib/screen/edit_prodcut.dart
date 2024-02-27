import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoppingapp/Providers/product.dart';
import 'package:shoppingapp/Providers/products_provider.dart';

class EditprodcutScreen extends StatefulWidget {
  const EditprodcutScreen({super.key});
  static const routeName = 'edit-produt';

  @override
  State<EditprodcutScreen> createState() => _EditprodcutScreenState();
}

class _EditprodcutScreenState extends State<EditprodcutScreen> {
  final _pricefocousnode = FocusNode();
  final _descriptionfocousnode = FocusNode();
  final _imagurlcontroller = TextEditingController();
  final _imagurFocusNode = FocusNode();
  final _formkey = GlobalKey<FormState>();
  var _isinit = true;
  var _editedprodcut = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _initvalue = {
    'title': '',
    "description": '',
    "price": '',
    "imageUrl": '',
  };
  var _isloading = false;

  @override
  void dispose() {
    _imagurFocusNode.removeListener(_updateimageurl);
    _pricefocousnode.dispose();
    _descriptionfocousnode.dispose();
    _imagurlcontroller.dispose();
    _imagurFocusNode.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _imagurFocusNode.addListener(_updateimageurl);
    super.initState();
  }

  void _updateimageurl() {
    if (!_imagurFocusNode.hasFocus) {
      if ((!_imagurlcontroller.text.startsWith('http') &&
              !_imagurlcontroller.text.startsWith('https')) ||
          (!_imagurlcontroller.text.endsWith('.png') &&
              !_imagurlcontroller.text.endsWith('.jpg') &&
              !_imagurlcontroller.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      final productid = ModalRoute.of(context)!.settings.arguments;
      if (productid != null && productid is String) {
        _editedprodcut =
            Provider.of<Products>(context, listen: false).findbyId(productid);
        _initvalue = {
          'title': _editedprodcut.title,
          "description": _editedprodcut.description,
          "price": _editedprodcut.price.toString(),
          "imageUrl": _editedprodcut.imageUrl,
        };
        _imagurlcontroller.text = _editedprodcut.imageUrl;
      }
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  Future<void> _saveform() async {
    final isvalid = _formkey.currentState!.validate();
    if (!isvalid) {
      return;
    }

    _formkey.currentState?.save();
    setState(() {
      _isloading = true;
    });

    try {
      if (_editedprodcut.id != '') {
        Provider.of<Products>(context, listen: false).updateProduct(
          _editedprodcut.id,
          _editedprodcut,
        );
      } else {
        await Provider.of<Products>(context, listen: false).addProductd(
          _editedprodcut,
        );
      }

      setState(() {
        _isloading = false;
      });
      Navigator.of(context).pop();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("An Error Occurred "),
          content: const Text("Something went wrong"),
          actions: [
            MaterialButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      ).then((_) {
        setState(() {
          _isloading = false;
        });
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editing Product'),
        actions: [
          IconButton(
            onPressed: _saveform,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formkey,
                child: ListView(children: [
                  TextFormField(
                    initialValue: _initvalue['title'],
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    onFieldSubmitted: (_) {
                      _pricefocousnode.requestFocus();
                    },
                    textInputAction: TextInputAction.next,
                    validator: (editedvalue) {
                      if (editedvalue!.isEmpty) {
                        return 'Please provide a text value';
                      }
                      return null;
                    },
                    onSaved: (editedvalue) {
                      _editedprodcut = Product(
                        id: '',
                        title: editedvalue.toString(),
                        description: _editedprodcut.description,
                        price: _editedprodcut.price,
                        imageUrl: _editedprodcut.imageUrl,
                        isFavourite: _editedprodcut.isFavourite,
                      );
                    },
                  ),
                  TextFormField(
                    initialValue: _initvalue['price'],
                    decoration: const InputDecoration(
                      labelText: 'Price',
                    ),
                    onFieldSubmitted: (_) =>
                        _descriptionfocousnode.requestFocus(),
                    focusNode: _pricefocousnode,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter a price";
                      }
                      if (double.tryParse(value) == null) {
                        return "please enter a valid number";
                      }
                      if (double.parse(value) <= 0) {
                        return 'please enter number greater than zero';
                      }
                      return null;
                    },
                    onSaved: (editedvalue) {
                      _editedprodcut = Product(
                        id: _editedprodcut.id,
                        title: _editedprodcut.title,
                        description: _editedprodcut.description,
                        price: double.parse(editedvalue ?? ''),
                        imageUrl: _editedprodcut.imageUrl,
                        isFavourite: _editedprodcut.isFavourite,
                      );
                    },
                  ),
                  TextFormField(
                    initialValue: _initvalue['description'],
                    decoration: const InputDecoration(
                      labelText: 'Description',
                    ),
                    focusNode: _descriptionfocousnode,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Plase enter a description';
                      }
                      if (value.length > 100) {
                        return 'Limit is 100 cahracter';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (editedvalue) {
                      _editedprodcut = Product(
                        id: _editedprodcut.id,
                        title: _editedprodcut.title,
                        description: editedvalue.toString(),
                        price: _editedprodcut.price,
                        imageUrl: _editedprodcut.imageUrl,
                        isFavourite: _editedprodcut.isFavourite,
                      );
                    },
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.green,
                            ),
                          ),
                          child: _imagurlcontroller.text.isEmpty
                              ? const Text('Enter a url')
                              : FittedBox(
                                  child: Image.network(
                                    _imagurlcontroller.text,
                                    fit: BoxFit.fill,
                                  ),
                                )),
                      Expanded(
                        child: TextFormField(
                          controller: _imagurlcontroller,
                          decoration: const InputDecoration(
                            labelText: "Image url",
                          ),
                          keyboardType: TextInputType.url,
                          textInputAction: TextInputAction.done,
                          focusNode: _imagurFocusNode,
                          validator: (value) {
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            _saveform();
                          },
                          onSaved: (editedvalue) {
                            _editedprodcut = Product(
                              id: _editedprodcut.id,
                              title: _editedprodcut.title,
                              description: _editedprodcut.description,
                              price: _editedprodcut.price,
                              imageUrl: editedvalue.toString(),
                              isFavourite: _editedprodcut.isFavourite,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ]),
              ),
            ),
    );
  }
}
