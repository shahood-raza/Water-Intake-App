import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake_app/models/water_model.dart';
import 'package:water_intake_app/providers/water_provider.dart';

class WaterTile extends StatelessWidget {
  const WaterTile({
    super.key,
    required this.waterModel,
  });

  final WaterModel waterModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
       color: Colors.lightBlue[50],
       
       shadowColor: Colors.lightBlue[50],
      child: ListTile(
        title: Row(
          children: [
            Icon(Icons.water_drop_sharp, size: 25, color: Colors.blue,),
            Text('${waterModel.amount.toStringAsFixed(2)} ml',
            style: Theme.of(context).textTheme.titleMedium,),
          ],
        ),
        subtitle: Text('${waterModel.dateTime.day}/${waterModel.dateTime.month}/${waterModel.dateTime.year}'),
        trailing: IconButton(onPressed: (){
          Provider.of<WaterProvider>(context, listen: false).delete(waterModel);
        }, icon: Icon(Icons.delete, color: Colors.redAccent,),),
      ),
    );
  }
}
