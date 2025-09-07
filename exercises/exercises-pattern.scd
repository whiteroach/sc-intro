s.boot;
s.volume.gui;

~seq_one;
~seq_two;

~dur_t = Pgeom(start: 0.25, grow: 2, length: inf);


(
    ~seq_one = Pbind(
	    \note, Pseq([1,6,0], 2),
        \dur, ~dur_t,
    );
)

(
    ~seq_two = Pbind(
	    \note, Pseq([3,5,0], 2),
        \dur, ~dur_t,
    );
)

~seq_one.play;
// ---- fork ---
(
    {
	    ~seq_one.play;
	    10.wait; // the amount to wait before the next process
	    ~seq_two.play;
	    20.wait;
	    ~seq_one.play;
    }.fork;
)

// Ther is any way to evaluate the duration of a pattern before playing it? 


