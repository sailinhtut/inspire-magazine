// import 'package:flutter/material.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

// class PreviewContentScreen extends StatefulWidget {
//   const PreviewContentScreen(
//       {super.key, required this.contentTitle, required this.htmlContent});

//   final String htmlContent;
//   final String contentTitle;

//   @override
//   State<PreviewContentScreen> createState() => _PreviewContentScreenState();
// }

// class _PreviewContentScreenState extends State<PreviewContentScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(widget.contentTitle),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: HtmlWidget(
//           widget.htmlContent,
//           onTapUrl: (url) {
//             window.open(url, url);
//             return true;
//           },
//           renderMode: RenderMode.listView,
//           textStyle: const TextStyle(fontSize: 14),
//         ),
//       ),
//     );
//   }
// }
