export 'open_connection_unsupported.dart'
    if (dart.library.ffi) 'open_connection_native.dart'
    if (dart.library.js_interop) 'open_connection_web.dart';
