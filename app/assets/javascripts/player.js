/**
 * Created with JetBrains RubyMine.
 * User: Mari
 * Date: 22/06/13
 * Time: 15.04
 * To change this template use File | Settings | File Templates.
 */

audio = $("audio");
position  = $("position");
curTime   = $("curTime");
duration  = $("duration");
volume    = $("volume");
vol       = $("vol");
play      = $("play");
stop      = $("stop");
louder    = $("louder");
quieter   = $("quieter");
mute      = $("mute");



audio.addEventListener("loadedmetadata", init, false);
function init(evt) {
    duration.innerHTML = audio.duration.toFixed(2);
    vol.innerHTML      = audio.volume.toFixed(2);
}

audio.addEventListener("timeupdate", curTimeUpdate, false);
function curTimeUpdate(evt) {
    curTime.innerHTML = audio.currentTime.toFixed(2);
    position.style.width = 300*audio.currentTime/audio.duration + "px";
}

audio.addEventListener("volumechange", dispVol, false);
function dispVol(evt) {
    vol.innerHTML = audio.volume.toFixed(2);
}

play.onclick(togglePlay, false);
function togglePlay(evt) {
    if (audio.paused == false) {
        audio.pause();
        play.style.backgroundPosition = "0 0";
    } else {
        audio.play();
        play.style.backgroundPosition = "0 -151px";
    }
}


stop.onclick(restart, false);
function restart(evt) {
    audio.pause();
    play.style.backgroundPosition = "0 0";
    audio.currentTime = 0;
}

louder.onclick(volInc, false);
function volInc(evt) {
    changeVolume(audio.volume+0.1);
}

quieter.onclick(volDec, false);
function volDec(evt) {
    changeVolume(audio.volume-0.1);
}

mute.onclick(toggleMute, false);
function toggleMute(evt) {
    audio.muted = !audio.muted;
    if (audio.muted) {
        volume.className = 'disabled';
    } else {
        volume.className = '';
    }
}

function changeVolume(changeTo) {
    if(audio.muted){
        toggleMute();
    }
    if(changeTo > 1.0) {
        changeTo = 1.0;
    } else if (changeTo < 0.0) {
        changeTo = 0.0;
    }
    volume.style.height = 225*changeTo +'px';
    volume.style.marginTop = 225-(225*changeTo) + 'px';
    audio.volume = changeTo;
}