// [[Patterns]]
s.boot;
s.volume.gui;

Pbind(\degree, Pseries(0, 1, 30), \dur, 0.05).play;

// -----------Pbind---------------
// Plays C ones every second:
// - 0 is middle C (C4)
// - accesing notes above (1(D), 2, 3..)
// - notes below (-1(B), -2, -3)
x = Pbind(\degree, 0, \dur, 0.5);
x.play;

// --Pseq
// Plays this sequence once
Pbind(\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 2), \dur, 0.2).play;

// Plays the sequence 5 times and apply an array of duration values that get applied in a loop till there are tones to play in the seuence of tones
(
    Pbind(
        \degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], 5),
        \dur, Pseq([1, 0.5, 1, 0.5, 2, 4], inf)
    ).play;
)

// Pbind accept for ways of specifyng pitches
// 1. \note: 0 = C4, 1 = C4#
// 2. \midinote: 60 = C4, 61 = C4#
// 3. \freq: 261.6 = C4
// 4. \degree: 0 = C4, 1 = D4

// Durations are in beats
// Amplitude between 0 - 1
// Legato 0.1 - 1

(
    Pbind(
        \degree, Pseq([0, -1, 2, -3, 4, -3, 7, 11, 4, 2, 0, -3], 5),
        \dur, Pseq([0.2, 0.1, 0.1], inf),
        \amp, Pseq([0.7, 0.5, 0.3, 02], inf),
        \legato, 0.4
    ).play;
)

// key of B, C#, D# = 3, E= 4, F# = 6, G#,A#
// 2nd - 5th - 1st and 1st again.
(
    Pbind(
        \note, Pseq([1, 6, -1, 1], 4),
        \dur, Pseq([0.25], inf),
        \amp, Pseq([0.7, 03, 0.7, 0.3], inf),
        \legato, 0.7
    ).play;
)

// passing O as amp create in this case a break of full beat
(
    Pbind(
        \note, Pseq([1, 1, 1, 1 ], 1),
        \dur, Pseq([0.25, 1, 0.25, 0.25], inf),
        \amp, Pseq([0.7, 0, 0.7, 0.3], inf),
        \legato, 0.7
    ).play;
)

// -----------Prand---------------
//Picks a random item from the list
(
    Pbind(
        \note, Prand([1, 6, -1, 1], inf),
        \dur, Prand([0, 0.25, 1], inf),
        \amp, Prand([0.2, 0.4, 0.6], inf),
        \legato, Prand([0.2, 1, 0.5], inf),
    ).trace.play
)

// Trace logs the parameter selected by Prand

// -----------Pwhite---------------
(
    Pbind(
        \freq, Pwhite(100, 500),
        \dur, Prand([0.15, 0.25, 0.3],inf),
        \amp, 0.2,
        \legato, 0.3,
    ).trace.play;
)

// page 22

// Drone
// cannot set a noisegenerator for amplitude
(
    Pbind(
        \note, Prand([2, 6, -1, 1], inf),
        \dur, 10,
        //\amp, Prand([0.2, 0.4, 0.8], inf),
        \amp, 0.6,
        \legato, 1,
    ).play;
)
// cooler Drone
(
    Pbind(
        \freq, Pwhite(100, 500),
        \dur, 10,
        \amp, 0.2,
        \legato, 1.5,
    ).trace.play;
)

// -----------Pser---------------
// works similarly to Pser but insteadof full circles you can specify the number of items returned.
// 0 - 2 - 3 - 5 - 7 - 8 - 11 - 12 - 0 - 2 - 3
(
    Pbind(
        \note, Pser([0, 2, 3, 5, 7, 8, 11, 12], 11),
        \dur, 0.15;
    ).trace.play;
)



// -----------Pxrand---------------
// like Prand but never repeat the same value in a sequence
(
    Pbind(
        \note, Pxrand([0, 2, 3, 5, 7, 8, 11, 12], inf),
        \dur, 0.15,
    ).trace.play;
)


// -----------Pshuf---------------
// shufle a list and repeat it for a given amount of times
(
    Pbind(
        \note, Pshuf([0, 2, 3, 5, 7, 8, 11, 12], 6),
        \dur, 0.15,
    ).trace.play;
)


// -----------Pslide---------------
// list, repeats, length, step - how far to step from previous segment
(
    Pbind(
        \note, Pslide([0, 2, 3, 5, 7, 8, 11, 12], 7, 3, 1),
        \dur, 0.15,
    ).trace.play;
)

// -----------Pgeom---------------
// Takes three arguments: starts, grow, length
// Grow incrementaly
(
    Pbind(
	    \note, Pseq([0, 2, 3, 5, 7, 8, 11, 12], inf),
	    \dur, Pgeom(0.1, 1.1, 25),
    ).trace.play;
)

// -----------Pn---------------
// Pattern a Number of times
// repeats a given value: pattern, repeat, key
// pattern can be any pattarn, Pshuf, Pseq ...
(
    Pbind(
    	\note, Pseq([0, Pn(2, 3), 3, Pn(5, 3), 7, Pn(8, 3), 11, 12], 1),
	    \dur, 0.15,
    ).trace.play;
)


// -----------Chords---------------
(
    Pbind(
	    \note, Pseq([[0,3,7], [2,5,8], [3,7,0], [5,8,12]], 3),
	    \dur, 0.15
    ).play;
)
// strumming
(
    Pbind(
	    \note, Pseq([[-7, 3, 7, 10], [0, 3, 5, 8]], 3),
	    \dur, 1,
	    \legato, 0.7,
	    \strum, 0.1, // more is arpeggio
    ).play;
)


// -----------Scales---------------
Scale.directory; 

m = Scale.minor; 
j = Scale.major;

j.degrees; // -> [ 0, 2, 4, 5, 7, 9, 11 ]

m.degrees; // -> [ 0, 2, 3, 5, 7, 8, 10 ]


// works only with degrees!
h = Scale.hungarianMinor;

h.size;

h.degrees; // the degrees are in this case the 12 notes.
// \degree refers to the degrees of the scale, but h.degrees returns the indexes of the notes that compose the scale. 
// -> [ 0, 2, 3, 6, 7, 8, 11 ] 

// It is possible to access a chromatic note between degrees by using decimal => 3.1
(
    f = Pbind(
            \scale, h,
            \degree, Pxrand([0, 3, 8, 6, 7, 11], 10),
            \root, -3, // A
            \dur, 10,
            \legato, 1,
        ).trace
)

f.play;


// f.['degree'].postln;



