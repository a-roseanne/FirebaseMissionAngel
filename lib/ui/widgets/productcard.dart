import 'package:flutter/material.dart';

import 'package:flutter_bloc_practice/models/models.dart';
import 'package:flutter_bloc_practice/ui/pages/pages.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Products product;
  ProductCard({this.product});
  final formatter = new NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailProduct(
              product: product,
            );
          }));
        },
        title: Text(product.name, style: TextStyle(fontSize: 20)),
        subtitle: Text("Rp ${formatter.format(int.parse(product.price))}"),
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(product.image, scale: 40),
          // child: Text(product.name[0], style: TextStyle(fontSize: 20))
        ),
        trailing: Icon(Icons.info),
      ),
    );
  }
}
