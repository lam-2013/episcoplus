/**
 * Created with JetBrains RubyMine.
 * User: Mari
 * Date: 22/06/13
 * Time: 15.04
 * To change this template use File | Settings | File Templates.
 */

$.fn.audioplayer = function () {
    $(this).each(function () {
        var $playerCont = $(this);

        var $audio = $("audio", $playerCont);
        var audio = $audio[0]; //per usare i metodi js puri

        var position = $(".audio_play-progress", $playerCont);
        var progressSlider = $(".audio_seek-handle", $playerCont);
        var progressBar = $(".audio_progress-holder", $playerCont);
        //fattore correttivo per il cammino dello slider in percentuale
        var sliderCorrection = (100 * 5 / progressBar.width());

        var curTime = $(".audio_current-time-display", $playerCont);
        var duration = $(".audio_duration-display", $playerCont);

        var vol = $(".audio_volume-level", $playerCont);
        var play = $(".audio_play_control", $playerCont);
        var mute = $(".audio_mute-control", $playerCont);
        var volumeSlider = $(".audio_volume-handle", $playerCont);
        var volumeBar = $(".audio_volume-bar", $playerCont);

        var loadBar = $(".audio_load-progress", $playerCont);

        $audio.on("loadedmetadata", init);
        function init(evt) {
            duration.html(toTime(audio.duration));

            progressBar.click(function (e) {
                sliderChange(progressSlider, progressBar, e, goToTime);
            });

            progressSlider.mousedown(function (e) {
                e.originalEvent.preventDefault();
                if (!$(this).hasClass('disabled')) {
                    startMove(progressSlider, progressBar, goToTime);
                }
            });
        }

        $audio.on("progress", updateBuffered);
        function updateBuffered() {
            var start = audio.buffered.start(0);
            var end = audio.buffered.end(0);

            var delta = end - start;

            var startPercent = start * 100 / audio.duration;
            var deltaPercent = delta * 100 / audio.duration;

            loadBar.css('left', startPercent + '%').width(deltaPercent + '%');
        }


        $audio.on("timeupdate", curTimeUpdate);
        function curTimeUpdate(evt) {
            curTime.html(toTime(audio.currentTime));

            var progress = 100 * audio.currentTime / audio.duration
            position.width(progress + '%');
            if (progress > sliderCorrection) {
                progressSlider.css('left', (progress - sliderCorrection) + '%');
            }
        }

        $audio.on("volumechange", dispVol);
        function dispVol(evt) {
            var new_volume = audio.muted ? 0 : audio.volume;

            vol.width((new_volume * 100) + '%');
            volumeSlider.css('left', (new_volume * 100) + '%');

            var part;
            if (new_volume == 0) {
                part = 0
            } else if (new_volume <= 1 / 3) {
                part = 1
            } else if (new_volume <= 2 / 3) {
                part = 2
            } else {
                part = 3
            }

            mute.removeAttr('class').addClass("audio_mute-control")
                .addClass("audio_control").addClass("audio_vol-" + part);
        }

        play.click(togglePlay);
        function togglePlay(evt) {
            if (audio.paused == false) {
                audio.pause();
                $playerCont.removeClass("audio_playing");
            } else {
                audio.play();
                $playerCont.addClass("audio_playing");
            }
        }

        mute.click(toggleMute);
        function toggleMute(evt) {
            audio.muted = !audio.muted;
            volumeSlider.toggleClass('disabled');
            dispVol(mute);
        }

        volumeBar.click(function (e) {
            sliderChange(volumeSlider, volumeBar, e, changeVolume);
        });

        volumeSlider.mousedown(function (e) {
            e.originalEvent.preventDefault();
            if (!$(this).hasClass('disabled')) {
                startMove(volumeSlider, volumeBar, changeVolume);
            }
        });


        function startMove(slider, line, callback) {
            $(document).on('mousemove.slider', function (e) {
                sliderChange(slider, line, e, callback);
            });

            $(document).mouseup(function () {
                stopMove(line);
            });

        }

        function sliderChange(slider, line, e, callback) {
            var delta = e.clientX - line.offset().left;

            if (delta <= 0) {
                slider.css("left", '0');
            } else if (delta >= line.width()) {
                slider.css("left", line.width() + 'px');
            } else {
                slider.css("left", delta + 'px');
            }

            callback(delta / line.width());
        }

        function stopMove(slider) {
            $(document).off('mousemove.slider');
        }

        function changeVolume(changeTo) {
            if (audio.muted) {
                toggleMute();
            }
            if (changeTo > 1.0) {
                changeTo = 1.0;
            } else if (changeTo < 0.0) {
                changeTo = 0.0;
            }
            audio.volume = changeTo;
        }

        function goToTime(timeTo) {
            if (timeTo > 1.0) {
                timeTo = 1.0;
            } else if (timeTo < 0.0) {
                timeTo = 0.0;
            }

            audio.currentTime = audio.duration * timeTo;
        }

        function toTime(float) {
            int = float.toFixed();
            seconds = Math.floor(int % 60);
            minutes = Math.floor(int / 60);

            if (seconds < 10) {
                seconds = '0' + seconds
            }
            if (minutes < 10) {
                minutes = '0' + minutes
            }
            return minutes + ":" + seconds;
        }
    });
}