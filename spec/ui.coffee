###
Test our ability to do bindings against the user interface.
###

describe 'declarative binding', ->

    it 'should bind data to elements', ->
        data =
            a: 1
            b: 2
        $('#static > [data-attribute]').binder data
