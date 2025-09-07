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

// Play the Pbind
(
Pbind(
    \instrument, \noiseSynth,
    //\dur, Pseq([0.2, 0.7, 0.1, 0.1, 0.1, 0.1], inf), 
    \dur, 1/3, // for complex rhythm can pass here a Pseq
    \freq, Pseq([700,500,500], inf),
    //\rq, 0.2, // Resonance
    \amp, 0.4,
).play;
)
