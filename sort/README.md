Chas Jhin
MySidwalk Programming Challenge
Prompt #1

Prompt:

```
The user has a file that is made up of short (less than 1000 character)
strings, each on a different line (assume any common character or
character combination that means a newline to someone might be used
interchangeably in this file). Most of these strings will be preceded by
numbers, i.e. “2 Steaks”, “10 Chicken Wings”, “343GuiltySparks”. Accept
the file from the user and return them a file with the same items sorted
first by the numeric value of any leading number (2 < 10 < 343) and then
alphabetically for the rest of the string.
```

--------

How To:

- `docker build -t sidewalk-sort .`
- `docker run -it sidewalk-sort`

---------

Extra features not explicitly outlined in the prompt:
- Handle negative numbers, floats/decimals
- Handle whitespace (or lack thereof)
- Handle basically any ASCII character in the "string" part

Things this program can't do:
- Handle exponents or really any other number format that has characters
  other than numeric digits (0-9), a leading dash (-), or at most one period (.)
- Help you decide where to go to lunch
