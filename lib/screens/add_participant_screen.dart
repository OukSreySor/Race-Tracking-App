import 'package:flutter/material.dart';
import 'package:race_tracking_app/widgets/inputs/custom_textfield.dart';
import 'package:race_tracking_app/widgets/actions/custom_action_button.dart';

class AddParticipantScreen extends StatefulWidget {
  const AddParticipantScreen({super.key});

  @override
  State<AddParticipantScreen> createState() => _AddParticipantScreenState();
}

class _AddParticipantScreenState extends State<AddParticipantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedGender;
  final _bibController = TextEditingController();

   @override
  void dispose() {
    _nameController.dispose();
    _bibController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Participants'),
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              CustomTextField(
                labelText: 'Name',
                controller: _nameController,
                hintText: 'Enter name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14.0),
              const Text(
                'Gender',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 6.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Select gender',
                  hintStyle: const TextStyle(color: Colors.black38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 14.0),
                ),
                value: _selectedGender,
                items: <String>['Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14.0),
              CustomTextField(
                labelText: 'BIB',
                controller: _bibController,
                hintText: 'Enter bib number',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a BIB number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 60.0),
              // Add Button
              CustomActionButton(
                label: 'Add',  
                backgroundColor: Color(0xFF547792),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String name = _nameController.text;
                    String? gender = _selectedGender;
                    String bib = _bibController.text;
                    print('Name: $name, Gender: $gender, BIB: $bib');
                  }
                },
                alignment: Alignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}