import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake_app/models/water_model.dart';
import 'package:water_intake_app/pages/about_page.dart';
import 'package:water_intake_app/pages/settings_page.dart';
import 'package:water_intake_app/providers/water_provider.dart';
import 'package:water_intake_app/widgets/water_intake_summary.dart';
import 'package:water_intake_app/widgets/water_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController amountConroller = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    await Provider.of<WaterProvider>(context, listen: false).getWater().then(
      (waterData) => {
        if (waterData.isNotEmpty)
          {
            setState(() {
              _isLoading = false;
            }),
          }
        else
          {
            setState(() {
              _isLoading = true;
            }),
          },
      },
    );
  }

  void saveWater() async {
    Provider.of<WaterProvider>(context, listen: false).addWater(
      WaterModel(
        amount: double.parse(amountConroller.text.toString()),
        dateTime: DateTime.now(),
        unit: 'ml',
      ),
    );

    if (!context.mounted) {
      return; // this means do nothing if context is mounted
    }

    clearAddWaterField();
  }

  //to clear textfield
  void clearAddWaterField() {
    amountConroller.clear();
  }

  void addWater() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Water'),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Water to your daily intake'),
            const SizedBox(height: 10),
            TextField(
              keyboardType: TextInputType.number,
              controller: amountConroller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Water Amount',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              //Save amount to Database
              saveWater();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WaterProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 4,
          // leading: Drawer(),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.car_crash_outlined)),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Weekly: ', style: Theme.of(context).textTheme.titleMedium),
              Text(
                '${value.calculateWeeklyWaterIntake(value)} ml ',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,

        body: ListView(
          children: [
            WaterIntakeSummary(startOfTheWeek: value.getStartOfWeek()),
            !_isLoading
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.waterData.length,
                    itemBuilder: (context, index) {
                      final waterModel = value.waterData[index];

                      return WaterTile(waterModel: waterModel);
                    },
                  )
                : const Center(child: CircularProgressIndicator.adaptive()),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addWater,
          tooltip: 'Add Water',
          child: const Icon(Icons.add),
        ),

        //for adding drawer
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Text(
                  'Water Intake Tracker',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),
              ListTile(
                title: const Text('About'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
