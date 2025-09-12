s.boot;
s.volume.gui;
~duration_sequence;
~clicks_sequence;

~swing_bar = [1/3, Rest(1/3), 1/3];
~swing_clicks = [700, 0, 500];

~triplets_bar =  [Pn(1/3, 3)];
~triplet_clicks = [700, 500, 500];
~metronome_tempo;
~rests = List[];

// function that returns the index of rests from an array
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
~func.value(~swing_bar);
~rests.postln;

~rest_selector.(~swing_bar);
~clicks_handler = {
    | bar_dur |
    var rests = ~rest_selector.(bar_dur);
    var freq_arr;
    if(rests.isEmpty, 
        {
            // if(bar_dur[0].isKindOf(Pn), {}, {})
            //bar_dur[0].repeats;
            p.repeats;
            freq_arr = Array.fill(p.repeats, {500});
            freq_arr.put(0, 700);
            // change the value of the first element
        }
    )
}
a = Pn(1/3, 3);
a = a.asStream.next;
a.postln;

if(~swing_bar.includes(Rest(1/3)){"yes".postln},{"no".postln});
// to check for rest need to use .isRest so I guess i need a loop 
x = ~swing_bar.do({|dur, i|if(dur.isRest,{~rests.add(i)}); };);
~rests.postln

//METRONOME
//todo:
// - Pbind in a function with params dur and time/bpm
// - find a way to deal with multiple time signature and the accent on the freq. (maybe strum)
// percussive sound 
(
SynthDef(\noiseSynth, { |out=0, freq=1000, rq=0.1, amp=0.1, dur=1|
    var noise = WhiteNoise.ar(amp);
    var filtered = BPF.ar(noise, freq, rq); // Band-pass filter
    var env = EnvGen.kr(Env.perc(0.01, dur), doneAction: 2);
    Out.ar(out, filtered * env)
}).add;
)

~duration_sequence = ~swing_bar ++ ~triplets_bar; // ++ concatenate two arrays
~clicks_sequence = [~swing_clicks, ~triplet_clicks]

(
Pbind(
    \instrument, \noiseSynth, 
    //\dur, Pseq([Pn(1/3, 3), Pn(1/4, 4)], inf), // for complex rhythm can pass here a Pseq
    \dur, Pseq([Pn(1/3, 3), Pn(1/4, 4)], inf), 
    \freq, Pseq([[700, 500, 500],[700, 500, 500, 500]],inf),
    //\rq, 0.2, // Resonance
    \amp, 0.4,
).play;
)

(
Pbind(
    \instrument, \noiseSynth, 
    \dur, Pseq(~swing_bar, inf), 
    \freq, Pseq(~swing_clicks, inf),
    \tempo, 120/60,
    \amp, 0.4,
).play;
)
