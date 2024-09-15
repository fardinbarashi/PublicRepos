// For loops Int Count and add

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

