###
proxy provides the ability to wrap any object with a proxy wraps any
property set.
###

array_mutators = ['push', 'unshift', 'pop', 'shift']

###
Given an object, 'mangle' it by replacing all properties with a caller
transparent proxy. The intention is that this is used to intercept property
sets on data objects as returned via JSON.

@param object {Object} this object will be proxied in place
@param before {Function} proxy intercepts just before a write
@param after {Function} proxy intercepts just after a write
@returns {Object} this echoes the proxied object to allow chaining
###
proxyObject = (object, before, after) ->
    handler = (property, before_value, after_value) ->
        before object, property, before_value
        after object, property, after_value
    for name, value of object
        #arrays need their mutation methods intercepted
        if Array.isArray value
            for mutator in array_mutators
                console.log mutator
                (->
                    prior = value[mutator]
                    value[mutator] = ->
                        #this is a terrible clone, find a better way
                        before object, name, value.map((x)-> x)
                        ret = prior.apply value, arguments
                        after object, name, value.map((x)-> x)
                        console.log prior, value.map((x) -> x)
                        ret)()
        #reckrsively proxy
        else if typeof(value) == 'object'
            value = proxyObject value, before, after
        #watch every property to call our function
        object.watch name, handler
    object

module =
    proxyObject:  proxyObject

#make this AMD/node/window compatible
window.binder = module
