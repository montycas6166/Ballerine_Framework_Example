import 'package:ballerina_framework_example/web_view_page.dart';
import 'package:flutter/material.dart';

class OpenFlowScreen extends StatefulWidget {
  const OpenFlowScreen({Key? key}) : super(key: key);

  @override
  State<OpenFlowScreen> createState() => _OpenFlowScreenState();
}

class _OpenFlowScreenState extends State<OpenFlowScreen> {
  String? params;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(context).padding,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  params = null;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => WebViewScreen(
                        onVerificationDone:
                            (Map<String, List<String>> queryParameters) {
                          params = queryParameters.toString();
                          setState(() {});
                        },
                      ),
                    ),
                  );
                },
                child: const Text("Open Flow"),
              ),
              if (params != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(params ?? ""),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
