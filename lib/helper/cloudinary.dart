import 'package:bot_toast/bot_toast.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qlkcl/components/bot_toast.dart';
import 'package:qlkcl/networking/response.dart';

final cloudinary = CloudinaryPublic(
  'qlkcl',
  'srnekoib',
  cache: true,
);

Future upLoadImages(
  List<XFile> _imageFileList, {
  bool multi = false,
  int maxQuantity = 1,
  String type = "User",
  String folder = "",
  Map<String, dynamic>? context,
}) async {
  _imageFileList = [];
  _imageFileList = await selectImages(_imageFileList, multi: multi);
  if (_imageFileList.length > maxQuantity) {
    showNotification("Chỉ có thể chọn tối đa $maxQuantity hình ảnh!",
        status: Status.error);
    _imageFileList = _imageFileList.take(maxQuantity).toList();
  }
  return upload(_imageFileList, type: type, folder: folder, context: context);
}

Future<List<XFile>> selectImages(
  List<XFile> _imageFileList, {
  bool multi = false,
}) async {
  final ImagePicker _picker = new ImagePicker();
  List<XFile>? selectedImages = [];
  try {
    if (multi == true) {
      selectedImages = await _picker.pickMultiImage();
    } else {
      XFile? selectedImage =
          await _picker.pickImage(source: ImageSource.gallery);
      selectedImages = selectedImage != null ? [selectedImage] : [];
    }
  } catch (error) {
    print("error: $error");
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
    CancelFunc cancel = showLoading();
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
    cancel();
    return response.map((e) => e.publicId).toList();
  } on CloudinaryException catch (e) {
    print(e.message);
    print(e.request);
  }
  return [];
}
