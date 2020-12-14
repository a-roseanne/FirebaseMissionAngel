part of 'pages.dart';

class DetailProduct extends StatefulWidget {
  final Products product;

  DetailProduct({Key key, this.product}) : super(key: key);

  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  CollectionReference productCollection =
      FirebaseFirestore.instance.collection("products");

  // final ctrlName = TextEditingController();

  TextEditingController ctrlName;
  TextEditingController ctrlPrice;

  // final ctrlPrice = TextEditingController();
  bool isLoading = false;
  @override
  void dispose() {
    ctrlName.dispose();
    ctrlPrice.dispose();
    super.dispose();
  }

  void clearForm() {
    ctrlName.clear();
    ctrlPrice.clear();
    setState(() {
      imageFile = null;
    });
  }

  PickedFile imageFile;
  final ImagePicker imagePicker = ImagePicker();

  Future chooseImage() async {
    final selectedImage = await imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      imageFile = selectedImage;
    });
  }

  @override
  void initState() {
    super.initState();
    ctrlName = TextEditingController(text: widget.product.name);
    ctrlPrice = TextEditingController(text: widget.product.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Product"),
      ),
      body: Stack(children: [
        Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              Column(
                children: [
                  SizedBox(height: 10),
                  TextFormField(
                    controller: ctrlName,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.label_important),
                        labelText: 'Product Name',
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: ctrlPrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.attach_money),
                        labelText: 'Product Price',
                        hintText: "150.000",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  Image(
                    image: NetworkImage(widget.product.image),
                    height: 150,
                  ),
                  SizedBox(height: 40),
                  RaisedButton(
                      child: Text("Update Product"),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(10),
                      onPressed: () async {
                        if (ctrlName.text == "" || ctrlPrice.text == "") {
                          Fluttertoast.showToast(
                              msg: "Please fill all fields!",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                        } else {
                          setState(() {
                            isLoading = true;
                          });
                          Products product = Products(
                              widget.product.id,
                              ctrlName.text,
                              ctrlPrice.text,
                              widget.product.image);
                          bool result =
                              await ProductServices.updateProduct(product);
                          if (result == true) {
                            Fluttertoast.showToast(
                                msg: "Update Product successful",
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_LONG);
                            clearForm();
                            Navigator.pop(context);
                            setState(() {
                              isLoading = false;
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "Failed to Update Product!",
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_LONG);
                            setState(() {
                              isLoading = false;
                            });
                          }
                        }
                      }),
                  RaisedButton(
                      child: Text("Delete Product"),
                      color: Colors.redAccent,
                      textColor: Colors.white,
                      padding: EdgeInsets.all(10),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        Products product = Products(
                            widget.product.id,
                            ctrlName.text,
                            ctrlPrice.text,
                            widget.product.image);
                        bool result =
                            await ProductServices.deleteProduct(product);
                        if (result == true) {
                          Fluttertoast.showToast(
                              msg: "Delete Product successful",
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                          Navigator.pop(context);
                          clearForm();
                          setState(() {
                            isLoading = false;
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "Failed to Delete Product!",
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }),
                  SizedBox(height: 20),
                ],
              )
            ],
          ),
        ),
        isLoading == true
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.transparent,
                child: SpinKitFadingCircle(
                  size: 50,
                  color: Colors.lightBlue,
                ),
              )
            : Container()
      ]),
    );
  }
}
