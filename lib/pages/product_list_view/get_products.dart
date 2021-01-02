import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async' show Future, Timer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_store/pages/product/product.dart';
import 'package:my_store/pages/product_list_view/filter_row.dart';
import 'package:my_store/functions/passDataToProducts.dart';
import 'package:shimmer/shimmer.dart';

// My Own Imports

class GetProducts extends StatefulWidget {
  @override
  _GetProductsState createState() => _GetProductsState();
}

class _GetProductsState extends State<GetProducts> {
  bool loading = true, all = true, men = false, women = false;
  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Products>>(
      future: loadProducts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        return snapshot.hasData
            ? ListView(
                children: <Widget>[
                  FilterRow(),
                  Divider(
                    height: 1.0,
                  ),
                  (loading)
                      ? Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300],
                            highlightColor: Colors.white,
                            child: ProductsGridView(products: snapshot.data),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: ProductsGridView(products: snapshot.data),
                        ),
                ],
              )
            : Center(
                child: SpinKitRipple(color: Colors.red),
              );
      },
    );
  }
}

class ProductsGridView extends StatefulWidget {
  final List<Products> products;

  ProductsGridView({Key key, this.products}) : super(key: key);

  @override
  _ProductsGridViewState createState() => _ProductsGridViewState();
}

class _ProductsGridViewState extends State<ProductsGridView> {
  InkWell getStructuredGridCell(Products products) {
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.color,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              blurRadius: 0.7,
              color: Colors.grey,
            ),
          ],
        ),
        child: Column(
          children: <Widget>[
            Hero(
              tag: Text("${products.uniqueId}"),
              child: Container(
                height: ((height - 150.0) / 2.95),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage(products.productImage),
                    fit: BoxFit.cover,
                  ),
                ),
                margin: EdgeInsets.all(6.0),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(right: 6.0, left: 6.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      products.productTitle,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'Jost',
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline6.color,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "\$${products.productPrice}",
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline6.color,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          "\$${products.productOldPrice}",
                          style: TextStyle(
                              fontSize: 13.0,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: 6.0,
                        ),
                        Text(
                          "(${products.offerText})",
                          style: TextStyle(
                              color: const Color(0xFF67A86B), fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              productData: PassDataToProduct(
                products.productId,
                products.productImage,
                products.productTitle,
                products.productPrice,
                products.productOldPrice,
                products.offerText,
                products.uniqueId,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return GridView.count(
      shrinkWrap: true,
      primary: false,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
      crossAxisCount: 2,
      childAspectRatio: ((width) / (height - 150.0)),
      children: List.generate(widget.products.length, (index) {
        return getStructuredGridCell(widget.products[index]);
      }),
    );
  }
}

class Products {
  int productId;
  String productImage;
  String productTitle;
  String productPrice;
  String productOldPrice;
  String offerText;
  final String uniqueId;

  Products(this.productId, this.productImage, this.productTitle,
      this.productPrice, this.productOldPrice, this.offerText, this.uniqueId);
}

Future<List<Products>> loadProducts() async {
  var jsonString = await rootBundle.loadString('assets/json/products.json');
  final jsonResponse = json.decode(jsonString);

  List<Products> products = [];

  for (var o in jsonResponse) {
    Products product = Products(
        o["productId"],
        o["productImage"],
        o["productTitle"],
        o["price"],
        o["oldPrice"],
        o["offer"],
        o["uniqueId"]);

    products.add(product);
  }

  return products;
}
