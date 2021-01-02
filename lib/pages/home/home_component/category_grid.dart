import 'package:flutter/material.dart';
import 'package:my_store/functions/localizations.dart';
import 'package:my_store/pages/Category/category.dart';

class CategoryGrid extends StatefulWidget {
  @override
  _CategoryGridState createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  final categoryList = [
    {'title': 'BAGS', 'image': 'assets/category_grid/bags.jpg'},
    {'title': 'CAMERA', 'image': 'assets/category_grid/camera.jpg'},
    {
      'title': 'SPEAKERS',
      'image': 'assets/category_grid/speakers.jpg'
    },
    {'title': 'WATCHES', 'image': 'assets/category_grid/watches.jpg'}
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Container getStructuredGridCell(bestOffer) {
      final item = bestOffer;
      return Container(
        margin: EdgeInsets.all(3.0),
        child: InkWell(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 1.5,
                  color: Colors.grey,
                ),
              ],
              image: DecorationImage(
                image: AssetImage(item['image']),
                fit: BoxFit.cover,
              ),
            ),
            child: Text(
              item['title'],
              style: TextStyle(
                fontFamily: 'Jost',
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                letterSpacing: 1.5,
                color: Colors.white,
              ),
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryPage(categoryName: item['title']),),);
          },
        ),
      );
    }

    return Container(
      color: Theme.of(context).appBarTheme.color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(AppLocalizations.of(context).translate('homePage','categoryString'),
              style: TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontSize: 17.0,
                  color: Theme.of(context).textTheme.headline6.color),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(0.0),
                alignment: Alignment.center,
                width: width - 20.0,
                child: GridView.count(
                  primary: false,
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0),
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  crossAxisCount: 2,
                  childAspectRatio: ((width) / 300),
                  children: List.generate(categoryList.length, (index) {
                    return getStructuredGridCell(categoryList[index]);
                  }),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }
}
