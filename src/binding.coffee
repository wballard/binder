###
@module binding

Provides declarative data binding from JavaScript objects to DOM elements.


@requires jQuery
###

###
@function

Ignore event handler, avoids making functions for each property
###
ignore = ->


event_hub = {}
###
@function

Given an object and a DOM element, bind them together.

Elements are marked with data-attribute='name', where name is property
of the target JavaScript object.

@param $ {Object} jQuery reference
@param object {Object} data source object
@param element {Object} UI target DOM element
@returns this echoes back the DOM element to allow chaining
###
databind = ($, object, element) ->

    #hook up a proxy to the object that translates the callback to
    #a jQuery event
    binder.proxyObject object, ignore,
        (object, property, value, options) ->
            $(event_hub).trigger "data-attribute-#{property}", [object, value]



    target = $(element)
    if target.is 'input'
        #input elements work a bit differently
        console.log element
    else
        #otherwise we just replace the body
        property = target.attr 'data-attribute'
        target.text object[property]
        #hold on to the source object as data, this is useful to know
        #which which object's attributes are being tracked
        target.data 'data-attribute', object
        $(event_hub).on "data-attribute-#{property}", (evt, object, value) ->
            console.log arguments
            if target.data('data-attribute') is object
                console.log value
                target.text value

$ = jQuery
###
jQuery plugin, this exports data binding
###
$.fn.extend
    binder: (data) ->
        self = $.fn.binder
        @each (i, el) ->
            databind $, data, el


