s.boot;

// -----------------------Control Busses----------------------------
/* Control busses in SC are for routing control signal, they work in the same way as audio busses. Sc has 4096 control busses by default */
// Write a control sign to bus 55
{Out.kr(55, LFNoise0.kr(1))}.play;

// Read a control signal from bus 55
{In.kr(55).poll}.play;

// Using the Bus object
/* Buses become necessary the moment you need sharing, synchronization, or feedback across synth boundaries.
When you pass a UGen to a synth you create a copy of it, so it can become cumbersome when you use it in multiple instances. 
Also each copies is instantiated at a different moment in time, therefore the copies ar not in sync
*/
~my_control_bus = Bus.control(s, 1);
{Out.kr(~my_control_bus, LFNoise0.kr(5).range(440, 880))}.play;
{SinOsc.ar(freq: In.kr(~my_control_bus))}.play;


~my_freq = {LFNoise0.kr(5).range(440, 880)};
{SinOsc.ar(freq: ~my_freq)}.play;

// Create the control bus
~my_control = Bus.control(s, 1);

// Feed the control signal into the bus
c = {Out.kr(~my_control, Pulse.kr(freq: MouseX.kr(1,10), mul: MouseY.kr(0,1)))}.play;

//Play
(
    {
        Blip.ar(
            freq: LFNoise0.kr([1/2, 1/3]).range(50,60),
            numharm: In.kr(~my_control).range(1,10),
            mul: LFTri.kr([1/4, 1/6]).range(0, 0.1)
        )
    }.play;
    {
        Splay.ar(
            Pulse.ar(
                freq: LFNoise0.kr(
                    [1.4, 1, 1/2, 1/3]
                ).range(100, 1000) * In.kr(~my_control).range(0.9, 1.1),
                mul: SinOsc.ar([1/3, 1/2, 1/4, 1/8]).range(0, 0.3)
            )
        )
    }.play;
)

c.free;

// ----------------------- asMap ----------------------------
// Is use to directly map a control bus to a running synth node, CANNOT be used inside a SynthDef
// Create a SynthDef
SynthDef("simple", { arg freq = 440; Out.ar(0, SinOsc.ar(freq, mul: 0.2))}).add;

//Create control busses 
~one_bus = Bus.control(s,1);
~another_bus = Bus.control(s,1);

//Start controls
{Out.kr(~one_bus, LFSaw.kr(1).range(100, 1000))}.play;
{Out.kr(~another_bus, LFSaw.kr(2, mul: -1).range(500, 2000))}.play;

// Start a note 
x = Synth("simple", [\freq, 800]);
x.set(\freq, ~one_bus.asMap);
x.set(\freq, ~another_bus.asMap);
x.free;

// ----------------------- Order of execution ----------------------------

