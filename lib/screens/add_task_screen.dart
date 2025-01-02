import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/model_class/task_model.dart';

import '../utils/locator.dart';
import '../utils/shared_preference_handler.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key});

  @override
  AddTaskDialogState createState() => AddTaskDialogState();
}

class AddTaskDialogState extends State<AddTaskDialog> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? selectedDate;
  bool isLoading = false;

  void pickDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void saveTask(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      if (selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date and time')),
        );
      } else {
        setState(() {
          isLoading = true;
        });
        final preference = getIt<SharedPreferenceHandler>();
        List<TaskModel> taskList = await preference.getTasks();

        taskList.add(TaskModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: titleController.text,
          description: descriptionController.text,
          scheduleDateTime: selectedDate!.toIso8601String(),
        ));

        await preference.saveTask(taskList);
        setState(() {
          isLoading = false;
        });

        if (context.mounted) {
          Navigator.pop(context, true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Task'),
      content: isLoading
          ? const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(labelText: 'Title'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedDate == null
                                ? 'No date selected'
                                : 'Selected: ${DateFormat.yMMMd().add_jm().format(selectedDate!)}',
                          ),
                        ),
                        TextButton(
                          onPressed: pickDateTime,
                          child: const Text('Select Date & Time'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => saveTask(context),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
