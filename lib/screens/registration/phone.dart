import 'package:findit/services/http_query.dart';
import 'package:findit/widgets/masked_text.dart';
import 'package:flutter/material.dart';

class PhoneScreen extends StatelessWidget {

  var controller = new MaskedTextController(mask: '(000) 000-00-00');
  final labelStyle = TextStyle(
      color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.w200);
  final hintStyle = TextStyle(color: Colors.white70);

  String phoneInputValidator() {
    if (controller.unmaskedText.isEmpty) {
      return "Введите номер!";
    } else if (controller.unmaskedText.length != 10) {
      return "Номер введён неверно!";
    }
    return null;
  }

  submitPhoneButton(BuildContext context) async {
    final error = phoneInputValidator();
    if (error != null) {} else {
      Map data = await HttpQuery.executeJsonQuery("auth/request_sms",
          params: {"phone": "7" + controller.unmaskedText}, method: "post");
      if (data["error"]) {
        return;
      }
    }
  }

  Widget buildAuthPhoneScreen() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: new TextField(
        controller: controller,
        maxLength: 15,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 24.0,
            color: Colors.white,
            fontFamily: 'PoiretOne',
            fontWeight: FontWeight.w800),
        decoration: InputDecoration(
          isDense: false,
          counterText: "",
          hintText: "(999) 999-99-99",
          hintStyle: hintStyle,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget buildConfirmInputButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.check),
      color: Colors.white,
      disabledColor: Colors.grey,
      onPressed: () => submitPhoneButton(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          Center(
              child: Text('Сперва, введи свой номер телефона',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'PoiretOne',
                    fontSize: 24.0,
                    fontWeight: FontWeight.w200),
                textAlign: TextAlign.center,)
          ),
          Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8.0, horizontal: 48.0),
              child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(child: Text("+7", style: new TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontFamily: 'PoiretOne',
                        fontWeight: FontWeight.w800)),
                        flex: 1),
                    Flexible(child: buildAuthPhoneScreen(), flex: 6),
                    Flexible(
                        child: buildConfirmInputButton(context), flex: 1)
                  ]))
        ]);
  }

}