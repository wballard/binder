###
Test our ability to do bindings against the user interface.
###

describe 'declarative binding', ->

    it 'should bind data to elements', ->
        data =
            a: 1
            b: 2
        $('#static > [data-attribute]').binder data
        expect($('#static > [data-attribute="a"]').text())
            .toEqual data.a.toString()
        expect($('#static > [data-attribute="b"]').text())
            .toEqual data.b.toString()

        #and now change the javascript variable
        data.b = 'zz'
        expect($('#static > [data-attribute="b"]').text())
            .toEqual 'zz'
