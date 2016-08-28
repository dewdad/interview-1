MySidewalk Programming Challenge

Sorting Challenge

## How To:

1. `docker-compose run sidewalk-sort ./files/test.txt`

The deliverable is a collection of ruby spec tests and ruby scripts
that are wrapped in a docker-compose file to make them easy to run.


## Troubleshooting

Docker isn't cooperating
- If you have ruby (this should work on a mac), you can try running on bare metal
  - `ruby main.rb ./files/test.txt`

I'd like to run the program on a different dataset/file
- Cool! Place your file into the `.files/` directory
- And then run `docker-compose run sidewalk-sort ./files/<name-of-your-file>`
  - Your sorted output file should appear in the `./files` directory on completion as `./files/<name-of-your-file>-output.txt`

My input file isn't working (`No such file or directory @ rb_sysopen`)
- Make sure your test files are in the `./files` directory

Do I have to run test files from the `./files` directory?
- Yep, the docker container only mounts that directory to read/write from


## Test Suite

- The tests are automatically run as part of the `docker-compose build` (which
  in turn should run as part of the `docker-compose run`), and the
  output should show up during "Step 6"
- Alternatively, you can run them yourself locally if you have ruby on your machine
  - `rspec spec/sort_spec.rb`
    - might need to run `bundle install` first to get rspec loaded


## Other notes

Extra features of this script, not explicitly outlined in the prompt:
- Handle negative numbers, floats/decimals
- Handle whitespace (or lack thereof)
- Handle basically any ASCII character in the "string" part
  - oops, looking back at the instructions I see now that Unicode is specifically mentioned, sorry about that!

Things this program can't do:
- Handle exponents or really any other number format that has characters
  other than numeric digits (0-9), a leading dash (-), or at most one period (.)
- Unicode things
- Help you decide where to go to lunch


## Prompt:

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
