###
@module pubsubhub

Provides publish and subscribe functionality using jQuery Callback. This
allows you have to global events which can be seen across an entire page rather
than just limited to DOM event bubbling.
###


$ = jQuery
topics = {}
###
jQuery plugin, this exports a pubsubhub.
###
$.pubsubhub = (topic_name) ->
    topic = topic_name and topics[topic_name]
    if not topic
        callbacks = jQuery.Callbacks()
        topic =
            publish: callbacks.fire
            subscribe: callbacks.add
            unsubscribe: callbacks.remove
        topics[topic_name] = topic
    topic
