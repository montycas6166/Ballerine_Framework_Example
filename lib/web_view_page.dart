import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key, this.onVerificationDone}) : super(key: key);
  final Function(Map<String, List<String>> queryParameters)? onVerificationDone;

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  double progress = 0;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        allowFileAccessFromFileURLs: true,
        cacheEnabled: true,
        javaScriptCanOpenWindowsAutomatically: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
        useShouldInterceptRequest: true,
        allowFileAccess: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(context).padding,
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialOptions: options,
              androidOnPermissionRequest: (InAppWebViewController controller,
                  String origin, List<String> resources) async {
                print('CHECK ' + resources.toString());
                return PermissionRequestResponse(
                    resources: resources,
                    action: PermissionRequestResponseAction.GRANT);
              },
              onWebViewCreated: (controller) {
                webViewController = controller;
                webViewController?.loadUrl(
                  urlRequest: URLRequest(
                    url: Uri.parse("https://vendy.dev.ballerine.app"),
                  ),
                );
              },
              onUpdateVisitedHistory: (controller, Uri? url, androidIsReload) async {
                if (url.toString().contains("close")  ) {
                  if (widget.onVerificationDone != null  ) {
                    widget.onVerificationDone!(url!.queryParametersAll);
                  }
                  Navigator.pop(context);
                }
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {}
                setState(
                      () {
                    this.progress = progress / 100;
                  },
                );
              },
            ),
            progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container(),
          ],
        ),
      ),
    );
  }
}
