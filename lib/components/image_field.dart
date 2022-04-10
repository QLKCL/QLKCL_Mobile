import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/helper/cloudinary.dart';
import 'package:qlkcl/networking/response.dart';
import 'package:qlkcl/screens/quarantine_ward/component/circle_button.dart';
import 'package:qlkcl/utils/app_theme.dart';
import 'package:qlkcl/utils/constant.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ImageField extends StatefulWidget {
  const ImageField({
    Key? key,
    required this.controller,
    this.maxQuantityImage = 1,
    required this.type,
  }) : super(key: key);
  final int maxQuantityImage;
  final TextEditingController controller;
  final String type;

  @override
  State<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  List<String> imageList = [
    'Default/no_image_available',
  ];

  List<XFile> imageFileList = [];

  @override
  void initState() {
    super.initState();

    if (widget.controller.text != "") {
      imageList.addAll(widget.controller.text.split(','));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 16;
    // final crossAxisCount = screenWidth >= minDesktopSize ? 4 : 2;
    final crossAxisCount = screenWidth <= maxMobileSize
        ? 4
        : screenWidth >= minDesktopSize
            ? (screenWidth - 230) ~/ (maxMobileSize - 350)
            : screenWidth ~/ (maxMobileSize - 320);
    final width = screenWidth / crossAxisCount;
    final cellHeight = width;
    final aspectRatio = width / cellHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Hình ảnh',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: ResponsiveGridView.builder(
            padding: const EdgeInsets.only(top: 8),
            gridDelegate: ResponsiveGridDelegate(
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              maxCrossAxisExtent: width,
              minCrossAxisExtent: width < maxMobileSize ? width : maxMobileSize,
              childAspectRatio: aspectRatio,
            ),
            itemCount: imageList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return index == 0 ? defaultAddImageButton() : showImage(index);
            },
          ),
        ),
      ],
    );
  }

  Widget defaultAddImageButton() {
    return Container(
      padding: const EdgeInsets.all(5),
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        color: primary,
        child: OutlinedButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size.infinite),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            side: MaterialStateProperty.all(
              BorderSide(
                color: primary,
                style: BorderStyle.none,
              ),
            ),
          ),
          onPressed: () {
            if (widget.maxQuantityImage < imageList.length) {
              showNotification(
                  "Chỉ có thể thêm tối đa ${widget.maxQuantityImage} hình ảnh!",
                  status: Status.error);
            } else {
              upLoadImages(
                imageFileList,
                multi: true,
                maxQuantity: widget.maxQuantityImage - imageList.length + 1,
                type: widget.type,
              ).then((value) => setState(() {
                    imageList.addAll(value);
                    widget.controller.text = imageList.sublist(1).join(',');
                  }));
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.camera_alt_outlined,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                'Thêm ảnh',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showImage(int index) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
                cloudinary.getImage(imageList[index]).toString(),
                fit: BoxFit.cover),
          ),
          Positioned(
            right: -0.05,
            top: -0.05,
            child: CircleButton(
                onTap: () {
                  imageList.removeAt(index);
                  widget.controller.text = imageList.sublist(1).join(',');
                  setState(() {});
                },
                iconData: Icons.close),
          ),
        ],
      ),
    );
  }
}
