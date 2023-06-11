import "package:flutter/material.dart";
import "package:intl/intl.dart";

class NewTransaction extends StatefulWidget {
  final Function addtx;
  NewTransaction(this.addtx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  // as far as I understand, TextEditingControllers should be inside a stateful widget. Notice that we do not call setState() anywhere inside the widget.
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();

  DateTime _selectedDate;
  //this is not final because it doesn't have an initial value and the value will be changed when the user selects the date.

  void _submitData(DateTime enteredDate) {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || enteredDate == null) {
      return;
    }
    //widget enables us to reach an entered parameter in the state of a stateful widget.The property is inside the class and we want to access the property in the state of that class, so we use widget.property.
    widget.addtx(enteredTitle, enteredAmount, enteredDate);
    Navigator.of(context).pop();
    //closes  the top most widget on screen
  }

  void _presentDatePicker() {
    //Future Class.
    //.then() method executes the function you have entered when the user selects the date(when the future object is returned.)
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now())
        .then((dateChosen) {
      if (dateChosen == null) {
        return;
      }
      setState(() {
        _selectedDate = dateChosen;
      });
    });
    //if we had another function just after the showDatePicker function, the function would execute instantly, it would not wait for the user to enter a date(it would not wait for the return of the Future object).
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          //MediaQuery.of(context).viewInsets gives us information about anything lapping our view, generally being the soft keyboard.
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: "Title"),
                controller: _titleController,
                //onChanged: (value) => titleInput = value,
                onSubmitted: (_) => _submitData(_selectedDate),
                //onSubmitted function takes a string value of the entered value which we won't use, so we name it with _ as an indicator that we will not use the value.
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                controller: _amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _submitData(_selectedDate),
                //onChanged: (value) => amountInput = value,
              ),
              Row(
                children: <Widget>[
                  // Expanded means Flexible with fit:flexfit.tight.
                  Expanded(
                    child: Text(_selectedDate == null
                        ? "No date chosen, please select a date."
                        : "Picked date:  ${DateFormat.yMMMEd().format(_selectedDate)}"),
                  ),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text("Choose Date",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                    onPressed: _presentDatePicker,
                  )
                ],
              ),
              RaisedButton(
                elevation: 5,
                child: Text("Add Transaction", style: TextStyle(fontSize: 16)),
                onPressed: () {
                  _submitData(_selectedDate);
                },
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
              )
            ],
          ),
        ),
      ),
    );
  }
}
