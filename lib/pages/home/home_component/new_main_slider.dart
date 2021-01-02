import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:my_store/pages/product_list_view/product_list_view.dart';

class NewMainSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 170.0,
      width: width,
      child: Carousel(
        dotSize: 4.0,
        dotSpacing: 15.0,
        dotColor: Theme.of(context).primaryColor,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.transparent,
        borderRadius: true,
        dotVerticalPadding: 5.0,
        dotPosition: DotPosition.bottomRight,
        images: [
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductListView()));
            },
            child: Image.asset(
              'assets/home_slider/home_slider_1.png',
              fit: BoxFit.cover,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductListView()));
            },
            child: Image.asset(
              'assets/home_slider/home_slider_2.png',
              fit: BoxFit.cover,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductListView()));
            },
            child: Image.asset(
              'assets/home_slider/home_slider_3.png',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
