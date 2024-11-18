import 'dart:convert';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';

class DynamicLoginUI extends StatefulWidget {
  const DynamicLoginUI({super.key});

  @override
  State<DynamicLoginUI> createState() => _DynamicLoginUIState();
}

class _DynamicLoginUIState extends State<DynamicLoginUI> {
  JsonWidgetData? jsonData;

  @override
  void initState() {
    super.initState();
    _loadJson();
  }

  bool validateForm(String formContext) {
    final email = JsonWidgetRegistry.instance.getValue('email_address');

    if (email == null || email.trim().isEmpty) {
      print('Email is required.');
      return false;
    }

    if (!email.contains('@')) {
      print('Email must contain "@" symbol.');
      return false;
    }
    print('Form is valid!');
    return true;
  }

  void _loadJson() async {
    String jsonString = await rootBundle.loadString('assets/login_ui.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    final registry = JsonWidgetRegistry.instance;

    //"onPressed": "validateForm('form_context')",
    registry.registerFunction('validateForm',
            ({args, required registry}) {
          if (args != null && args!.isEmpty) {
            bool isValid = validateForm(args[0]);
            if (isValid) {
              print('Form is valid');
            } else {
              print('Form is invalid');
            }
            return isValid;
          }
          print('No arguments provided for validateForm');
          return false;
        }
    );

    registry.setValue('onLoginPressed', (){
      print("Login Apasat");
    });

    jsonData = JsonWidgetData.fromDynamic(jsonMap, registry: registry);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (jsonData == null) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: jsonData!.build(context: context),
        ),
      ),
    );
  }
}