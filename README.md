# Binder #
Binder allows you to have automatically updated data from HTML without
any code to specify that a property is bindable. 

Binding should be two way, from and given JavaScript object to any given
DOM element, and back again from user input DOM elements. Further
clarifying this, many available binding libraries are two way, but not
reactive -- specifically once you render if you update the JavaScript
object in code rendering is not repeated. Updates to either the
JavaScript object that is the binding context or the DOM element that is
the presentation should be reflected. Let's call this *omnidirectional*.

## Proxy ##
Binder works by creating a transparent proxy around your data objects,
the idea being you can load up data from any JavaScript object and make
it work as a binding context, without any base classes or frameworkery.
