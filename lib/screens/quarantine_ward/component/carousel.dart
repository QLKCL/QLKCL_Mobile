import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:qlkcl/helper/cloudinary.dart';
import 'package:qlkcl/helper/function.dart';

class Carousel extends StatefulWidget {
  final String? image;

  const Carousel({
    Key? key,
    this.image,
  }) : super(key: key);
  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  // ignore: unused_field
  int _counter = 0;
  List<String> imageList = [
    'Default/no_image_available',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.image != null && widget.image != "") {
      imageList = widget.image!.split(',');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          child: CarouselSlider(
            options: CarouselOptions(
              scrollPhysics: ScrollPhysics(),
              onPageChanged: (index, reason) =>
                  setState(() => _counter = index),
              aspectRatio: 2,
              height: Responsive.isDesktopLayout(context) ? 500 : null,
              autoPlay: true,
            ),
            items: imageList.map((imgUrl) {
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
                      child: Image.network(
                          cloudinary.getImage(imgUrl).toString(),
                          fit: BoxFit.cover),
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
