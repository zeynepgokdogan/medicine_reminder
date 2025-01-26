// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_reminder/feature/medicine/viewmodel/medicine_viewmodel.dart';
import 'package:provider/provider.dart';

class PillList extends StatelessWidget {
  const PillList({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MedicineViewModel>(
      create: (_) => MedicineViewModel()..fetchUserMedicines(),
      child: Consumer<MedicineViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Pill List'),
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.allMedicines.isEmpty
                    ? const Center(child: Text('Henüz bir ilaç eklenmedi.'))
                    : ListView.builder(
                        itemCount: viewModel.allMedicines.length,
                        itemBuilder: (context, index) {
                          final medicine = viewModel.allMedicines[index];
                          return Card(
                            child: ListTile(
                              title: Text(medicine.medicationName),
                              subtitle: Text(
                                'Dozaj: ${medicine.dosage}, Başlangıç: ${DateFormat('dd MMM yyyy').format(medicine.startDate)}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Silme Onayı'),
                                      content: const Text(
                                          'Bu ilacı silmek istediğinizden emin misiniz?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text('Hayır'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(true),
                                          child: const Text('Evet'),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (confirm == true) {
                                    await viewModel.deleteMedicineById(
                                        medicine.id!, context);
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}
