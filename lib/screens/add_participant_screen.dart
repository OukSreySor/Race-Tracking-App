import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:race_tracking_app/model/participant.dart';
import 'package:race_tracking_app/providers/participant_provider.dart';
import 'package:race_tracking_app/widgets/inputs/custom_textfield.dart';
import 'package:race_tracking_app/widgets/actions/custom_action_button.dart';

class AddParticipantScreen extends StatefulWidget {
  final Participant? participant;
  const AddParticipantScreen({this.participant, super.key});

  @override
  State<AddParticipantScreen> createState() => _AddParticipantScreenState();
}

class _AddParticipantScreenState extends State<AddParticipantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  String? _selectedGender;
  final _bibController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.participant != null) {
      _bibController.text = widget.participant!.bib;
      _nameController.text = widget.participant!.name;
      _selectedGender = widget.participant!.gender;
      _ageController.text = widget.participant!.age.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bibController.dispose();
    _ageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ParticipantProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Participants'),
        leading: const BackButton(),
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
                labelText: 'BIB',
                controller: _bibController,
                hintText: 'Enter bib number',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a BIB number';
                  }
                  final bib = value.trim();

                  // Skip checking duplicate if editing same participant
                  if (widget.participant == null || widget.participant!.bib != bib) {
                    if (provider.isBibAlreadyUsed(bib)) {
                      return 'This BIB number is already in use';
                    }
                  }
                  return null;
                },
              ),
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
                hint: Text(
                  'Select gender',
                  style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                ),
                style: const TextStyle(fontSize: 16, color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(color: Colors.black26),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                ),
                value: _selectedGender,
                items: <String>['M', 'F', 'Other']
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
                labelText: 'Age',
                controller: _ageController,
                hintText: 'Enter age',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter age';
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
                    final newBib = _bibController.text.trim();

                    if (widget.participant == null || widget.participant!.bib != newBib) {
                      if (provider.isBibAlreadyUsed(newBib)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('BIB number already exists')),
                        );
                        return;
                      }
                    }

                    final newParticipant = Participant(
                      bib: newBib,
                      name: _nameController.text,
                      gender: _selectedGender!,
                      age: int.parse(_ageController.text),
                    );

                    if (widget.participant != null) {
                      provider.updateParticipant(widget.participant!.id, newParticipant);
                    } else {
                      provider.addParticipant(newParticipant);
                    }

                    Navigator.pop(context);
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