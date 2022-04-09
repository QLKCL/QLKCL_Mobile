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
  List<XFile> imageFileList, {
  bool multi = false,
  int maxQuantity = 1,
  String type = "User",
  String folder = "",
  Map<String, dynamic>? context,
}) async {
  imageFileList = [];
  imageFileList = await selectImages(imageFileList, multi: multi);
  if (imageFileList.length > maxQuantity) {
    showNotification("Chỉ có thể chọn tối đa $maxQuantity hình ảnh!",
        status: Status.error);
    imageFileList = imageFileList.take(maxQuantity).toList();
  }
  return upload(imageFileList, type: type, folder: folder, context: context);
}

Future<List<XFile>> selectImages(
  List<XFile> imageFileList, {
  bool multi = false,
}) async {
  final ImagePicker picker = ImagePicker();
  List<XFile>? selectedImages = [];
  try {
    if (multi == true) {
      selectedImages = await picker.pickMultiImage();
    } else {
      final XFile? selectedImage =
          await picker.pickImage(source: ImageSource.gallery);
      selectedImages = selectedImage != null ? [selectedImage] : [];
    }
  } catch (error) {
    print("error: $error");
  }

  if (selectedImages != null && selectedImages.isNotEmpty) {
    imageFileList.addAll(selectedImages.toList());
  } else {
    print('No image selected.');
  }
  return imageFileList;
}

Future<List<String>> upload(
  List<XFile> imageFileList, {
  String type = "User",
  String folder = "",
  Map<String, dynamic>? context,
}) async {
  try {
    final CancelFunc cancel = showLoading();
    final List<CloudinaryResponse> response =
        await cloudinary.uploadFiles(imageFileList
            .map(
              (image) => CloudinaryFile.fromFile(
                image.path,
                folder: type + (folder != "" ? '/$folder' : ""),
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
