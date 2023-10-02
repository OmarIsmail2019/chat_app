// import 'dart:developer';

// import 'package:chat/features/profile/widgets/circle_avatar_of_chose_image.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class BuildBottomSheet extends StatelessWidget {
//   const BuildBottomSheet({
//     super.key,
//     required this.context,
//   });

//   final BuildContext context;

//   @override
//   Widget build(BuildContext context) {
//     final ImagePicker picker = ImagePicker();
//     final String? image;
//     return Container(
//       height: MediaQuery.sizeOf(context).height * 0.18,
//       width: MediaQuery.sizeOf(context).width,
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Text(
//             'Picked profile image',
//             style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                   fontSize: 24,
//                 ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               CircleAvaterOfChoseImage(
//                 imagePath: 'assets/app_icon/camera.png',
//                 onTap: () async {
//                   // Capture a photo.

//                final XFile? image = await picker.pickImage(
//                     source: ImageSource.camera,
//                   );
//                   if (image != null) {
//                     log('Image path: ${image.path}  .... Mime type: ${image.mimeType}');
//                   }
//                 },
//               ),
//               CircleAvaterOfChoseImage(
//                 imagePath: 'assets/app_icon/photo.png',
//                 onTap: () async {
//                   final XFile? image = await picker.pickImage(
//                     source: ImageSource.gallery,
//                   );
//                   if (image != null) {
//                     log('Image path: ${image.path}  .... Mime type: ${image.mimeType}');
//                   }
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
