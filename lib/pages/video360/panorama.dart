
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:panorama/panorama.dart';
// import 'package:video_360/video_360.dart';

class PanoramaText extends StatelessWidget {
  const PanoramaText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Panorama(
        latitude: 10,
        longitude: 10,
        sensitivity: 1.0,
        zoom: 1,
        child: Image.network("https://www.vivons-maison.com/sites/default/files/styles/740px/public/field/image/appartement-de-vacances-vue-mer_0.jpg?itok=AAOprGs0"),
      ),
    );
  }
}
// class PanoramaText extends StatefulWidget {
//   @override
//   _PanoramaTextState createState() => _PanoramaTextState();
// }

// class _PanoramaTextState extends State<PanoramaText> {

//   Video360Controller? controller;

//   String durationText = '';
//   String totalText = '';

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {

//     var statusBar = MediaQuery.of(context).padding.top;

//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Video 360 Plugin example app'),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: Container(
//               width: width,
//               height: height,
//               child: Video360View(
//                 onVideo360ViewCreated: _onVideo360ViewCreated,
//                 url: 'https://bitmovin-a.akamaihd.net/content/playhouse-vr/m3u8s/105560.m3u8',
//                 onPlayInfo: (Video360PlayInfo info) {
//                   setState(() {
//                     durationText = info.duration.toString();
//                     totalText = info.total.toString();
//                   });
//                 },
//               ),
//             ),
//           ),
//           Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   MaterialButton(
//                     onPressed: () {
//                       controller?.play();
//                     },
//                     color: Colors.grey[100],
//                     child: Text('Play'),
//                   ),
//                   MaterialButton(
//                     onPressed: () {
//                       controller?.stop();
//                     },
//                     color: Colors.grey[100],
//                     child: Text('Stop'),
//                   ),
//                   MaterialButton(
//                     onPressed: () {
//                       controller?.reset();
//                     },
//                     color: Colors.grey[100],
//                     child: Text('Reset'),
//                   ),
//                   MaterialButton(
//                     onPressed: () {
//                       controller?.jumpTo(80000);
//                     },
//                     color: Colors.grey[100],
//                     child: Text('1:20'),
//                   ),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   MaterialButton(
//                     onPressed: () {
//                       controller?.seekTo(-2000);
//                     },
//                     color: Colors.grey[100],
//                     child: Text('<<'),
//                   ),
//                   MaterialButton(
//                     onPressed: () {
//                       controller?.seekTo(2000);
//                     },
//                     color: Colors.grey[100],
//                     child: Text('>>'),
//                   ),
//                   Flexible(
//                     child: MaterialButton(
//                       onPressed: () {
//                       },
//                       color: Colors.grey[100],
//                       child: Text(durationText + ' / ' + totalText),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   _onVideo360ViewCreated(Video360Controller? controller) {
//     this.controller = controller;
//   }
// }