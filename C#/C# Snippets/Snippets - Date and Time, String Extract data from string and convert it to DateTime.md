// Date and Time

```

Extract data from string and convert it to DateTime
string xValue = "18841130";

 // extract 
int yearOfBirth = int.Parse(xValue.Substring(0, 4));
int yearOfMonth = int.Parse(xValue.Substring(4, 2));
int yearOfDay = int.Parse(xValue.Substring(6, 2));

// Count Todays age
DateTime xValueDate = new DateTime(yearOfBirth, yearOfMonth, yearOfDay);
int xValueDate = DateTime.Now.Year - yearOfBirth;

```
