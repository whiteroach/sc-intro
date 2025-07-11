// boot the server
s.boot;

// open volume gui
s.volume.gui;

s.latency;
s.peakCPU

// logger
"Hell-O world".postln;

{ SinOsc.ar(400, 0, 0.1) }.play;

{ SinOsc.ar(200, 0, 0.1) }.play;

{ SinOsc.ar(LFNoise0.kr(10).range(500, 1500), mul:0.1) }.play;

// sweet sweet noise
{ LFNoise0.ar(500!2, 0.1)}.play;

{ RLPF.ar(Dust.ar([1, 15]), LFNoise1.ar([1, 2]).range(10, 3000), 0.02) }.play;

// watery random impulses, with fryng edges
{ Dust.ar([1,15]) }.play;

// evaluating a code block can be achieved by wrapping snippets in to parenthesis
(
"I almost blew up my hears".postln;
"Discovering the s.volume.gui was a good thing".postln;
)

// ctrl + shift + p clean the logs

// [[recording]]
s.record;
s.stopRecording
// GUI window with record button, volume control, mute button.
s.makeWindow
