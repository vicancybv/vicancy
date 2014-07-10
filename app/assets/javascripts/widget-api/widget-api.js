(function () {
    var Vicancy = {
        open: function (client_id, client_name, client_email, reseller_token) {
            //alert('vicancy start');
            window.vicancy.createDiv();
        },
        createDiv: function () {
            var d = document.createElement("div");
            d.id = "com-vicancy-widget-overlay";
            d.style.cssText = 'position: absolute; left: 0px; top: 0px; width:100%; height:100%; text-align:center; z-index: 1000; background-color: gray; background-color: rgba(0,0,0,0.3); z-index: 1000;'
            d.onclick = function () {
                var overlay = document.getElementById('com-vicancy-widget-overlay');
                document.body.removeChild(overlay);
            }
            var dd = document.createElement("div");
            dd.width = 820;
            dd.height = 520;
            dd.style.cssText = 'background-color: white; border: 1px solid gray; position: fixed; left: 50%; top: 50%; margin-left: -410px; margin-top: -260px; '+
                '-webkit-box-shadow: 0px 0px 20px 0px rgba(50, 50, 50, 0.75); -moz-box-shadow: 0px 0px 20px 0px rgba(50, 50, 50, 0.75); box-shadow: 0px 0px 20px 0px rgba(50, 50, 50, 0.75);';
            d.appendChild(dd);
            var f = document.createElement("iframe");
            f.src = '/widget';
            f.frameBorder = 0;
            f.marginHeight = 0;
            f.marginWidth = 0;
            f.width = 820;
            f.height = 520;
            dd.appendChild(f);
            document.body.appendChild(d);
        }
    };
    if (!window.vicancy) window.vicancy = Vicancy;
})();


