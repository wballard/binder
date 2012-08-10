###
Let's test the ability to create a very general purpose event generating proxy
wrapper around any old object.

...it's a valid question to ask if this is useful enough to be its own stand
alone library...
###


describe 'object proxy', ->
    before = []
    after = []

    beforeEach ->
        before = []
        after = []

    intercept_before = (object, property, value) ->
        before.push [property, value]

    intercept_after = (object, property, value) ->
        after.push [property, value]

    it 'changes an object into a proxy', ->
        x =
            a: 1
        y = binder.proxyObject x
        expect(y).toBe(x)

    it 'proxies an object with scalar properties', ->
        x =
            a: 1
            b: 2
        binder.proxyObject x, intercept_before, intercept_after
        x.a = 11
        x.b = 22
        expect(before).toEqual [
            ['a', 1],
            ['b', 2]
        ]
        expect(after).toEqual [
            ['a', 11],
            ['b', 22]
        ]

    it 'proxies into an object with array properties', ->
        x = 
            a: []
        binder.proxyObject x, intercept_before, intercept_after

        x.a.push 1
        x.a.push 2
        expect(after).toEqual [
            ['a', [1]],
            ['a', [1,2]]
        ]

        x.a.unshift 0
        expect(after).toEqual [
            ['a', [1]],
            ['a', [1,2]],
            ['a', [0,1,2]]
        ]

        y = x.a.pop()
        expect(y).toEqual 2
        expect(after).toEqual [
            ['a', [1]],
            ['a', [1,2]],
            ['a', [0,1,2]]
            ['a', [0,1]]
        ]

        y = x.a.shift()
        expect(y).toEqual 0
        expect(after).toEqual [
            ['a', [1]],
            ['a', [1,2]],
            ['a', [0,1,2]]
            ['a', [0,1]]
            ['a', [1]]
        ]
