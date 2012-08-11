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
    if typeof(object) != 'object'
        return object
    if object?.__proxied__
        return object
    #TODO
    #parent will be handy

    #Define a handler closure for this object being proxied
    #to be used from watch. This is the interception point that
    #connects the before and after callbacks.
    handler = (property, before_value, after_value) ->
        #objects need to be proxied when added to an object
        if typeof(after_value) == 'object'
            proxyObject after_value, before, after,
                parent: object
        before object, property, before_value
        after object, property, after_value
        after_value

    #every enumerable property will be proxied
    for name, value of object
        #arrays need their mutation methods intercepted
        if Array.isArray value
            for mutator in array_mutators
                (->
                    prior = value[mutator]
                    value[mutator] = ->
                        #this is taking a slice snapshot of the array
                        #in order to facilitate testing, as the values will
                        #be asserted after a series of mutations to the array
                        before object, name, value.slice(0)
                        ret = prior.apply value, arguments
                        for argument in arguments
                            #parent is the array, not the containing object
                            proxyObject argument, before, after,
                                parent: value
                        after object, name, value.slice(0)
                        ret)()
        #recursive proxy
        value = proxyObject value, before, after,
            parent: object
        #watch every property to call our function
        object.watch name, handler

    #create a guard so we can avoid double proxy, that isn't enumerable
    #since we don't want it showing up in JSON
    Object.defineProperty object, '__proxied__',
        enumerable: false
        value: true
    object

#Export the proxy to the passed this or as a CommonJS module 
#if that's available.
root = this
if module? and module?.exports
    root = module.exports
if not root?.binder
    root.binder = {}
root.binder.proxyObject = proxyObject
