NSURL-QueryDictionary
=====================

Just a simple NSURL category to make working with URL queries more pleasant.

* `-[NSURL queryDictionary]` extract the URL's query string as key/value pairs.
* `-[NSURL URLByAppendingQueryDictionary:]` append the specified key/value pairs to the URL, with existing query handled. Note that behaviour for overlapping keys/values is undefined.

##Version history

**v0.0.2**

Added support for dictionary keys other than NSString. Currently just uses `-description`, but this is ok for `NSNumber` and `NSDate` and a few others, so may be sufficient.

**v0.0.1**

Initial release.

Have fun!
---------

[MIT Licensed](http://jc.mit-license.org/) >> [jon.crooke@gmail.com](mailto:jon.crooke@gmail.com)
