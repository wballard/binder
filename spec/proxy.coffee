###
Let's test the ability to create a very general purpose event generating proxy
wrapper around any old object.

...it's a valid question to ask if this is useful enough to be its own stand
alone library...
###


describe 'object proxy', ->
    scratch = []

    beforeEach ->
        scratch = []

    intercept = (object, property, value) ->
        scratch.push [object, property, value]

    it 'changes an object into a proxy', ->
        x =
            a: 1
        y = binder.proxyObject x
        expect(y).toBe(x)

    it 'proxies an object with scalar properties', ->
        x =
            a: 1
            b: 2
        binder.proxyObject x, intercept, intercept
        x.a = 11
        x.b = 22
        expect(scratch).toEqual [
            [x, 'a', 1],
            [x, 'a', 11],
            [x, 'b', 2],
            [x, 'b', 22]
        ]

    it 'proxies into an object with array properties', ->
        x = 
            a: []
        binder.proxyObject x, intercept, intercept
        x.a.push 1
        x.a.push 2
        compare_to = [
            [x, 'a', []],
            [x, 'a', [1]],
            [x, 'a', [1]],
            [x, 'a', [1,2]],
        ]
        expect(scratch).toEqual compare_to
