###
@module binding
@requires jQuery

Provides declarative data binding from JavaScript objects to DOM elements.
###

###
@private

Ignore event handler, avoids making functions for each property
###
ignore = ->

###
@private

This sets up a relay point to allow subscribe/unsubscribe functionality
so that we can unhook data binding without unhooking other folks event
handlers.

This is a pub/sub setup rather than an event bubbling setup.

###
event_hub =

    properties: {}

    subscribe: (target, property) ->
        @properties[property] = @properties[property] or []
        if @properties[property].length is 0
            #hook up the event relay when we get our very first one
            $(event_hub).on "data-attribute-#{property}", (evt, object, value) ->
                for relay in @properties[property]
                    relay.trigger "data-attribute-#{property}.binder",
                        [object, value]
        @properties[property].push target

    unsubscribe: (target, property) ->
        @properties[property] = (@properties[property] or []).filter (x) ->
            not(x.is target)

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
    $('[data-attribute]', $(element)).each (i, bindable) ->
        ( ->
            target = $(bindable)
            property = target.data 'attribute'
            #hold on to the source object as data, this is useful to know
            #which which object's attributes are being tracked
            target.data 'boundto.binder', object
            if target.is 'input'
                #input elements bind into value
                setWith = 'val'
                #input elements can change
                target.on 'change.binder keyup.binder keydown.binder mouseup.binder', (evt) ->
                    object[property] = target.val()
            else
                #otherwise we just replace the body text
                setWith = 'text'
            event_hub.subscribe target, property
            target.on "data-attribute-#{property}.binder", (evt, object, value) ->
                #data events are coming off by name, so look at the object
                #as a bit of a double check to make sure we are getting the
                #property for the correct object in case of name overloads
                if target.data('boundto.binder') is object
                    target[setWith] value
                    #and to be very jQuery link, fire an event to that any
                    #library user can override as they see fit in code
                    target.trigger 'datachange', [target[0], object, property, value]

            #initial set of the value
            target[setWith] object[property]
        )()
    element

###
@function

Given a DOM element, remove any data binding.

@param $ {Object} jQuery reference
@param element {Object} DOM element root that was previously bound
@returns this echoes back element to allow chaining
###
unbind = ($, element) ->
    $('[data-attribute]', $(element)).each (i, bindable) ->
        target = $(bindable)
        property = target.data 'attribute'
        target.off '.binder'
        target.data 'boundto.binder', null
        event_hub.unsubscribe target, property
    element

$ = jQuery
###
jQuery plugin, this exports data binding
###
$.fn.extend
    binder: (data) ->
        self = $.fn.binder
        @each (i, el) ->
            if data
                #double binding would be trouble
                unbind $, el
                databind $, data, el
            else
                unbind $, el


