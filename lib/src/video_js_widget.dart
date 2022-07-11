import 'dart:html' as html;
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:video_js/src/web/video_js_scripts.dart';
import 'package:video_js/video_js.dart';

class VideoJsWidget extends StatefulWidget {
  final VideoJsController videoJsController;

  const VideoJsWidget({Key? key, required this.videoJsController})
      : super(key: key);

  @override
  VideoJsWidgetState createState() => VideoJsWidgetState();
}

class VideoJsWidgetState extends State<VideoJsWidget> {
  late String elementId;

  @override
  void dispose() {
    super.dispose();
    html.Element? ele = html.querySelector("#divId");
    if (html.querySelector("#divId") != null) {
      ele!.remove();
    }
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      elementId = generateRandomString(7);
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(elementId, (int id) {
        final html.Element htmlElement = html.DivElement()
          ..id = "divId"
          ..style.width = '100%'
          ..style.height = '100%'
          ..children = [
            html.VideoElement()
              ..id = widget.videoJsController.playerId
              ..style.minHeight = "100%"
              ..style.minHeight = "100%"
              ..style.width = "100%"
              //..style.height = "auto"
              ..className = "video-js vjs-theme-city",
            html.ScriptElement()
              ..innerHtml = VideoJsScripts().videojsCode(
                widget.videoJsController.playerId,
                getVideoJsOptions(widget.videoJsController.videoJsOptions),
              )
          ];
        return htmlElement;
      });
    }
  }

  /// Get video initial options as a json
  Map<String, dynamic> getVideoJsOptions(VideoJsOptions? videoJsOptions) {
    return videoJsOptions != null ? videoJsOptions.toJson() : {};
  }

  /// To generate random string for HtmlElementView ID
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: elementId);
  }
}
