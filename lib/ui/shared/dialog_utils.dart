import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(BuildContext context, String message){
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Thông báo!',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.red), textAlign: TextAlign.center,),
      content: Text(message,style: TextStyle(fontSize:18, fontWeight: FontWeight.w400)),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: ActionButton(
                actionText :"Có",
                onPressed: (){
                  Navigator.of(ctx).pop(false);
                },
              ),
            ),
            Expanded(
              child: ActionButton(
                actionText :"Không",
                onPressed: (){
                  Navigator.of(ctx).pop(true);
                },
              
              )
            ),
          ],
        ),
      ],
    ),
  );
}
Future<void> showErrorDialog(BuildContext context, String message) {
    return showDialog(
      context: context, 
      builder: (ctx) => AlertDialog(
        title: const Text("Thông báo!", style: TextStyle(fontSize: 15),),
        content: Text(message),
        actions: <Widget>[
          ActionButton(
            onPressed: (){
              Navigator.of(ctx).pop();
            },
          )
        ],
      ));
  }

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.actionText,
    this.onPressed,
  });

  final String? actionText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context){
    return TextButton(
      onPressed: onPressed,
      child: Text(
        actionText ?? 'Okay',
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 24,
        ),
      ),
    );
  }

 
}