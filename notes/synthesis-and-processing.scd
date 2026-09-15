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
)

x.set(\freq, 778);
x.set(\amp, 0.5);
x.set(\freq, 920, \amp, 0.2);
x.free;



// ----------------------- Audio Busses----------------------------
/*
- Cmd + M, opens the meter window, this shows the level of all inputs and outputs.
- Busses are numbered 0-127
- 0-7 are reserved for output
- 8-15 are reserved for input
- all the other are free to use
*/

({
	Out.ar(1, SinOsc.ar(440, 0, 0.1)) // send the sine to the right channel
}.play)
