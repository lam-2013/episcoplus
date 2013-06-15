/*
 This is a manifest file that'll be compiled into application.js, which will include all the files
 listed below.

 Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
 or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.

 It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
 the compiled file.

 WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
 GO AFTER THE REQUIRES BELOW.

 = require jquery
 = require jquery_ujs
 = require foundation
 = require json2
 = require history
 = require history_adapter_jquery
 = require ajax_pagination
 = require jquery.ui.datepicker
 = require jquery.ui.datepicker-it
 = require_tree .
 */


$(function () {

    var is_mobile = (/Android|webOS|iPhone|iPad|iPod|BlackBerry/i.test(navigator.userAgent));


    $(document).ready(function () {

        $(document).foundation();
        $('textarea').autosize();

        if (!is_mobile) {
            $('.datepicker').datepicker({
                showOn: "button",
                buttonImage: ('../assets/icon/calendar.png'),
                buttonImageOnly: true,
                slideDown: "slow"
            }).attr("type", "text");

        }

    });

});


