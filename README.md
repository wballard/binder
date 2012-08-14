# Binder #
Binder is a jQuery plugin that allows you to keep your JavaScript
objects and DOM elements in synch without any fuss, base class, or
framework. Plain DOM, JavaScript objects, and jQuery working together.

Binding should be two way, from any given JavaScript object to any given
DOM element, and back again from user input DOM elements. Further
clarifying this, some available binding libraries are two way, but not
reactive -- specifically once you render, if you update the JavaScript
object in code rendering is not repeated. Other libraries trap events on
DOM elements and can update your JavaScript object. Updates to either the
JavaScript object that is the binding context or the DOM element that is
the presentation should be reflected. Let's call this *omnidirectional*.

With binder you take just plain jQuery and just plain JavaScript
variables, no need for a framework or to restructure your application to
take advantage of binder.

## Proxy ##
Binder works by creating a transparent proxy around your data objects,
the idea being you can load up data from any JavaScript object and make
it work as a binding context, without any base classes or frameworkery.

This proxy intercepts property sets and array mutations. Read through
it, you may want to use it to do some JavaScript aspect-oriented
programming.

## Declarative Binding ##
The most basic case is binding properties of some JavaScript object to a
static display element. This is done simply by referencing the
properties of a bound object by name. The idea of this design is that
the UI is where you want to see your properties reflected, so this is
the best place to put the bindings.

~~~
    <div id='static'>
        <h1>UI Binding Targets</h1>
        <h2 data-attribute='a'></h2>
        <h3 data-attribute='b'></h3>
    </div>
~~~

This of course works for form inputs as well, the only difference is
that the binding is two way.

~~~
    <form id='dynamic' action=''>
        <input type='text' data-attribute='a'>
        <input type='text' data-attribute='b'>
    </form>
~~~

And actually connecting the thing is just:

~~~
    var data = {
        a: 'Hello',
        b: 'World
    }
    $('#dynamic').binder data
~~~

And unbinding is just:

~~~
    $('#dynamic').binder null
~~~

The proxies and event handlers that make this work are hooked up for you
automatically.

## Events ##
In order to make this feel a lot like jQuery, binder creates a few new
events so that you can intercept and work with data binding just like
any other event off the DOM.

### datachange ###
This is fired on each DOM element hooked up with binder when the
underlying bound object property changes. You make a callback that looks
like:

~~~
function (event, element, object, property, value) {...}
~~~

## Declarative Formatting ##
**TODO**
Besides keeping object properties and DOM in synch, you will commonly
want to reformat data for the UI. Rather than require you set up a view
model with transformative properties, binder lets you just attach
*formatters* to DOM elements. Formatters are simple objects that pair a
forward and backward transformation to allow going from a JavaScript
object (forward) to a DOM element for display, and from a DOM elment
(backward) to a JavaScript object.

Most commonly you are going to use this to go in and out of formatted
number types like currency.

Not all formatters are reversible, for example -- going to uppercase.

Formatters are registered into binder, and a few are provided to give
you a sense as how to make your own.

Formatters confront errors, like if text is typed into a number box.


##### License #####
Released under the MIT license. 
Have fun!
