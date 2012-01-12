(function() {
	var toggleInit = function() {
	    var hide = function() {
			if( YAHOO.util.Dom.hasClass( 'orbeon-xforms-inspector', 'debug-show' ) ) {
				YAHOO.util.Dom.removeClass( 'orbeon-xforms-inspector', 'debug-show' );
			} else {
				YAHOO.util.Dom.addClass( 'orbeon-xforms-inspector', 'debug-show' );
			}
	    };
	    YAHOO.util.Event.on('toggle_debug', 'click', hide);
	};
	
	YAHOO.util.Event.onDOMReady(toggleInit);
})();