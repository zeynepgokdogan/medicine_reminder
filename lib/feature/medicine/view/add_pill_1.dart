import 'package:flutter/material.dart';
import 'package:medicine_reminder/feature/medicine/view/add_pill/add_pill_2.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_button.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_text.dart';
import 'package:medicine_reminder/feature/medicine/widget/medicine_textfield.dart';
import 'package:provider/provider.dart';

import 'package:medicine_reminder/feature/medicine/viewmodel/medicine_viewmodel.dart';

class AddPill1 extends StatefulWidget {
  const AddPill1({
    super.key,
  });

  @override
  State<AddPill1> createState() => _AddPill1State();
}

class _AddPill1State extends State<AddPill1> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MedicineText(text: 'Lütfen ilacınızın ismini girin'),
              const SizedBox(height: 30),
              MedicineTextfield(
                hintText: 'Buraya yazın...',
                controller: _nameController,
              ),
              const SizedBox(height: 30),
              MedicineButton(
                onPressed: () {
                  final pillName = _nameController.text.trim();
                  if (pillName.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lütfen İlaç İsmi Girin')),
                    );
                  } else {
                    Provider.of<MedicineViewModel>(context, listen: false)
                        .setMedicationName(pillName);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPill2(pillName: pillName),
                      ),
                    );
                  }
                },
                text: 'İlerle',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
