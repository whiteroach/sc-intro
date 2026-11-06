s.boot;

// -----------------------Control Buses----------------------------
/* Control buses in SC are for routing control signal, they work in the same way as audio buses. Sc has 4096 control buses by default */
// Write a control sign to bus 55
{Out.kr(55, LFNoise0.kr(1))}.play;

// Read a control signal from bus 55
{In.kr(55).poll}.play;

// Using the Bus object
/* Buses become necessary the moment you need sharing, synchronization, or feedback across synth boundaries.
When you pass a UGen to a synth you create a copy of it, so it can become cumbersome when you use it in multiple instances. 
Also each copy is instantiated at a different moment in time, therefore the copies are not in sync.
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
// It is use to directly map a control bus to a running synth node, CANNOT be used inside a SynthDef
// Create a SynthDef
SynthDef("simple", { arg freq = 440; Out.ar(0, SinOsc.ar(freq, mul: 0.2))}).add;

//Create control buses 
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
// Create an audio bus
~fx_bus = Bus.audio(s, 1);
~master_bus = Bus.audio(s, 1);

// Create SynthDefs
(
    SynthDef("noise", {Out.ar(~fx_bus, WhiteNoise.ar(0.5))}).add;
    SynthDef("filter", {Out.ar(~master_bus, BPF.ar(in: In.ar(~fx_bus), freq: MouseY.kr(1000, 5000), rq: 0.1))}).add;
    SynthDef("master-out", {arg amp = 1; Out.ar(0, In.ar(~master_bus) * Lag.kr(amp, 1))}).add;
)
//Open Node Tree window
s.plotTree;
// Play Synths
m = Synth("master-out", addAction: 'addToTail'); // no matter how they are instantiated they will always keep the order
f = Synth("filter", addAction: 'addAfter');
n = Synth("noise", addAction: 'addToHead');

// Master volume
m.set(\amp, 0.1);

// ----------------------- Groups ----------------------------
// When you start to have a lot of synth, addAfter series does not scale well, so group may be a better solution.
// Keep watching the tree
s.plotTree;
// Create some buses
~reverb_bus = Bus.audio(s, 2);
~master_bus = Bus.audio(s, 2);

// Define groups
(
    ~sources = Group.new;
    ~effects = Group.new(~sources, \addAfter);
    ~master = Group.new(~effects, \addAfter);
)
// Run all Synths
(
    {
        Out.ar(~reverb_bus, SinOsc.ar([800, 890]* LFPulse.ar(2) * 0.1))
    }.play( target: ~sources ); // <- set it to sources group

    {
        Out.ar(~reverb_bus, WhiteNoise.ar(LFPulse.ar(2, 1/2, width: 0.05) * 0.1))
    }.play( target: ~sources );
    
    {
        Out.ar(~master_bus, FreeVerb.ar(In.ar(~reverb_bus, 2), mix: 0.5, room: 0.9))
    }.play( target: ~effects );

    {
        Out.ar(0, In.ar(~master_bus, 2) * MouseY.kr(0,1))
    }.play( target: ~master );

)
