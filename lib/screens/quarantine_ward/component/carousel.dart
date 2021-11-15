import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _counter = 0;

  final listImg = [
    'assets/images/carousel1.jpg',
    'assets/images/carousel2.jpg',
    'assets/images/carousel3.jpeg',
    'assets/images/carousel4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          child: CarouselSlider(
            options: CarouselOptions(
              // enableInfiniteScroll: false,
              onPageChanged: (index, reason) =>
                  setState(() => _counter = index),
              aspectRatio: 2,
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
      ],
    );
  }
}
