###
@module binding

Provides declarative data binding from JavaScript objects to DOM elements.


@requires jQuery
###

###
@function

Given an object and a DOM element, bind them together.

Elements are marked with data-attribute='name', where name is property
of the target JavaScript object.

@param object {Object} data source object
@param element {Object} UI target DOM element
@returns this echoes back the DOM element to allow chaining
###


###
jQuery plugin
###
$ = jQuery
$.fn.extend
    binder: (options) ->
        console.log arguments
        self = $.fn.binder
        @each (i, el) ->
            console.log i, el, arguments
