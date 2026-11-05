s.boot;

// -----------------------UGens----------------------------
{
	SinOsc.ar(freq: MouseX.kr(300, 2500),mul: MouseY.kr(0,1))
}.play;

{SinOsc.ar}.plot;
{Saw.ar}.plot;
{Pulse.ar}.plot;

{
	Pulse.ar(freq: MouseX.kr(300, 2500),mul: MouseY.kr(0,1))
}.scope;

/*
.ar audio rate 44100 samples per second
.kr control rate 44100/64, 64 is the "control period"

two kinds of UGens:
 - Unipolar, 0 to 1
 - Bipolar, -1 to 1
*/

{SinOsc.kr(1).poll}.play;//poll take 10 n per sec
{LFPulse.kr(1).poll}.play;

{LFNoise0.ar(50).poll}.play;


// ----------------------- Notes conversion ----------------------------
// conversion freq to MIDI/ MIDI to freq
~freq = 69.midicps;
~midi = ~freq.cpsmidi;

// -----------------------Arguments----------------------------
// freq: frequency
// mul: multiplier, amplitude

// -----------------------Scaling ranges----------------------------
// Scaling converts a signal's raw output into a range that makes sense for the parameter you want to control.
{SinOsc.ar(freq: LFNoise0.kr(10).range(500, 1500), mul: 0.1)}.play;

{LFNoise0.kr(1).poll}.play;
{LFNoise0.kr(1).range(500, 1500).poll}.play; // range convert the random bipolar values to number that can be used in the frequency context.

{LFPulse.kr(1).poll}.play;

{SinOsc.ar(freq: LFPulse.kr(1).range(200,1000).poll, mul: 0.1)}.play;// since LFPulse produce only 0 and 1, range converts 0 to 200 and 1 to 1000

// scale with mul and add
//This:
{SinOsc.kr(1).range(100,200).poll}.play;
// Same as this:
{SinOsc.kr(1, mul:50, add: 150).poll}.play;
//This:
{LFPulse.kr(1).range(100, 200).poll}.play;
// Same as this:
{LFPulse.kr(1, mul:100, add:100).poll}.play;

// linlin, linexp, explin, expexp
// Convertion of linear to linear, linear to exponential, exponential to linear and exponential to exponential.
a = (1..7);
a.linlin(1, 7, 0, 127).round(1);
a.linexp(1,7,0.01,127).round(1); // don't use zero for an exponential range

// -----------------------Stopping individual synths----------------------------
a = { Saw.ar(LFNoise0.kr(8).range(1000, 2000), mul:0.2)}.play;
b = { Saw.ar(LFNoise0.kr(7).range(100, 1000), mul:0.2)}.play;
c = { Saw.ar(LFNoise0.kr(15).range(2000, 3000), mul:0.1)}.play;

a.free;
b.free;
c.free;



// -----------------------The set message----------------------------
(
x = {
	arg freq = 440, amp = 0.01;
	SinOsc.ar(freq, 0, amp)
}.play;
);

x.set(\freq, 778);
x.set(\amp, 0.5);
x.set(\freq, 920, \amp, 0.2);
x.free;



// ----------------------- AUDIO BUSSES ----------------------------
/*
- Cmd + M, opens the meter window, this shows the level of all inputs and outputs.
- Busses are numbered 0-127
- 0-7 are reserved for output
- 8-15 are reserved for input
- all the other are free to use
*/

({
	Out.ar(0, SinOsc.ar(440, 0, 0.1)) // send the sine to the right channel
}.play);


// use an audio buss for effects:
/*
Declare a synth consisting of a Band Pass Filter
In.ar, is the UGen we use to read from an audio bus, in this case 55.
Any sound we pass to bus 55 will pass trough the BPF
*/
(f = {
	Out.ar(0,BPF.ar(in: In.ar(55), freq:MouseY.kr(1000, 5000), rq: 0.1) )
}.play);

// noise synth -> bus 55 -> filter synth

({Out.ar(55, WhiteNoise.ar(0.5))}.play);
({Out.ar(0, Saw.ar(330, 0.2))}.play); // stays uneffected
// We add a filter to bus 0, but the filter reads from bus 55, at the same time we can send other sources to bus 0, but only sources coming from bus 55 will be effected by the filter.


// Visualize busses
({
	Out.ar(44, PinkNoise.ar(1, 0, 0.1))
}.play);
// Create a bus
~b = Bus.audio(s, 44);

// Visualize it
~b.scope;

// ----------------------- Microphone Input ----------------------------
// WARNING! Use headphones to avoid feedback
(
{SoundIn.ar(0)}.play;
);

//Stereo
(
{SoundIn.ar([0,1])}.play;
);

// Add reverb
(
{FreeVerb.ar(SoundIn.ar(0), mix:1, room:0.9)}.play;
);


// ----------------------- Multichannel Expansion ----------------------------
// We are sending the 440 saw to bus 0, and 570 to bus 1.
({
	Out.ar(0, Saw.ar(freq: [440, 570], mul: Line.kr(0, 0.6, 10)))
}.play;);

// 440 ramps to 0.5 in 1 second, while 570 reach the same amp in 10 seconds.
({
	Out.ar(0, Saw.ar(freq: [440, 570], mul: Line.kr(0, 0.5, [1,10])))
}.play;);


// ex:
(
a = {Out.ar(0, SinOsc.ar(freq:[800, 880], mul: LFPulse.ar([0.2,0.3], mul:0.2).scope))}.play;
);

a.free;



// -----------------------Bus Object--------------------------
(
    r = {Out.ar(0, FreeVerb.ar(In.ar(55,2), mix: 0.5, room: 0.9, mul: 0.4))}.play;
);

(
    a = {Out.ar(55, SinOsc.ar([800,880], mul: LFPulse.ar(2)))}.play;
);

a.free;
// Since it can get hard to track the busses that are in use, a more common way of dealing with busses is to use the Bus object. This object will allocate and choose available bus slots, and remember wich one are in use.

~myBus = Bus.audio(s, 2); // s -> server, the second argument is the number of channels/busses
// Turn on the reverb: read from my bus (source sound)
(
    r = {Out.ar(0, FreeVerb.ar(In.ar(~myBus, 2), mix: 0.5, room:0.9, mul:0.4))}.play;
);
// Feed the busy tone into ~myBus
(
    b = {Out.ar(~myBus, SinOsc.ar([400, 440], mul: LFPulse.ar(2)))}.play;
);

r.free;
b.free;


// ----------------------- Panning --------------------------
// pos, expect a value between -1/+1, when 0 is the middle
(
    p = {Pan2.ar(in: PinkNoise.ar, pos: SinOsc.kr(2), level: 0.1)}.play;
);

p.free;

(
    j = { LFNoise1.kr(1).poll}.play; 
);

j.free;

(
    FreqScope.new(400, 200, 0, server: s);
);

(
    x = {
        var lfn = LFNoise2.kr(1);
        var saw = Saw.ar(
            freq: 30,
            mul:LFPulse.kr(
                freq: LFNoise1.kr(1).range(1,10),
                width:0.1
            );
        );
        var bpf = BPF.ar(
            in: saw,
            freq: lfn.range(500, 2500),
            rq: 0.01,
            mul: 5,
        ).scope;
        Pan2.ar(bpf, pos: lfn);
    }.play;
);

x.free;

// answers:
// a) lfn modulates the frequencies in the band pass filter the values are the center frequency of the filter, and move the position of panning.
// b) Since the filter is really sharp,not much get out of it, no we need to push the volume.  
// c) mul: LFPulse, how many notes per seconds.


// ----------------------- Mix & Splay --------------------------
// Are used to generate complax sounds and then mix them down to mono or stereo
(
    a = {
        SinOsc.ar(
            freq:[100, 300, 500, 700, 900],
            mul: 0.1,
        )
    }.play;
);

a.free;

(
    b = {
        Mix(SinOsc.ar([100, 300, 500, 700, 900], mul: 0.1))
    }.play;
);

b.free;

// Splay, spread it evenly from left to right
(
    c = {
        Splay.ar(SinOsc.ar([100, 300, 500, 700, 900], mul: 0.1))
    }.play;
);

c.free;

(
    d = {
        arg fundamental = 110;
        var harmonics = [1, 2, 3, 4, 5, 6, 7, 8, 9];
        var snd = BPF.ar(
            in: Saw.ar(32, LFPulse.ar(harmonics, width: 0.1)),
            freq: harmonics * fundamental,
            rq: 0.01,
            mul: 20
        );
        Splay.ar(snd)
    }.play;
);

d.free;


// ----------------------- Play an audio file --------------------------
// Drag and drop a file and you get the path
~buf_one = Buffer.read(s, "/Users/admin/Desktop/electroacustic-samples/260730_0282.wav" );

// Playback
{PlayBuf.ar(1, ~buf_one)}.play;

// Get some info about the file
[~buf_one.bufnum, ~buf_one.numChannels, ~buf_one.path, ~buf_one.numFrames];

// Changing playback speed with 'rate'
{PlayBuf.ar(numChannels: 1, bufnum: ~buf_one, rate: 2, loop:1)}.play;
{PlayBuf.ar(numChannels: 1, bufnum: ~buf_one, rate: 0.5, loop:1)}.play; // half speed
{PlayBuf.ar(numChannels: 1, bufnum: ~buf_one, rate: Line.kr(0.5, 2, 10), loop:1)}.play; // sppeding up

// Changing direction
{PlayBuf.ar(numChannels: 1, bufnum: ~buf_one, rate: -1, loop:1)}.play; // reverse
{PlayBuf.ar(numChannels: 1, bufnum: ~buf_one, rate: -0.5, loop:1)}.play; // reverse and half speed


// ----------------------- doneAction --------------------------
// Every running Synth on the server is represented by node, s.plotTree can be used to visualize every running process
s.plotTree;

w = {SinOsc.ar(60.midicps, 0, 0.1)}.play;
x = {SinOsc.ar(64.midicps, 0, 0.1)}.play;
y = {SinOsc.ar(67.midicps, 0, 0.1)}.play;
z = {SinOsc.ar(71.midicps, 0, 0.1)}.play;

w.free;

x = {WhiteNoise.ar(Line.kr(0.2, 0, 2))}.play; // this process will hang on untill freed even after getting to 0 volume. THe server will simply continue calculating 0 and push on the server.
x.free;

//doneAction: 2, the synth will free itself as soon the job is done
{WhiteNoise.ar(Line.kr(0.2, 0, 2, doneAction: 2))}.play;



// ----------------------- ENVELOPES --------------------------
// Env is not the envelope itself but is a set of instruction to build one, generally you'll pass it to a EnvGen, or Env.perc.kr(2) <- kr make an UGen out of it, essentially converting it to a EnvGen.
// for more examples check Env help


// ----------------------- Percussive Envelope --------------------------
a = Env.perc; // all default args
b = Env.perc(0.5).plot; // attackTime 0.5
d = Env.perc(attackTime: 0.3, releaseTime: 2, level: 0.4).plot;
e = Env.perc(attackTime: 0.3, releaseTime: 2, level: 0.4, curve:0).plot; // curve:0 means straight line;

// this will not work the envelope need param at compile time. 
(
    g = {
        arg env;
        PinkNoise.ar(EnvGen(env, doneAction:2));
    }
);

x = g.play(args: [\env,Env.perc]);

// this is the way to go:
(
    h = {
        arg att = 0.01, rel = 1.0 ,lev = 1.0, cur = -4.0;
        ~env = Env.perc(att, rel, lev, cur).kr(2);
        PinkNoise.ar(~env);
    }
);

x = h.play(args:[\att, 0.5]);
x = h.play();


// ----------------------- Triangular Envelope --------------------------
// Only two parameter: duration and level
Env.triangle.plot;

{SinOsc.ar([ 440, 442], mul: Env.triangle.kr(2))}.play;
{SinOsc.ar([440,442]) * Env.triangle.kr(2)}.play; // multiplier can ba anywhere 

(
    {
        ~env = Env.triangle(3, 1).kr(2);
        SinOsc.ar([ 440, 442], mul: ~env)
    }.play;
);

// ----------------------- Line Envelope --------------------------
// attack, sustain release, level and curve can also be specifiedi
// curve: \welch is a curve line vs \lin tha is a straight line
Env.linen.plot;
Env.linen(attackTime: 0.5, sustainTime: 2, releaseTime:3, level: 1, curve: \welch ).plot;

(
    {
        ~env = Env.linen(attackTime: 0.7, sustainTime: 1, releaseTime: 2, level: 1, curve: \welch).kr(2);
        SinOsc.ar([ 440, 442], mul: ~env)
    }.play;
);




// ----------------------- Pairs Envelope --------------------------
// the first parameter is a multi-dimensional array
(
    {
        ~env = Env.pairs([[0,0], [0.4, 1], [1, 0.2], [1.1, 0.5], [2, 0]], \lin).kr(2);
        SinOsc.ar([ 440, 442], mul: ~env)
    }.play;
);
/* Read the array of pairs like this:
At time 0, be at level 0;
At time 0.4, be at level 1;
At time 1, be at level 0.2;
At time 1.1, be at level 0.. */


// ----------------------- Envelopes not only for amp --------------------------
(
    {
        ~freq_env = Env.pairs([[0, 100], [0.4, 1000], [0.9, 400], [1.1, 555], [2, 440], [2.5, 0]], \lin).kr(2);
        ~amp_env = Env.linen(attackTime: 0.1, sustainTime: 1, releaseTime: 1.5, level: 0.6, curve: \welch).kr(2);
        SinOsc.ar(~freq_env, mul: ~amp_env)
    }.play;
);


// ----------------------- ADSR Envelope --------------------------
// ----------------------- ASR ----------------------- 
// Play note ('press key')
//! sustain is the volume at witch the note is kept
//attackTime: 0.5 seconds, sustainLevel: 0.8, releaseTime: 3 seconds
(
    x = {
        arg gate = 1, freq = 440;
        ~env_amp = Env.asr(0.5,0.6,3).kr(doneAction:2, gate: gate);
        SinOsc.ar(freq: freq, mul: ~env_amp) ! 2; 
    }.play;
);

x.set(\gate, 0);

// ----------------------- ADSR ----------------------- 
{ LFNoise2.kr(12).poll }.play;

(
    d = {
        arg gate = 1;
        var snd, env, snd_src, spread, filter;
        env = Env.adsr(0.01, 0.4, 0.5, 2);
        snd_src = Saw.ar((32.1,32.2..33));
        spread = LFNoise2.kr(12).range(100, 1000);
        // filter = BPF.ar(snd_src, spread, 0.05, 10);
        snd = Splay.ar(snd_src, spread, 0.05, 10);
        // snd = Splay.ar(filter);
        Out.ar(0, snd * env.kr(doneAction:2, gate: gate));
    }.play;
)

d.release;


/* 
Attack: The time (in seconds) that it takes to go from zero (silence) to peak amplitude
Decay: The time (in seconds) that it takes to go down from peak amplitude to sustain
amplitude
Sustain: The amplitude (between 0 and 1) at which to hold the note (important: this has
nothing to do with time)
Release: The time (in seconds) that it takes to go from sustain level to zero (silence).
*/


// ----------------------- SynthDef and Synth --------------------------
// SynthDef is the definition of an instrument, the blueprint, while synth is the initialized instrument.
SynthDef("my_sine_one", {Out.ar(0, SinOsc.ar(770, 0, 0.1))}).add;

x = Synth("my_sine_one");
x.free;

(
    SynthDef("my_sine_two", {
        arg freq = 440, amp = 0.1;
        var env = Env.perc(level:amp).kr(2);
        var snd = SinOsc.ar(freq, 0, env);
        Out.ar(0,snd); // remember to always specify the bus as last step!
    }).add;
)


Synth("my_sine_two"); // default values
Synth("my_sine_two", [\freq, 770, \amp, 0.2]);
Synth("my_sine_two", [\freq, 415, \amp, 0.1]);
Synth("my_sine_two", [\freq, 346, \amp, 0.3]);
Synth("my_sine_two", [\freq, rrand(440, 880)]);

// page 64:
(
    SynthDef("complex_one", {
        arg freq = 60, amp = 0.1, gate = 1, release = 3;
        var chorus, source, filter_mod, env, snd;
// lag is an exponential filter, gradually change a value over a specified time
        chorus = Lag.kr(freq, 2) * LFNoise2.kr([0.4, 0.5, 0.7, 1, 2, 5, 10]).range(1,1.02);
        source = LFSaw.ar(chorus) * 0.5;
        filter_mod = SinOsc.kr(1/16).range(1,10); // 1 cicle every 16 seconds
        env = Env.asr(1, amp, release).kr(2, gate);
        snd = LPF.ar(in: source, freq: freq * filter_mod, mul: env);

        Out.ar(0, Splay.ar(snd))
    }).add;
)

// NodeTree
s.plotTree;

a = Array.fill(6, { Synth("complex_one", [\freq, rrand(40, 70).midicps, \amp, rrand(0.1,0.5)]) });

a[0].set(\gate, 0);
a[1].set(\gate, 0);
a[2].set(\gate, 0);
a[3].set(\gate, 0);
a[4].set(\gate, 0);
a[5].set(\gate, 0);

// a need to run.
SystemClock.sched(0, {a[5.rand].set(\freq, rrand(40, 70).midicps); rrand(3, 10)});

(
    SynthDef("complex_two", {
        arg freq = 60, amp = 0.1, gate = 1, release = 3;
        var chorus, source, filter_mod, env, snd;
        
        chorus = Lag.kr(freq, 2) * LFNoise2.kr([0.4, 0.5, 0.7, 1, 2, 5, 10]).range(1,1.02);
        source = LFSaw.ar(chorus) * 0.5;
        
        Out.ar(0, Splay.ar(source))
    }).add;
);

Synth("complex_two", [\freq, 70.midicps, \amp, 0.3]);

// ----------------------- Pbind can play SynthDef --------------------------
(
    Pbind(
        \instrument, "complex_one",
        \degree, Pwhite(-7,7),
        \dur, Prand([ 0.125,0.25], inf),
        \amp, Pwhite(0.5, 1),
        \release, 1
    ).play;
)

(
    Pbind(
        \instrument, "complex_one",
        \scale, Pstutter(8, Pseq([
            Scale.lydian,
            Scale.major,
            Scale.mixolydian,
            Scale.minor,
            Scale.phrygian
        ],
        inf
        )),
        \degree, Pseq([0,1,2,3,4,5,6,7], inf),
        \dur, 0.2,
        \amp, Pwhite(0.5, 1),
        \release, 4,
        \legato, 0.1
    ).play;
)

