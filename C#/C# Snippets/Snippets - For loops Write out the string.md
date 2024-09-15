// For loops Write out the string

```

string data = "A,B,C,D,E";
List<string> values = data.Split(separator: ',').ToList();


for (int i = 0; i < values.Count; i++)
{
    Console.WriteLine(values[i]);
}

```
