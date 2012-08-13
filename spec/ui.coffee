###
Test our ability to do bindings against the user interface.
###

describe 'declarative binding', ->

    it 'should bind data to static content elements', ->
        data =
            a: 1
            b: 2
        #bind up to a DOM element that may have multiple 
        #data-attribute sub elements
        $('#static').binder data
        expect($('#static > [data-attribute="a"]').text())
            .toEqual data.a.toString()
        expect($('#static > [data-attribute="b"]').text())
            .toEqual data.b.toString()

        #and now change the javascript variable
        data.b = 'zz'
        expect($('#static > [data-attribute="b"]').text())
            .toEqual 'zz'

    it 'should bind data to form input elements', ->
        data =
            a: 1
            b: 2
        #bind up to a DOM element that may have multiple 
        #data-attribute sub elements
        $('#dynamic').binder data
        expect($('#dynamic > [data-attribute="a"]').val())
            .toEqual data.a.toString()
        expect($('#dynamic > [data-attribute="b"]').val())
            .toEqual data.b.toString()

        #and now change the javascript variable
        data.b = 'zz'
        expect($('#dynamic > [data-attribute="b"]').val())
            .toEqual 'zz'
