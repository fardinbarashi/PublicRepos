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
