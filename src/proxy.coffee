###
proxy provides the ability to wrap any object with a proxy wraps any
property set.
###

array_mutators = ['push', 'unshift', 'pop',
    'shift', 'reverse', 'sort', 'splice']

###
Given an object, 'mangle' it by replacing all properties with a caller
transparent proxy. The intention is that this is used to intercept property
sets on data objects as returned via JSON.

@param object {Object} this object will be proxied in place
@param before {Function} proxy intercepts just before a write
@param after {Function} proxy intercepts just after a write
@returns {Object} this echoes the proxied object to allow chaining
###
proxyObject = (object, before, after, options) ->
    if not object
        return null
    if object?.__proxied__
        return object
    #TODO
    #nested array values need to be proxied
    #parent will be handy
    handler = (property, before_value, after_value) ->
        #objects need to be proxied when added to an object
        if typeof(after_value) == 'object'
            proxyObject after_value, before, after,
                parent: object
        before object, property, before_value
        after object, property, after_value
        after_value
    for name, value of object
        #arrays need their mutation methods intercepted
        if Array.isArray value
            for mutator in array_mutators
                (->
                    prior = value[mutator]
                    value[mutator] = ->
                        before object, name, value.slice(0)
                        ret = prior.apply value, arguments
                        after object, name, value.slice(0)
                        ret)()
        #recursive proxy
        else if typeof(value) == 'object'
            value = proxyObject value, before, after,
                parent: object
        #watch every property to call our function
        object.watch name, handler
    Object.defineProperty object, '__proxied__',
        enumerable: false
        value: true
    object

module =
    proxyObject:  proxyObject

#make this AMD/node/window compatible
window.binder = module
