###
Let's test the ability to create a very general purpose event generating proxy
wrapper around any old object.

...it's a valid question to ask if this is useful enough to be its own stand
alone library...
###


describe 'object proxy', ->

    #this is sort of like a transaction log on property access
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
        x.a.unshift 0
        expect(x.a.pop()).toEqual 2
        expect(x.a.shift()).toEqual 0
        x.a.push 2
        expect(x.a.reverse()).toEqual [2,1]
        expect(x.a.sort()).toEqual [1,2]
        expect(x.a.splice(0,2,'a','b')).toEqual [1,2]
        expect(x.a).toEqual ['a','b']

        #just check the operations before and after arrays at the end
        expect(before).toEqual [
            ['a', []],
            ['a', [1]],
            ['a', [1,2]]
            ['a', [0,1,2]]
            ['a', [0,1]],
            ['a', [1]],
            ['a', [1,2]],
            ['a', [2,1]],
            ['a', [1,2]],
        ]
        expect(after).toEqual [
            ['a', [1]],
            ['a', [1,2]],
            ['a', [0,1,2]]
            ['a', [0,1]]
            ['a', [1]],
            ['a', [1,2]],
            ['a', [2,1]],
            ['a', [1,2]],
            ['a', ['a','b']],
        ]

