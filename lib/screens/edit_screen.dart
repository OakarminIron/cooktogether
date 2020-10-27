import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../classx/meal.dart';
import '../a_Database/todb.dart';
import 'package:filter_list/filter_list.dart';

class EditScreen extends StatefulWidget {
  static const routeName = '/edit_screen';

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  List<String> catList = [
    "ကြက်သား",
    "ပုဇွန်",
    "ငါး",
    "ပဲ",
    "အသီးအရွက်",
    "ချဉ်ရည်",
    "အထူး",
  ];
  List<String> xcatList = [];

  void catSelect() async {
    var list = await FilterList.showFilterList(
      context,
      allTextList: catList,
      height: 450,
      borderRadius: 20,
      headlineText: "ဟင်းအမျိုးအစား ရွှေးပါ",
      selectedTextList: xcatList,
      allResetButonColor: (Colors.deepPurple),
      selectedTextBackgroundColor: Color.fromARGB(250, 156, 18, 255),
      applyButonTextBackgroundColor: (Colors.deepPurpleAccent),
      hideSearchField: true,
    );

    if (list != null) {
      setState(() {
        xcatList = List.from(list);
      });
    }
    print(xcatList);
  }

  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _stepsFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();

  final _form = GlobalKey<FormState>();
  var _edited = Meal(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    steps: '',
    categorie: [], /*
    ingredients: [],
    complexity: Complexity.Simple,
    duration: 5,
    isVegetarian: false,*/
  );
  var _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final mealID = ModalRoute.of(context).settings.arguments as String;
      if (mealID != null) {
        _edited = Provider.of<ToDB>(context, listen: false).findById(mealID);
        _initValues = {
          'title': _edited.title,
          'description': _edited.description,
          'imageUrl': _edited.imageUrl,
        };
        _imageUrlController.text = _edited.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _stepsFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
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
    if (_edited.id != null) {
      await Provider.of<ToDB>(context, listen: false)
          .updateMeal(_edited.id, _edited);
    } else {
      try {
        await Provider.of<ToDB>(context, listen: false).addMeal(_edited);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ပြင်ဆင်ခြင်း'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'ဟင်းအမည်'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_titleFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ဟင်းအမည် ကိုရေးပေးပါ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _edited = Meal(
                          title: value,
                          imageUrl:
                              'https://img.favpng.com/21/11/15/indian-cuisine-korma-chicken-curry-red-curry-png-favpng-bxfAEcJ2MKhhtHcyt91FyvWpR.jpg',
                          id: _edited.id,
                          description: _edited.description,
                          categorie: xcatList,
                          steps: _edited.steps,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'ဖော်ပြချက်'),
                      maxLines: 2,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'ဖော်ပြချက်ရေးပေးပါ';
                        }
                        if (value.length < 1) {
                          return 'ဖော်ပြချက်ရေးပေးပါ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _edited = Meal(
                          description: value,
                          title: _edited.title,
                          imageUrl:
                              'https://img.favpng.com/21/11/15/indian-cuisine-korma-chicken-curry-red-curry-png-favpng-bxfAEcJ2MKhhtHcyt91FyvWpR.jpg',
                          id: _edited.id,
                          categorie: xcatList,
                          steps: _edited.steps,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['steps'],
                      decoration: InputDecoration(
                          labelText: 'ချက်နည်းအဆင့်ဆင့်ကိုရေးပေးပါ'),
                      minLines: 1,
                      maxLines: 6,
                      keyboardType: TextInputType.multiline,
                      focusNode: _stepsFocusNode,
                      validator: (value) {
                        return null;
                      },
                      onSaved: (value) {
                        _edited = Meal(
                          id: _edited.id,
                          steps: value,
                          description: _edited.description,
                          title: _edited.title,
                          imageUrl:
                              'https://img.favpng.com/21/11/15/indian-cuisine-korma-chicken-curry-red-curry-png-favpng-bxfAEcJ2MKhhtHcyt91FyvWpR.jpg',
                          categorie: _edited.categorie,
                        );
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
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            /* validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a valid image URL.';
                              }
                              return null;
                            }, */
                            onSaved: (value) {
                              _edited = Meal(
                                title: _edited.title,
                                imageUrl:
                                    'https://img.favpng.com/21/11/15/indian-cuisine-korma-chicken-curry-red-curry-png-favpng-bxfAEcJ2MKhhtHcyt91FyvWpR.jpg',
                                id: _edited.id,
                                description: _edited.description,
                                categorie: xcatList,
                                steps: _edited.steps,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    RaisedButton(
                      onPressed: catSelect,
                      child: Text("ဟင်းအမျိုးအစား ရွှေးပါ"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("Save"),
                        IconButton(
                          icon: Icon(Icons.save),
                          onPressed: _saveForm,
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
