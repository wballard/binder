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

@param $ {Object} jQuery reference
@param object {Object} data source object
@param element {Object} UI target DOM element
@returns this echoes back the DOM element to allow chaining
###
binder = ($, object, element) ->
    target = $(element)
    if target.is 'input'
        #input elements work a bit differently
        console.log element
    else
        #otherwise we just replace the body
        property = target.attr 'data-attribute'
        target.text object[property]

$ = jQuery
###
jQuery plugin
###
$.fn.extend
    binder: (data) ->
        self = $.fn.binder
        @each (i, el) ->
            binder $, data, el
