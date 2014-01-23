NSURL-QueryDictionary
=====================

Just a simple NSURL category to make working with URL queries more pleasant.

* `-[NSURL queryDictionary]` extract the URL's query string as key/value pairs.
* `-[NSURL URLByAppendingQueryDictionary:]` append the specified key/value pairs to the URL, with existing query handled. Note that behaviour for overlapping keys/values is undefined.

The parsing components of the above are also available separately as:

* `-[NSString URLQueryDictionary]` split a valid query string into key/value pairs.
* `-[NSDictionary URLQueryString]` the reverse of above; create a URL query string from an `NSDictionary` instance.

Queries with empty values are converted to `NSNull` and vice versa as of v0.0.5.

##Version history

**v0.0.5**

Covered an additional empty value case - URL query component has separator, but empty value.

**v0.0.4**

Added handling for keys with no value, empty value or `NSNull`.

**v0.0.3**

Split the query string parsing components out into `NSString` and `NSDictionary` categories for additional flexibility.

**v0.0.2**

Added support for dictionary keys other than NSString. Currently just uses `-description`, but this is ok for `NSNumber` and `NSDate` and a few others, so may be sufficient.

**v0.0.1**

Initial release.

Have fun!
---------

[MIT Licensed](http://jc.mit-license.org/) >> [jon.crooke@gmail.com](mailto:jon.crooke@gmail.com)
