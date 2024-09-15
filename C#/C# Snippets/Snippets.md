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

// Check if string value is less then value 12
```
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


//  Advanced If Statements
```
Console.Write(value: "What is your first Name");
string firstName = Console.ReadLine();

Console.Write(value: "What is your last name:");
string lastName = Console.ReadLine();

if (firstName.ToLower() == "x" &&
    lastName.ToLower() == "y")
{
    Console.WriteLine(value: "xy");
}
else if (firstName.ToLower() == "y")
{
    Console.WriteLine(value: "yx"); 
}

else if (lastName.ToLower() == "P")
{
    Console.WriteLine(value: "pyx");
}


```

// Arrys

```

string[] firstNames = new string[5];

firstNames[0] = "A";
firstNames[1] = "B";
firstNames[2] = "C";
firstNames[3] = "D";
firstNames[4] = "E";

Console.WriteLine(value: $" the values in the array firstNames is {firstNames[0]}, {firstNames[1]}");
Console.WriteLine(firstNames[firstNames.Length -1 ]);

```

// Split Array 

```
String secNamesData = "A,B,C,D,E";
string[] secNames = secNamesData.Split(separator: ",");
Console.WriteLine(value: $" the value 2 in the array secNames is  {(secNames[2])} ");
```

// Dictionary String

```
Dictionary<string, string> lookup = new Dictionary<string, string>();

lookup[key: "animal"] = "Not a human";
lookup[key: "fish"] = "Not a human that swims";
lookup[key: "human"] = "us";

Console.WriteLine(value: $"what is a fish: {lookup[key:"fish"]}");

```

// Dictionary Int
```
Dictionary<int, string> employees = new Dictionary<int, string>();
employees[key:100] = "A";
employees[key: 80] = "B";
employees[key: 40] = "C";
employees[key: 20] = "D";

Console.WriteLine(value: $"Write employees id with the id 80 {employees[key: 80]}");
Console.WriteLine(value: $"Write employees id with the id 80 {employees[key: 100]}");
```

// Foreach
```
string letters = "A,B,C,D";
List<string> values = letters.Split(',').ToList();

foreach (string value in values)
{
   Console.WriteLine(value);
}
```

// For loops
```
// Stop before 10
for (int i = 0; i < 10; i++)
{
    Console.WriteLine(value: $"the value of i is {i}");
}
```

// For loops Write out the string
```
string data = "A,B,C,D,E";
List<string> values = data.Split(separator: ',').ToList();


for (int i = 0; i < values.Count; i++)
{
    Console.WriteLine(values[i]);
}
```

// For loops Count and add
```
// Count
List<decimal> charges = new List<decimal>();
charges.Add(item: 25M);
charges.Add(item: 25M);

decimal total = 0;
for (int i = 0; i < charges.Count; i++)
{
    total += charges[i];
}

Console.WriteLine(value: $"the value of charge is {total}");
```



// Do while loops
```
do
{
  // run the code at least once
} while (true);


} while (true);
{
 // run the code 0 or more times
}

```

// Do while loops
```
bool isValidAge;
int age;
do
{
    Console.Write(value: " is your age ");
    string ageText = Console.ReadLine();

    isValidAge = int.TryParse(ageText, out age);

    if (isValidAge == false)
    {
        Console.WriteLine(value: "That was an invalid age");

    }
} 

while (isValidAge == false);

Console.WriteLine(value: $"your age is {age}");

```
