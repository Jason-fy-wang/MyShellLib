var CURRENT_URL = window.location.href.split("#")[0].split("?")[0],
    $BODY = $("body"),
    $MENU_TOGGLE = $("#menu_toggle"),
    $SIDEBAR_MENU = $("#sidebar-menu"),
    $SIDEBAR_FOOTER = $(".sidebar-footer"),
    $LEFT_COL = $(".left_col"),
    $RIGHT_COL = $(".right_col");

console.log("location.href=" + window.location.href)
console.log("current_url " + CURRENT_URL)
var gentelella = window.gentelella || {
    initSidebar: function() {
        var a = function() {
            $RIGHT_COL.css("min-height", $(window).height());
            var a = $BODY.outerHeight(),
                b = $BODY.hasClass("footer_fixed") ? -10 : $SIDEBAR_FOOTER.height(),
                c = $LEFT_COL.eq(1).height() + $SIDEBAR_FOOTER.height(),
                d = a < c ? c : a;
            // d -= $NAV_MENU.height() + b,
            $RIGHT_COL.css("min-height", d);
        };
        // $("ul:first",c)) 此限制了查找的范围
        $SIDEBAR_MENU.find("a").on("click", function(b) {
            var c = $(this).parent();
            // 如果当前是激活状态,那么就隐藏起来
            c.is(".active") ? (c.removeClass("active active-sm"), $("ul:first", c).slideUp(function() {
                    a()
                        // 不是激活状态的操作
                        // 如果是child_menu 且 是nav-sm,则隐藏
                        // 如果不是child_menu,则对应的字列表展开
                })) : (c.parent().is(".child_menu") ? $BODY.is(".nav-sm") && ($SIDEBAR_MENU.find("li")
                    .removeClass("active active-sm"), $SIDEBAR_MENU.find("li ul").slideUp()) : ($SIDEBAR_MENU.find("li").removeClass("active active-sm"), $SIDEBAR_MENU.find("li ul").slideUp()), c.addClass("active"), $("ul:first", c).slideDown(function() {
                    a()
                })),
                $SIDEBAR_MENU.find('a[href="' + CURRENT_URL + '"]').parent("li").addClass("currnet-page"),
                $SIDEBAR_MENU.find("a").filter(function() {
                    return this.href == CURRENT_URL
                }).parent("li").addClass("current-page").parents("ul").slideDown(function() {
                    a()
                }).parent().addClass("active"),
                $MENU_TOGGLE.on("click", function() {
                    console.log("toggle log")
                    $BODY.hasClass("nav-md") ? ($SIDEBAR_MENU.find("li.active ul").hide(),
                            $SIDEBAR_MENU.find("li.active").addClass("active-sm").removeClass("active")) :
                        ($SIDEBAR_MENU.find("li.active-sm ul").show(),
                            $SIDEBAR_MENU.find("li.active-sm").addClass("active").removeClass("active-sm"),
                            $BODY.toggleClass("nav-md nav-sm"), a(),
                            $(".dataTable").each(function() {
                                $(this).dataTable().fnDraw();
                            }))
                }),
                // $(window).smartresize(function() {
                //     a()
                // }), 
                a(),
                $.fn.mCustomScrollbar && $(".menu_fixed").mCustomScrollbar({
                    autoHideScrollbar: !0,
                    //theme: "minimal",
                    theme: "dark",
                    moudseWheel: {
                        preventDefault: !0
                    }
                })
        })
    }
}

$(document).ready(function() {
    gentelella.initSidebar()
})