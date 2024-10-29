

import 'package:flutter/material.dart';

class ToDoTile extends StatelessWidget{

  final String taskName;
  final bool taskCompleted;
  Function(bool?)? onChanged;

  ToDoTile({
    super.key,
    required this.taskName,
    required this.taskCompleted,
    required this.onChanged
  });



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0,top: 24.0,right: 24.0,bottom: 0.0),
      child: Container(
        padding: EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple[200]
      ),
        child: Row(
          children: [
            Checkbox(value: taskCompleted, onChanged: onChanged),

            Text(taskName),
          ],
        ),
      ),
    );

  }

}

