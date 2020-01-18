# Disassembling_x86_Executable
  The goal of this homework was to identify the purpose and flaws of an executable file written for x86 Intel ISA. After doing that we had to optimize the program in two different ways: 
  - Memory optimization: The executable file had to be as small as possible 
  - Speed optimization: The executable file had to fulfill its functions in as little time as possible( by removing useless operations and improving the time complexity of the functions used )
  
  In the end, the memory optimization was underwhelming( at 90% of original size ) but the speed optimization was 3x faster
  for an input file with a couple hundred lines.
 
 Disclaimer: Translation was done using an online resource. For original text( in romanian ) see README_Romanian
 
I will assume the use of the CDECL convention for all functions.
______________________________________________________________________________

The analysis of a function will have the following format:

function_name () - short description
@ arg_1: description
@ arg_2: description
...
@arg_n: description

[Detailed description of the function]

BUGS:
- bug_1
- bug_2
...
- bug_k
POSSIBLE IMPROVEMENTS (it will be assumed that the bugs have already been repaired):
- improvement_1
- improvement_2
...
- improvement_p

Return: description for the return value
Prototype: (return_type) function_name (arg_1, ..., arg_n);
______________________________________________________________________________

mystery1 () - a function that calculates the length of a byte string
finished with null
@string: the starting address of the string

The function has only one argument. This represents the address of a null string
finished bytes. Return the length of the string (without terminator).

BUGS:
- Editing the EDI register (does not comply with CDECL).
POSSIBLE IMPROVEMENTS:
- Using ECX register instead of EBX so that it is no longer needed
let's save it and restore it.
- EAX will no longer be increased, but will eventually be calculated by subtracting
from the final address (the one with '\ 0') to the initial one.
Return: an integer equal to the length of the string;
Prototype: int mystery1 (char * string);
______________________________________________________________________________

mystery2 () - function that looks for the first occurrence of a character in a
character string
@string: the starting address of the string
@c: The searched character

The function has two arguments. The first is the address of the string in which it is searched
the character. The second is the character to look for. The line goes through,
comparing at each step the current character with the one you are looking for. Be supposed to
if the string is not empty then the character will be found at least once in the string.

BUGS:
- Modification of the EBX register (does not comply with CDECL).
POSSIBLE IMPROVEMENTS
- EAX will no longer be increased, but will eventually be calculated by subtracting
from the final address (the one with '\ 0') to the initial one.
- The strlen (mystery1) function is no longer used to see if
the string is empty or not. It simply checks if the first element
is the null terminator or not.
Return: - "-1" if the string is empty, otherwise the index at which it is
first find the character
Prototype: int mystery2 (char * string, char c);
______________________________________________________________________________

mystery3 () - function that checks the equality of two byte vectors
@ v1: address of the first vector
@ v2: address of the second vector
@n: the length of the vectors

The function has three arguments. The first two represent the compared vectors.
The third argument is the length of the vectors. The function compares, to
each step, the bytes on position 'i' in each vector. If they are identical
continue the comparison. If not, leave the function and return 1. If yes
it reaches the end of the byte pairs and no pair was found
different then returns 0.

BUGS:
- Modification of the EBX register (does not comply with CDECL).
POSSIBLE IMPROVEMENTS:
Return: - 0 if the vectors are equal, 1 otherwise.
Prototype: int mystery3 (char * v1, char * v2, int n);
______________________________________________________________________________

mystery4 () - function that copies the contents of an octet vector into
another
@destination: address of the first vector
@source: address of the second vector
@n: the length of the vectors

The function has three arguments. The first is the vector from which it is copied and al
the second is the vector in which it is copied. The third argument is
the length of the vectors. The function copies, at every step, the byte of the position
'i' from the first vector to the second.

BUGS:
- Modification of the EBX register (does not comply with CDECL).
POSSIBLE IMPROVEMENTS:
Return: Nothing
Prototype: void mystery4 (char * destination, char * source, int n);
______________________________________________________________________________

mystery5 () - function that checks if a character is a number
@c: character examined

The function has an argument, the character to be examined. If its value is lower
than '0' or greater than '9' will return 0. Otherwise 1 will return.

BUGS:
POSSIBLE IMPROVEMENTS:
Return: 1 if the number, 0 otherwise.
Prototype: int mystery5 (char c);
______________________________________________________________________________

mystery6 () - function that reverses the order of the characters of a string
of null character completed
@string: the address of the string

The function has a parameter. This represents the address of the null terminated string which
will be reversed. The mystery1 function is called, which is equivalent to a
strlen. Using the length of the string allocates memory on the stack for all this
bytes. The characters are copied in reverse order. The function is called
mystery4, which is equivalent to a memcpy and copies the contents of the vector
from the stack to the initial string address.

BUGS:
- Modification of EBX and EDI registers (does not comply with CDECL).
POSSIBLE IMPROVEMENTS:
Return: Nothing
Prototype: void mystery6 (char * string);
______________________________________________________________________________

mystery7 () - a function that converts a string to a
whole number
@string: the address of the string

The function has a parameter. This represents the address of the null terminated string which
will be converted. First calculate its length and then se
invert the string so that the function loop works using
loop instruction. At each step it is checked if the current character is the number.
If yes, it is added to the current value after it is multiplied by 10.
If not, it goes out of the loop and the function returns -1. In the end, he returns
the value obtained.

BUGS:
- Modification of EBX and ESI registers (does not comply with CDECL).
POSSIBLE IMPROVEMENTS:
- Instead of inverting the string and calculating its length, it will
goes uphill, from small to large indexes, and the stopping condition
will be the meeting of the character '\ 0'.
- Saving only the strictly necessary (save registers of which it is not
need ).
Return: -1 if the string is NAN (not a number), the numeric value of the string
otherwise
Prototype: int mystery7 (char * string);
______________________________________________________________________________

mystery8 () - function that checks if one string includes another string
@haystack: the address of the string in which it is searched
@needle: searched string address
@sizeof_needle: 'needle' string length

The function has three parameters. The first two are the search string respectively
the searched string. The third is the length of the searched string. The function uses two
local variables to retain the current index in each of the strings.
Compare the characters from the current indexes for each string. If they are
different, the index for the 'needle' string is reset. If the index for
string 'needle' reaches 'sizeof_needle' then string has been found and function
returns 1. Otherwise returns 0.

BUGS:
POSSIBLE IMPROVEMENTS:
Return: 1 if found 'needle' in 'haystack', 0 otherwise.
Prototype: int mystery8 (char * haystack, char * needle, int sizeof_needle);
______________________________________________________________________________

mystery9 () - function that displays all the lines in a text in which
a certain string is found
@text: The address of the string representing the text
@from: the index from which the search begins
@to: the index to which you are looking
@needle: searched string address

The function has 4 parameters. The first and last represent strings.
The second and third represent indices between which the string is searched
looked up.

BUGS:
POSSIBLE IMPROVEMENTS:
Return: Nothing
Prototype: void mystery9 (char * text, int from, int to, char * needle);
______________________________________________________________________________

The program as a whole: search in a text, sent from the keyboard
or existing in a file, a word in a range of characters.

options:
- Option "-f" followed by the searched word; absence leads to lack of
output from the program.
- Option "-i" followed by the name of the input file; absent leads to
reading from the keyboard of the text.
- The "-s" option followed by an integer representing the index
the character of the text from which the search begins; absent leads to
using the number 0 instead.
- The "-e" option followed by an integer representing the index
the character of the text until the search is made; absent leads to
using the number of characters read instead.

BUGS:
- The "-e" option has the following bug: the string search will not be applied
in the last line of the given character range only if the interval
ends with the character '\ n'; This is because it is
apply search only when the '\ n' character is encountered.
______________________________________________________________________________

SPEED OPTIMIZATION:
- The improvements described above were applied (not all; only those
that affected the program the most, that is, those related to
mystery9 function);
- Redundant operations were removed from many places in the program. And
some redundant function calls.
