import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _counter = 0;

  final listImg = [
    '../../../assets/images/carousel-demo/carousel1.jpg',
    '../../../assets/images/carousel-demo/carousel2.jpg',
    '../../../assets/images/carousel-demo/carousel3.jpeg',
    '../../../assets/images/carousel-demo/carousel4.jpg',
  ];
  // List<T> map<T>(List list, Function handler) {
  //   List<T> result = [];
  //   for (var i = 0; i < list.length; i++) {
  //     result.add(handler(i, list[i]));
  //   }
  //   return result;
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          child: CarouselSlider(
            options: CarouselOptions(
              onPageChanged: (index, reason) =>
                  setState(() => _counter = index),
              aspectRatio: 2.0,
            ),
            items: listImg.map((imgUrl) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        // color: Colors.amber,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: Image.asset(imgUrl, fit: BoxFit.cover),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,

        //    children: listImg.map((image) {       //these two lines
        //     int index=listImg.indexOf(image); //are changed
        //     return Container(
        //       width: 8.0,
        //       height: 8.0,
        //       margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        //       decoration: BoxDecoration(
        //           shape: BoxShape.circle,
        //           color: _counter == index
        //               ? Color.fromRGBO(0, 0, 0, 0.9)
        //               : Color.fromRGBO(0, 0, 0, 0.4)),
        //     );
        //   },
        // ),
        // map<Widget>{
        //   listImg, (index, url){

        //   }
        // }
      ],
    );
  }
}
//Widget buildIndicator() => AnimatedSmoothIndicator()
