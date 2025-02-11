// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:medicine_reminder/core/theme/colors.dart';
import 'package:medicine_reminder/feature/medicine/viewmodel/medicine_viewmodel.dart';
import 'package:provider/provider.dart';

class PillList extends StatefulWidget {
  const PillList({super.key});

  @override
  State<PillList> createState() => _PillListState();
}

class _PillListState extends State<PillList> {
  late MedicineViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MedicineViewModel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.fetchUserMedicines();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MedicineViewModel>(
      create: (_) => _viewModel,
      child: Consumer<MedicineViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_outlined),
              ),
              title: const Text('İlaç Listesi'),
            ),
            body: viewModel.isLoading
                ? const Center(child: CircularProgressIndicator())
                : viewModel.allMedicines.isEmpty
                    ? const Center(child: Text('Henüz bir ilaç eklenmedi.'))
                    : ListView.builder(
                        itemCount: viewModel.allMedicines.length,
                        itemBuilder: (context, index) {
                          final medicine = viewModel.allMedicines[index];
                          final reminderTimesFormatted = medicine
                                  .reminderTimes
                                  ?.map((time) =>
                                      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}')
                                  .join(',  ') ??
                              'Belirtilmemiş';

                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Card(
                              color: const Color.fromARGB(255, 246, 244, 235),
                              child: ListTile(
                                title: Text(
                                  medicine.medicationName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Dozaj: ${medicine.dosage}, '
                                  'Hatırlatma Saatleri: $reminderTimesFormatted',
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: AppColors.secondaryColor),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        backgroundColor: AppColors.white,
                                        title: const Text(
                                          'Silme Onayı',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        content: const Text(
                                            'Bu ilacı silmek istediğinizden emin misiniz?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text(
                                              'Hayır',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text(
                                              'Evet',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
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
