import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';

final cloudinary = CloudinaryPublic(
  'qlkcl',
  'srnekoib',
  cache: true,
);

Future upLoadImages(
  List<XFile> _imageFileList, {
  bool multi = false,
  String type = "User",
  String folder = "",
  Map<String, dynamic>? context,
}) async {
  _imageFileList = [];
  _imageFileList = await selectImages(_imageFileList, multi: multi);
  return upload(_imageFileList, type: type, folder: folder, context: context);
}

Future<List<XFile>> selectImages(
  List<XFile> _imageFileList, {
  bool multi = false,
}) async {
  final ImagePicker _picker = new ImagePicker();
  List<XFile>? selectedImages = [];
  if (multi == true) {
    selectedImages = await _picker.pickMultiImage();
  } else {
    XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    selectedImages = selectedImage != null ? [selectedImage] : [];
  }

  if (selectedImages != null && selectedImages.isNotEmpty) {
    _imageFileList.addAll(selectedImages.toList());
  } else {
    print('No image selected.');
  }
  return _imageFileList;
}

Future<List<String>> upload(
  List<XFile> _imageFileList, {
  String type = "User",
  String folder = "",
  Map<String, dynamic>? context,
}) async {
  try {
    List<CloudinaryResponse> response =
        await cloudinary.uploadFiles(_imageFileList
            .map(
              (image) => CloudinaryFile.fromFile(
                image.path,
                folder: '$type' + (folder != "" ? '/$folder' : ""),
                context: context,
              ),
            )
            .toList());
    return response.map((e) => e.publicId).toList();
  } on CloudinaryException catch (e) {
    print(e.message);
    print(e.request);
  }
  return [];
}
