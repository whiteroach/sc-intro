s.boot;
s.volume.gui;

// ----------- Variables -----------
//Global
~someVar = 33;
w = 33;

//Local
(
var someLocalVar = 22;
someLocalVar;
)
// p.29
// ----------- Receiver notation, functional notation -----------
5.dup(20); // <- Receiver notation
dup(5,20); // <- Functional notation

3.1415.round(0.1); // <- Receiver notation
round(3.1415, 0.1); // <- Receiver notation

dup(round(rand(100.0),0.01),4); // 100.0.rand.round(0.01).dup(4)

// ----------- Indentation -----------
( // code block
{ // function
	CombN.ar(
		SinOsc.ar(
			midicps(
				LFNoise1.ar(3,24,
					LFSaw.ar([5,5.123], 0, 3, 80)

				)
			), 0, 0.4
		), 1, 0.3, 2
	)
}.play;
)
// 24, [5,5.123], LFSaw.ar([5,5.123], 0, 3, 80), 1, 0.4, 1 & 0.3
// select all and: Edit -> Autoindent Line or Region

// ----------- CONDITIONS -----------
// ----------- If/else -----------
if(100>50, {"very true".postln}, {"very false".postln});
/*
Operators are similar to JS but:
- == is equal, there is no straight equality
You have:
- odd
- even
- isInteger
- isFLoat
- and
- or
*/

// ----------- Case -----------
(
~num = -2;
case
{~num == 0}{"Wow".postln}
{~num == 1}{"One".postln}
{~num < 0}{"Negative number".postln}
{true}{"Catch all".postln};
)

// ----------- Functions -----------
f = {arg a,b;
	["a plus b", a + b, "a times b", a * b].postln;
};

f.value(3,7);

// or
f = {|a,b|
	["a plus b", a + b, "a times b", a * b].postln;
};
f.value(2,4);

// ----------- Arrays -----------
// create an array:
a = [10, 11, 12, 13, 14, 15, 16, 17];
// useful methods
a.reverse;
a.scramble;
a.choose;
a.size;
a.at(0);
a[0];
a.wrapAt(9) // retrieves item at specified position, wrapping around if > a.size
["wow", 99] ++ a; // concatenate the two arrays into a new one
a ++ \hi; // a symbol is a single character
a ++ 'hi'; // same as above
a ++ "hi"; // a string is a collection of characters
a.add(44); // creates new array with new element at the end
a.insert(5, "wow"); // insert string into position 5, return new array
a;
a.put(2, "oops"); // destructive, change the array
a.permute(3) // swap item at position 3 with the one at index 0, return new array
a.mirror; // make is it a palindrome
a.powerset; //return all possible combination of the array's elements
a.pop(); // remove last index, destructive
a.removeAt(0); // remove item at index, return removed value, destructive
// math
[1, 2, 3, 4, 5] + 10; // add to every element in the array
[1, 2, 3, 4, 5] * 10; // multiply every element in the array
([1, 2, 3, 4, 5]/7).round(0.01); // parenthesis for precedence
x = 11; y = 12;
[x,y, 9] * 100;


// ways to create collection with arrays
Array.series(size: 6, start:10, step:3); // [10, 13, 16, 19, 22, 25]
Array.geom(size: 10, start:1, grow:2); // [1, 2, 4, 8, 16, 32, 64, 128, 256, 512]
Array.series(size: 7, start:100, step:-7); // [100, 93, 86, 79, 72, 65, 58]
Array.geom(7,100,0.9); // [100, 90.0, 81.0, 72.9, 65.61, 59.049, 53.1441]
Array.fill(10, "same"); // fill an array with a value
Array.fill(10, rrand(1,100)); // fill an array with a random value
Array.fill(10, { rrand(1,100) }); // fill an array with random values
Array.fill(10,{ arg counter; counter * 10}); // essentially you pass a function that evaluate every time that a new item is added to the array, the argument is the counter.
Array.fill(10, {arg freq; freq+1 * 440});
a = Array.newClear(7);
a[2] = "wow";

30!4; //[30,30,30,30]
30.dup(4); // same as above

// two dots
(50..79); // create an array with starting value 50, ending with 79
(50, 53..79); // [50, 53, 56, 59, 62, 65, 68, 71, 74, 77]

// do apply a function to all elements of a collection
~myFreqs = Array.fill(10, {rrand(440, 880)});
~myFreqs.do({|item, count|("Item" ++ count ++ " is " ++ item ++ " Hz. Closest midinote is " ++ item.cpsmidi.round).postln});
~myFreqs.do({arg item; {SinOsc.ar(item, 0, 0.1)}.play});
