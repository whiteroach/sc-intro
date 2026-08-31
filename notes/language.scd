s.boot;
s.volume.gui;
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