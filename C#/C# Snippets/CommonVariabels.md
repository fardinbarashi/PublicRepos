// string
```
string value = "12";

```

// Bool is True or False, by default it is false
```
bool isComplete = false;
Console.WriteLine(isComplete);

```

// Date and Time
```
// Dateonly
DateOnly birthday = DateOnly.Parse(s: "1/5/1983");
Console.WriteLine(birthday.ToString(format:"MM/dd/yy"));
```

// Decimal
```
// Is only for bank / finincal
Int 32 - 00000000 00000000 00000000 00000001
Int 32 is for two billion +/-
Uint - 4 billion

Wrong 
Decimal bankAccountBalance
bankAccountBalance = 2.34;

Right
Decimal bankAccountBalance
bankAccountBalance = 2.34M;
```

// Double
```
// Doubles can have a Decimal point 1.23, 43

double averageAge;
averageAge = (22 + 17 + 44) / 3;
```

 // User Input to the string
```
Console.Write("What is your Name ");
string name = Console.ReadLine();
```

```
Check if string value is less then value 12
string xValue = "12";
if (xValue.Length != 12)
{
 Console.WriteLine("String xValue is less then 12 ");
 }
 else
 {
 Console.WriteLine("String xValue is more or equel then 12 ");
 }
```

 // Extract data from string and convert it to DateTime
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

// Int32
```
// Is only for bank / finincal
Int 32 - 00000000 00000000 00000000 00000001
Int 32 is for two billion +/-
Uint - 4 billion
Dont devide Int32 values
```

// Add value to Int string
```
string value1 = "25";
int value2 = value1 + 25;
Console.WriteLine("value2);
```

// Null
```
// Create null with "?"

// Haven't asked for the age yet
int? age = null;

// Asked for the age
int age = 0;

// Other types
bool? age = null;
double? age = null;
decimal? age = null;
string? age = null;

```
