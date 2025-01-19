import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/medicine/model/medicine_model.dart';
import 'package:medicine_reminder/feature/medicine/viewmodel/medicine_viewmodel.dart';
import 'package:provider/provider.dart';

class PillList extends StatefulWidget {
  const PillList({super.key});

  @override
  State<PillList> createState() => _PillListState();
}

class _PillListState extends State<PillList> {
  @override
  Widget build(BuildContext context) {
    final medicineViewModel = Provider.of<MedicineViewModel>(context);
    final List<MedicineModel> items = medicineViewModel.allMedicines;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'Kullanılan İlaçlar',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: items.isEmpty
            ? const Center(
                child: Text(
                  'Hiç ilaç eklenmemiş.',
                  style: TextStyle(fontSize: 16),
                ),
              )
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                  thickness: 1,
                ),
                itemBuilder: (context, index) {
                  final medicine = items[index];
                  return ListTile(
                    title: Row(
                      children: [
                        Text(
                          '${index + 1}. ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(medicine.medicationName),
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        // Add delete functionality here
                      },
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
