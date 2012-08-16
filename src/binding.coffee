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
@function

Given an object and a DOM element, bind them together.

Elements are marked with data-bind='name', where name is property
of the target JavaScript object.

@param $ {Object} jQuery reference
@param object {Object} data source object
@param element {Object} UI target DOM element
@returns this echoes back the DOM element to allow chaining
###
databind = ($, object, element) ->

    #hook up a proxy to the object that translates the callback to
    #a jQuery event, proxyObject will only proxy just once, so this will
    #so it is using events rather than direct method calls
    binder.proxyObject object, ignore,
        (object, property, value, options) ->
            $.pubsubhub("data-bind-#{property}").publish [object, value]

    #grab at any bindable under this element
    $('[data-bind]', $(element)).each (i, bindable) ->
        ( ->
            target = $(bindable)
            property = target.attr 'data-bind'
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
            target.data 'boundto.callback', ([object, value]) ->
                #data events are coming off by name, so look at the object
                #as a bit of a double check to make sure we are getting the
                #property for the correct object in case of name overloads
                if target.data('boundto.binder') is object
                    target[setWith] value
                    #and to be very jQuery like, fire an event to that any
                    #library user can override as they see fit in code
                    target.trigger 'datachange', [target[0], object, property, value]
            $.pubsubhub("data-bind-#{property}").subscribe target.data('boundto.callback')
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
    $('[data-bind]', $(element)).each (i, bindable) ->
        target = $(bindable)
        property = target.data 'bind'
        target.off '.binder'
        target.data 'boundto.binder', null
        $.pubsubhub("data-bind-#{property}").unsubscribe target.data('boundto.callback')
        target.data 'boundto.callback', null
    element

$ = jQuery
###
jQuery plugin, this exports data binding.
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


