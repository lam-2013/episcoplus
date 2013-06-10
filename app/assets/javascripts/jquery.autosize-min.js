/*!
 jQuery Autosize v1.16.15
 (c) 2013 Jack Moore - jacklmoore.com
 updated: 2013-06-07
 license: http://www.opensource.org/licenses/mit-license.php
 */
(function (e) {
    var t, o = {className: "autosizejs", append: "", callback: !1, resizeDelay: 10}, i = "hidden", n = "border-box", s = "lineHeight", a = '<textarea tabindex="-1" style="position:absolute; top:-999px; left:0; right:auto; bottom:auto; border:0; -moz-box-sizing:content-box; -webkit-box-sizing:content-box; box-sizing:content-box; word-wrap:break-word; height:0 !important; min-height:0 !important; overflow:hidden; transition:none; -webkit-transition:none; -moz-transition:none;"/>', r = ["fontFamily", "fontSize", "fontWeight", "fontStyle", "letterSpacing", "textTransform", "wordSpacing", "textIndent"], l = "oninput", c = "onpropertychange", h = e(a).data("autosize", !0)[0];
    h.style.lineHeight = "99px", "99px" === e(h).css(s) && r.push(s), h.style.lineHeight = "", e.fn.autosize = function (s) {
        return s = e.extend({}, o, s || {}), h.parentNode !== document.body && e(document.body).append(h), this.each(function () {
            function o() {
                if (t = w, h.className = s.className, p = parseInt(f.css("maxHeight"), 10), e.each(r, function (e, t) {
                    h.style[t] = f.css(t)
                }), l in w) {
                    var o = w.style.width;
                    w.style.width = "0px", w.offsetWidth, w.style.width = o
                }
            }

            function a() {
                var e, n, a;
                t !== w && o(), h.value = w.value + s.append, h.style.overflowY = w.style.overflowY, a = parseInt(w.style.height, 10), h.style.width = Math.max(f.width(), 0) + "px", h.scrollTop = 0, h.scrollTop = 9e4, e = h.scrollTop, p && e > p ? (e = p, n = "scroll") : d > e && (e = d), e += b, w.style.overflowY = n || i, a !== e && (w.style.height = e + "px", z && s.callback.call(w, w))
            }

            var d, p, u, w = this, f = e(w), b = 0, z = e.isFunction(s.callback);
            if (!f.data("autosize")) {
                if ((f.css("box-sizing") === n || f.css("-moz-box-sizing") === n || f.css("-webkit-box-sizing") === n) && (b = f.outerHeight() - f.height()), d = Math.max(parseInt(f.css("minHeight"), 10) - b || 0, f.height()), u = "none" === f.css("resize") || "vertical" === f.css("resize") ? "none" : "horizontal", f.css({overflow: i, overflowY: i, wordWrap: "break-word", resize: u}).data("autosize", !0), c in w ? l in w ? w[l] = w.onkeyup = a : w[c] = function () {
                    "value" === event.propertyName && a()
                } : w[l] = a, s.resizeDelay !== !1) {
                    var x, y = e(w).width();
                    e(window).on("resize.autosize", function () {
                        clearTimeout(x), x = setTimeout(function () {
                            e(w).width() !== y && a()
                        }, parseInt(s.resizeDelay, 10))
                    })
                }
                f.on("autosize", a), a()
            }
        })
    }
})(window.jQuery || window.Zepto);