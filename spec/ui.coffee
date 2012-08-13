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

    it 'should update bound static elements from bound input elements', ->
        data =
            a: 1
            b: 2
        $('#dynamic').binder data
        $('#static').binder data
        #force fire the change
        $('#dynamic > [data-attribute="a"]').val('q').trigger 'change'
        $('#dynamic > [data-attribute="b"]').val('r').trigger 'change'
        #from the form down to the data object
        expect(data.a).toEqual 'q'
        expect(data.b).toEqual 'r'
        #and across to the UI element
        expect($('#static > [data-attribute="a"]').text())
            .toEqual data.a.toString()
        expect($('#static > [data-attribute="b"]').text())
            .toEqual data.b.toString()

    it 'should bind in real time', ->
        data =
            a: 1
            b: 2
        $('#dynamic').binder data
        $('#static').binder data
        #force fire the change
        $('#dynamic > [data-attribute="a"]').val('q').trigger 'keyup'
        $('#dynamic > [data-attribute="b"]').val('r').trigger 'keyup'
        #from the form down to the data object
        expect(data.a).toEqual 'q'
        expect(data.b).toEqual 'r'
