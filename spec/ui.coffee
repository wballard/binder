###
Test our ability to do bindings against the user interface.
###

describe 'declarative binding', ->
    beforeEach ->
        snip = """
        <div id='test_form' class='container'>
            <form id='dynamic' action=''>
                <p>Type here...</p>
                <input type='text' data-bind='a'>
                <input type='text' data-bind='b'>
            </form>
            <div id='static'>
                <p>And watch these change...</p>
                <h2 data-bind='a'></h2>
                <h3 data-bind='b'></h3>
            </div>
        </div>
        """
        $('body').append(snip)

    afterEach ->
        $('#test_form').remove()

    it 'should bind data to static content elements', ->
        data =
            a: 1
            b: 2
        #bind up to a DOM element that may have multiple 
        #data-bind sub elements
        $('#static').binder data
        expect($('#static > [data-bind="a"]').text())
            .toEqual data.a.toString()
        expect($('#static > [data-bind="b"]').text())
            .toEqual data.b.toString()

        #and now change the javascript variable
        data.b = 'zz'
        expect($('#static > [data-bind="b"]').text())
            .toEqual 'zz'

    it 'should bind data to form input elements', ->
        data =
            a: 1
            b: 2
        #bind up to a DOM element that may have multiple 
        #data-bind sub elements
        $('#dynamic').binder data
        expect($('#dynamic > [data-bind="a"]').val())
            .toEqual data.a.toString()
        expect($('#dynamic > [data-bind="b"]').val())
            .toEqual data.b.toString()

        #and now change the javascript variable
        data.b = 'zz'
        expect($('#dynamic > [data-bind="b"]').val())
            .toEqual 'zz'

    it 'should update bound static elements from bound input elements', ->
        data =
            a: 1
            b: 2
        $('#dynamic').binder data
        $('#static').binder data
        #force fire the change
        $('#dynamic > [data-bind="a"]').val('q').trigger 'change'
        $('#dynamic > [data-bind="b"]').val('r').trigger 'change'
        #from the form down to the data object
        expect(data.a).toEqual 'q'
        expect(data.b).toEqual 'r'
        #and across to the UI element
        expect($('#static > [data-bind="a"]').text())
            .toEqual data.a.toString()
        expect($('#static > [data-bind="b"]').text())
            .toEqual data.b.toString()

    it 'should bind in real time', ->
        data =
            a: 1
            b: 2
        $('#dynamic').binder data
        $('#static').binder data
        #force fire the change
        $('#dynamic > [data-bind="a"]').val('q').trigger 'keyup'
        $('#dynamic > [data-bind="b"]').val('r').trigger 'keyup'
        #from the form down to the data object
        expect(data.a).toEqual 'q'
        expect(data.b).toEqual 'r'

    it 'should let you unbind', ->
        data =
            a: 1
            b: 2
        $('#dynamic').binder data
        $('#static').binder data
        data.a = 'zz'
        expect($('#static > [data-bind="a"]').text())
            .toEqual data.a.toString()
        expect($('#dynamic > [data-bind="a"]').val())
            .toEqual data.a.toString()
        #here is the unbind protocol, bind to null
        $('#dynamic').binder null
        $('#static').binder null
        data.a = 'yy'
        expect($('#static > [data-bind="a"]').text())
            .toEqual 'zz'
        expect($('#dynamic > [data-bind="a"]').val())
            .toEqual 'zz'
        $('#dynamic > [data-bind="a"]').val('xx').trigger 'change'
        #this one is zz -- the last value, no binding
        expect($('#static > [data-bind="a"]').text())
            .toEqual 'zz'
        #this one is xx -- we updated it explicitly in the input
        expect($('#dynamic > [data-bind="a"]').val())
            .toEqual 'xx'

    it 'should fire events', ->
        data =
            a: 1
            b: 2
        hub =
            for_a: ->
            for_static: ->
        spyOn hub, 'for_a'
        spyOn hub, 'for_static'
        $('#static').binder data

        $('#static > [data-bind="a"]').on 'datachange', hub.for_a
        $('#static').on 'datachange', hub.for_static

        data.a = 11

        expect(hub.for_a).toHaveBeenCalled()
        expect(hub.for_a).toHaveBeenCalledWith jasmine.any(Object),
            $('#static > [data-bind="a"]')[0],
            data,
            'a',
            11
        #and the bubble
        expect(hub.for_static).toHaveBeenCalled()
        expect(hub.for_static).toHaveBeenCalledWith jasmine.any(Object),
            $('#static > [data-bind="a"]')[0],
            data,
            'a',
            11

