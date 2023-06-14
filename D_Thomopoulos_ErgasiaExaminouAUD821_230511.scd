// ΔΗΜΗΤΡΗΣ ΘΩΜΟΠΟΥΛΟΣ- TX2020044
// Αλγοριθμική Σύνθεση & Δόμηση του Ήχου - Τελική εργαία (Ιούνιος 2023)

// Όνομα μουσικής σύνθεσης: 'INSOMNIA'

s.boot;

// Synth definitions
(
SynthDef(\mySynth, {
    arg freq = 440, amp = 0.3;
    var env, osc;
    env = EnvGen.ar(Env.perc(0.001, 0.3, 0.2), doneAction: 2);
    osc = SinOsc.ar(freq) * amp * env;
    Out.ar([0, 1], [osc, osc]);
}).add;

SynthDef(\kick, {
    arg amp = 0.5;
    var env, osc;
    env = EnvGen.ar(Env.perc(0.01, 0.2, 0.2), doneAction: 2);
    osc = SinOsc.ar(60, 0, env);
    Out.ar([0, 1], [osc * amp, osc * amp]);
}).add;

SynthDef(\snare, {
    arg amp = 0.3;
    var noise, env, snare;
    noise = WhiteNoise.ar(0.2); // Noise component
    env = EnvGen.ar(Env.perc(0.01, 0.2, 0.2), doneAction: 2);
    snare = noise + BPF.ar(noise, 6000, 0.2); // Snare sound
    Out.ar([0, 1], [snare * amp * env, snare * amp * env]);
}).add;

SynthDef(\hihat, {
    arg amp = 0.01;
    var env, hihat;
    env = EnvGen.ar(Env.perc(0.01, 0.1, 0.2), doneAction: 2);
    hihat = WhiteNoise.ar(0.3) * LPF.ar(WhiteNoise.ar(4000), 10000); // Hi-hat sound
    Out.ar([0, 1], [hihat * amp * env, hihat * amp * env]);
}).add;

SynthDef(\clap, {
    arg amp = 0.3;
    var noise, env, clap;
    noise = WhiteNoise.ar(0.5); // Noise component
    env = EnvGen.ar(Env.perc(0.01, 0.2, 0.2), doneAction: 2);
    clap = noise + AllpassN.ar(noise, 0.05, [0.05, 0.04], 1); // Clap sound
    Out.ar([0, 1], [clap * amp * env, clap * amp * env]);
}).add;

(
SynthDef(\deepHouseBass, {
    |out = 0, freq = 55, decay = 2, amp = 0.5|
    var sig, env;

    sig = Decay2.ar(Impulse.ar(0), 0.01, decay, SinOsc.ar(freq) * amp);
    env = EnvGen.ar(Env.perc(0.01, decay), doneAction: 2);

    Out.ar(out, sig * env);
}).add;
)
)


// Set the global tempo to 128 BPM
TempoClock.default.tempo = 128/60;

// Define the duration in beats for 8 bars
var eightBars = 8 * 4;

~shakers = Buffer.read(s, thisProcess.nowExecutingPath.dirname+/+"/samples/shaker.wav");

// Play the kick and melody immediately
(
Pbind(
    \instrument, \kick,
    \dur, 1,
    \amp, 1.5,
    \legato, 0.9,
    \group, 1,
    \midinote, Pseq([36, 36, 36, 36, 38, 38, 36, 36, 36, 36, 38, 38, 36, 36, 36, 36], inf),
).play;

Pbind(
    \instrument, \mySynth,
    \degree, Pseq([9, 4, 0, 2, 5, 9, 10, 5], inf),
	\dur, Pseq([0, 0.75, 0.5, 0.5, 1, 0.25, 0.5 ,0.5], inf),
    \legato, 0.9,
    \amp, 0.9,
).play;



Pbind(
    \instrument, \deepHouseBass,
    \freq, Pseq([55, 41, 49, 37], inf),  // Low notes
    \decay, 6,  // Bigger decay
    \dur, 4,
    \amp, 4,
).play;
)

// Play the deep house bass



// Play the drums and bass after 8 bars
(
Pbind(
    \instrument, \hihat,
    \dur, 1,
    \amp, 0.0005,
    \legato, 0.9,
    \group, 1,
    \midinote, Pseq([36, 36, 36, 36, 38, 38, 36, 36, 36, 36, 38, 38, 36, 36, 36, 36], inf),
).play;

Pbind(
    \instrument, \snare,
    \dur, 1,
    \amp, 0.9,
    \group, 1,
    \midinote, Pseq([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], inf),
    \legato, 0.9,
).play;


Pbind(
    \instrument, \clap,
    \dur, 1,
    \amp, 0.9,
    \group, 1,
    \midinote, Pseq([1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], inf),
).play;
)