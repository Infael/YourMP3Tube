import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function(String) onTap;

  @override
  _TextInputState createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  TextEditingController inputController = TextEditingController();

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          TextField(
            controller: inputController,
            decoration: InputDecoration(
              focusColor: Theme.of(context).accentColor,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            onSubmitted: (input) {
              widget.onTap(input);
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final clipPaste =
                      await Clipboard.getData(Clipboard.kTextPlain);
                  setState(() {
                    inputController.text = clipPaste!.text!;
                  });
                },
                child: Icon(Icons.paste),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor),
              ),
              SizedBox(width: 50),
              ElevatedButton(
                onPressed: () {
                  widget.onTap(inputController.text);
                },
                child: Icon(Icons.search),
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor),
              ),
            ],
          )
        ],
      ),
    );
  }
}
