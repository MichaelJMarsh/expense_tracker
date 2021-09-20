import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/adaptive_button.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;
  NewTransaction({@required this.addNewTransaction});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addNewTransaction(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    Navigator.pop(context);
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: mediaQuery.viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: "Title"),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              TextField(
                decoration: const InputDecoration(labelText: "Amount"),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(
                  decimal: true,
                ),
                // _ => argument that is not imporant but still requires name
                onSubmitted: (_) => _submitData(),
              ),
              // Date Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? "No Date Chosen!"
                          : "Picked date: " +
                              DateFormat.yMd().format(_selectedDate),
                    ),
                  ),
                  AdaptiveTextButton(
                    text: "Choose Date",
                    handler: _presentDatePicker,
                  ),
                ],
              ),
              Platform.isIOS
                  ? CupertinoButton(
                      child: Text(
                        "Add Transaction",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.button.color,
                        ),
                      ),
                      color: Theme.of(context).primaryColor,
                      onPressed: _submitData,
                    )
                  : ElevatedButton(
                      child: Text(
                        "Add Transaction",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.button.color,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                      ),
                      onPressed: _submitData,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
