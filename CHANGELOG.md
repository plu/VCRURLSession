# VCRURLSession

## Changelog

### 1.3.0 (TBD)

* Add `registerProtocolClasses` and `unregisterProtocolClasses`
* Do not expose `records` on `VCRURLSessionCassette`, expose `numberOfRecords` instead
* Add `numberOfPlayedRecords` to `VCRURLSessionCassette`

### 1.2.0 (2016-01-21)

* Do not register `NSURLProtocol` classes for `NSURLConnection` anymore
* Try to avoid caching

### 1.1.1 (2016-01-20)

* Add logger

### 1.1.0 (2016-01-19)

* Accept all SSL certificates
* Add `replaySpeed` feature
* Store `recordDate`

### 1.0.0 (2016-01-16)

* Initial release
