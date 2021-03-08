import 'package:translator/translator.dart';
import 'Languages.dart';

Future<String> trans(var input,var lang) async {
  try {
    final translator = GoogleTranslator();
    var translation = await translator.translate(input, to: lang);
    return translation.toString();
  }
  catch(e){
    var cc = "Something Went wrong";
    print(cc);
    return cc;
  }
}
