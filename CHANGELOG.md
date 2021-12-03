# VCRURLSession

## Changelog

### 2.0.0 (2021-12-03

* Add Swift Package Manager support
* Wrap all code in `if DEBUG`

### 1.4.0 (2017-01-05)

* Set `NSURLSessionConfiguration.URLCache` to `nil` when recording/replaying

### 1.3.0 (2016-02-07)

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
