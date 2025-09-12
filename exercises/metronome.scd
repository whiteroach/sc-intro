s.boot;
s.volume.gui;
 // ++ concatenate two arrays
~duration_sequence;
~clicks_sequence;

~swing_bar = [1/3, Rest(1/3), 1/3];
~swing_clicks = [700, 0, 500];

~triplets_bar =  [Pn(1/3, 3)];
~triplet_clicks = [700, 500, 500];
~metronome_tempo;
~rests = List[];

// -----------------------UTILS----------------------------

// Extract from an array of durations the index of rests.
// params bar_dur: an array of duration values.
// return a list of indexes related to the position of the rest in the given array.
~rest_selector = {
    | bar_dur |
    var rests = List[];
    bar_dur.do(
        {
            |dur, i|
                if(dur.isRest,
                    {
                        rests.add(i)
                    };
                );
        }
    );
    rests
};
// ~rest_selector.(~swing_bar);

// Given an array of durations, compiles an array of frequencies matching the length of the input
// params bar_dur: an array of duration values.
// returns an array of frequencies.
~frequency_feeder = {
	| item, list|
	var arr = Array.fill(item, {500});
	arr.put(0, 700);
	list.add(arr)
};

~handler = {
    | bar_dur |

	var freq_list = List[];
	var dur = List[];

	bar_dur.do({
		| item |
		var arr;
		case
		{ item.isKindOf(Pn) } {
			~frequency_feeder.(item.repeats, freq_list);
			dur.add(item);

		}
		{item[0].isKindOf(Pn)} {
			~frequency_feeder.(item[0].repeats, freq_list);
			dur.add(item[0]);
		}
        {
			~frequency_feeder.(item.size, freq_list);
			item.do(
				{
					| i |
					dur.add(i)
				}
			)
		};
	});

	[dur.asArray, freq_list.asArray]
};



//METRONOME
// percussive sound
(
SynthDef(\noiseSynth, { |out=0, freq=1000, rq=0.1, amp=0.1, dur=1|
    var noise = WhiteNoise.ar(amp);
    var filtered = BPF.ar(noise, freq, rq); // Band-pass filter
    var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
    Out.ar(out, filtered * env)
}).add;
)

g = [[Pn(1/3,3)], [1/8, Rest(1/8), 1/8, 1/8, 1/8,1/8, 1/8, 1/8], [1/3, Rest(1/3), 1/3], Pn(1/4,4)];
~metronome = {
	|dur_arr, tempo|
	var params = ~handler.(dur_arr);
	Pbind(
		\instrument, \noiseSynth,
		\dur, Pseq(params[0], inf),
		\freq, Pseq(params[1],inf),
		\amp, 0.4,
		\tempo, tempo,
	).play;
}


~metronome.(g, 60/60)



