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
    #a jQuery event, proxyObject will only proxy just once, so this will
    #set up events for any subsequente bindings to the same data
    binder.proxyObject object, ignore,
        (object, property, value, options) ->
            $(event_hub).trigger "data-attribute-#{property}", [object, value]

    #grab at any bindable under this element
    $('[data-attribute]', element).each (i, bindable) ->
        ( ->
            target = $(bindable)
            property = target.attr 'data-attribute'
            #hold on to the source object as data, this is useful to know
            #which which object's attributes are being tracked
            target.data 'data-attribute', object
            if target.is 'input'
                #input elements bind into value
                setWith = 'val'
                target.on 'change', (evt) ->
                    object[property] = target.val()
                target.on 'keyup', (evt) ->
                    object[property] = target.val()
            else
                #otherwise we just replace the body text
                setWith = 'text'
            #common behavior, set the initial value and update the presentation
            #value on events coming off of the data object
            target[setWith] object[property]
            $(event_hub).on "data-attribute-#{property}", (evt, object, value) ->
                if target.data('data-attribute') is object
                    target[setWith] value
        )()
    element

$ = jQuery
###
jQuery plugin, this exports data binding
###
$.fn.extend
    binder: (data) ->
        self = $.fn.binder
        @each (i, el) ->
            databind $, data, el


