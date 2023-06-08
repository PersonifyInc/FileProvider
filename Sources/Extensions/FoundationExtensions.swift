//
//  FileProviderExtensions.swift
//  FileProvider
//
//  Created by Amir Abbas on 12/27/1395 AP.
//
//

import Foundation

extension Array where Element: FileObject {
    /// Returns a sorted array of `FileObject`s by criterias set in attributes.
    public func sort(by type: FileObjectSorting.SortType, ascending: Bool = true, isDirectoriesFirst: Bool = false) -> [Element] {
        let sorting = FileObjectSorting(type: type, ascending: ascending, isDirectoriesFirst: isDirectoriesFirst)
        return sorting.sort(self) as! [Element]
    }
    
    /// Sorts array of `FileObject`s by criterias set in attributes.
    public mutating func sorted(by type: FileObjectSorting.SortType, ascending: Bool = true, isDirectoriesFirst: Bool = false) {
        self = self.sort(by: type, ascending: ascending, isDirectoriesFirst: isDirectoriesFirst)
    }
}

public extension Sequence where Iterator.Element == UInt8 {
    /// Converts a byte array into hexadecimal string representation
    func hexString() -> String {
        return self.map{String(format: "%02X", $0)}.joined()
    }
}

extension URLFileResourceType {
    /// **FileProvider** returns corresponding `URLFileResourceType` of a `FileAttributeType` value
    public init(fileTypeValue: FileAttributeType) {
        switch fileTypeValue {
        case FileAttributeType.typeCharacterSpecial: self = .characterSpecial
        case FileAttributeType.typeDirectory: self = .directory
        case FileAttributeType.typeBlockSpecial: self = .blockSpecial
        case FileAttributeType.typeRegular: self = .regular
        case FileAttributeType.typeSymbolicLink: self = .symbolicLink
        case FileAttributeType.typeSocket: self = .socket
        case FileAttributeType.typeUnknown: self = .unknown
        default: self = .unknown
        }
    }
}

extension CocoaError {
    init(_ code: CocoaError.Code, path: String?) {
        if let path = path {
            let userInfo: [String: Any] = [NSFilePathErrorKey: path]
            self.init(code, userInfo: userInfo)
        } else {
            self.init(code)
        }
        
    }
}

extension URLError {
    init(_ code: URLError.Code, url: URL?) {
        if let url = url {
            let userInfo: [String: Any] = [NSURLErrorKey: url,
                                           NSURLErrorFailingURLErrorKey: url,
                                           NSURLErrorFailingURLStringErrorKey: url.absoluteString,
                                           ]
            self.init(code, userInfo: userInfo)
        } else {
            self.init(code)
        }
    }
}

extension URLResourceKey {
    /// **FileProvider** returns url of file object.
    public static let fileURLKey = URLResourceKey(rawValue: "NSURLFileURLKey")
    /// **FileProvider** returns modification date of file in server
    public static let serverDateKey = URLResourceKey(rawValue: "NSURLServerDateKey")
    /// **FileProvider** returns HTTP ETag string of remote resource
    public static let entryTagKey = URLResourceKey(rawValue: "NSURLEntryTagKey")
    /// **FileProvider** returns MIME type of file, if returned by server
    public static let mimeTypeKey = URLResourceKey(rawValue: "NSURLMIMETypeIdentifierKey")
    /// **FileProvider** returns either file is encrypted or not
    public static let isEncryptedKey = URLResourceKey(rawValue: "NSURLIsEncryptedKey")
    /// **FileProvider** count of items in directory
    public static let childrensCount = URLResourceKey(rawValue: "MFPURLChildrensCount")
}

extension ProgressUserInfoKey {
    /// **FileProvider** returns associated `FileProviderOperationType`
    public static let fileProvderOperationTypeKey = ProgressUserInfoKey("MFPOperationTypeKey")
    /// **FileProvider** returns start date/time of operation
    public static let startingTimeKey = ProgressUserInfoKey("NSProgressStartingTimeKey")
}

internal extension URL {
    var uw_scheme: String {
        return self.scheme ?? ""
    }
    
    var fileIsDirectory: Bool {
        return (try? self.resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory ?? false
    }
    
    var fileSize: Int64 {
        return (try? self.resourceValues(forKeys: [.fileSizeKey]))?.allValues[.fileSizeKey] as? Int64 ?? -1
    }
    
    var fileExists: Bool {
        return (try? self.checkResourceIsReachable()) ?? false
    }
    
    #if os(macOS) || os(iOS) || os(tvOS)
    #else
    func checkPromisedItemIsReachable() throws -> Bool {
        return false
    }
    #endif
}

extension URLRequest {
    /// Defines HTTP Authentication method required to access
    public enum AuthenticationType {
        /// Basic method for authentication
        case basic
        /// Digest method for authentication
        case digest
        /// OAuth 1.0 method for authentication (OAuth)
        case oAuth1
        /// OAuth 2.0 method for authentication (Bearer)
        case oAuth2
    }
}

/// Holds file MIME, and introduces selected type MIME as constants
public struct ContentMIMEType: RawRepresentable, Hashable, Equatable {
    public var rawValue: String
    public typealias RawValue = String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    public var hashValue: Int { return rawValue.hashValue }
    public static func == (lhs: ContentMIMEType, rhs: ContentMIMEType) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    /// Directory
    static public let directory = ContentMIMEType(rawValue: "httpd/unix-directory")
    
    // Archive and Binary
    
    /// Binary stream and unknown types
    static public let stream = ContentMIMEType(rawValue: "application/octet-stream")
    /// Protable document format
    static public let pdf = ContentMIMEType(rawValue: "application/pdf")
    /// Zip archive
    static public let zip = ContentMIMEType(rawValue: "application/zip")
    /// Rar archive
    static public let rarArchive = ContentMIMEType(rawValue: "application/x-rar-compressed")
    /// 7-zip archive
    static public let lzma = ContentMIMEType(rawValue: "application/x-7z-compressed")
    /// Adobe Flash
    static public let flash = ContentMIMEType(rawValue: "application/x-shockwave-flash")
    /// ePub book
    static public let epub = ContentMIMEType(rawValue: "application/epub+zip")
    /// Java archive (jar)
    static public let javaArchive = ContentMIMEType(rawValue: "application/java-archive")
    
    // Texts
    
    /// Text file
    static public let plainText = ContentMIMEType(rawValue: "text/plain")
    /// Coma-separated values
    static public let csv = ContentMIMEType(rawValue: "text/csv")
    /// Hyper-text markup language
    static public let html = ContentMIMEType(rawValue: "text/html")
    /// Common style sheet
    static public let css = ContentMIMEType(rawValue: "text/css")
    /// eXtended Markup language
    static public let xml = ContentMIMEType(rawValue: "text/xml")
    /// Javascript code file
    static public let javascript = ContentMIMEType(rawValue: "application/javascript")
    /// Javascript notation
    static public let json = ContentMIMEType(rawValue: "application/json")
    
    // Documents
    
    /// Rich text file (RTF)
    static public let richText = ContentMIMEType(rawValue: "application/rtf")
    /// Excel 2013 (OOXML) document
    static public let excel = ContentMIMEType(rawValue: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet")
    /// Powerpoint 2013 (OOXML) document
    static public let powerpoint = ContentMIMEType(rawValue: "application/vnd.openxmlformats-officedocument.presentationml.slideshow")
    /// Word 2013 (OOXML) document
    static public let word = ContentMIMEType(rawValue: "application/vnd.openxmlformats-officedocument.wordprocessingml.document")
    
    // Images
    
    /// Bitmap
    static public let bmp = ContentMIMEType(rawValue: "image/bmp")
    /// Graphics Interchange Format photo
    static public let gif = ContentMIMEType(rawValue: "image/gif")
    /// JPEG photo
    static public let jpeg = ContentMIMEType(rawValue: "image/jpeg")
    /// Portable network graphics
    static public let png = ContentMIMEType(rawValue: "image/png")
    
    // Audio & Video
    
    /// MPEG Audio
    static public let mpegAudio = ContentMIMEType(rawValue: "audio/mpeg")
    /// MPEG Video
    static public let mpeg = ContentMIMEType(rawValue: "video/mpeg")
    /// MPEG4 Audio
    static public let mpeg4Audio = ContentMIMEType(rawValue: "audio/mp4")
    /// MPEG4 Video
    static public let mpeg4 = ContentMIMEType(rawValue: "video/mp4")
    /// OGG Audio
    static public let ogg = ContentMIMEType(rawValue: "audio/ogg")
    /// Advanced Audio Coding
    static public let aac = ContentMIMEType(rawValue: "audio/x-aac")
    /// Microsoft Audio Video Interleaved
    static public let avi = ContentMIMEType(rawValue: "video/x-msvideo")
    /// Microsoft Wave audio
    static public let wav = ContentMIMEType(rawValue: "audio/x-wav")
    /// Apple QuickTime format
    static public let quicktime = ContentMIMEType(rawValue: "video/quicktime")
    /// 3GPP
    static public let threegp = ContentMIMEType(rawValue: "video/3gpp")
    /// Adobe Flash video
    static public let flashVideo = ContentMIMEType(rawValue: "video/x-flv")
    /// Adobe Flash video
    static public let flv = ContentMIMEType.flashVideo
    
    // Google Drive
    
    /// Google Drive: Folder
    static public let googleFolder = ContentMIMEType(rawValue: "application/vnd.google-apps.folder")
    /// Google Drive: Document (word processor)
    static public let googleDocument = ContentMIMEType(rawValue: "application/vnd.google-apps.document")
    /// Google Drive: Sheets (spreadsheet)
    static public let googleSheets = ContentMIMEType(rawValue: "application/vnd.google-apps.spreadsheet")
    /// Google Drive: Slides (presentation)
    static public let googleSlides = ContentMIMEType(rawValue: "application/vnd.google-apps.presentation")
    /// Google Drive: Drawing (vector draw)
    static public let googleDrawing = ContentMIMEType(rawValue: "application/vnd.google-apps.drawing")
    /// Google Drive: Audio
    static public let googleAudio = ContentMIMEType(rawValue: "application/vnd.google-apps.audio")
    /// Google Drive: Video
    static public let googleVideo = ContentMIMEType(rawValue: "application/vnd.google-apps.video")
}

public extension URLRequest {
    mutating func setValue(authentication credential: URLCredential?, with type: AuthenticationType) {
        func base64(_ str: String) -> String {
            let plainData = str.data(using: .utf8)
            let base64String = plainData!.base64EncodedString(options: [])
            return base64String
        }
        
        guard let credential = credential else { return }
        switch type {
        case .basic:
            let user = credential.user?.replacingOccurrences(of: ":", with: "") ?? ""
            let pass = credential.password ?? ""
            let authStr = "\(user):\(pass)"
            if let base64Auth = authStr.data(using: .utf8)?.base64EncodedString() {
                self.setValue("Basic \(base64Auth)", forHTTPHeaderField: "Authorization")
            }
        case .digest:
            // handled by RemoteSessionDelegate
            break
        case .oAuth1:
            if let oauth = credential.password {
                self.setValue("OAuth \(oauth)", forHTTPHeaderField: "Authorization")
            }
        case .oAuth2:
            if let bearer = credential.password {
                self.setValue("Bearer \(bearer)", forHTTPHeaderField: "Authorization")
            }
        }
    }
    
    mutating func setValue(acceptCharset: String.Encoding, quality: Double? = nil) {
        let cfEncoding = CFStringConvertNSStringEncodingToEncoding(acceptCharset.rawValue)
        if let charsetString = CFStringConvertEncodingToIANACharSetName(cfEncoding) as String? {
            if let qualityDesc = quality.flatMap({ String(format: "%.1f", min(0, max ($0, 1))) }) {
                self.setValue("\(charsetString);q=\(qualityDesc)", forHTTPHeaderField: "Accept-Charset")
            } else {
                self.setValue(charsetString, forHTTPHeaderField: "Accept-Charset")
            }
        }
    }
    mutating func addValue(acceptCharset: String.Encoding, quality: Double? = nil) {
        let cfEncoding = CFStringConvertNSStringEncodingToEncoding(acceptCharset.rawValue)
        if let charsetString = CFStringConvertEncodingToIANACharSetName(cfEncoding) as String? {
            if let qualityDesc = quality.flatMap({ String(format: "%.1f", min(0, max ($0, 1))) }) {
                self.addValue("\(charsetString);q=\(qualityDesc)", forHTTPHeaderField: "Accept-Charset")
            } else {
                self.addValue(charsetString, forHTTPHeaderField: "Accept-Charset")
            }
        }
    }
    
    enum Encoding: String {
        case all = "*"
        case identity
        case gzip
        case deflate
    }
    
    mutating func setValue(acceptEncoding: Encoding, quality: Double? = nil) {
        if let qualityDesc = quality.flatMap({ String(format: "%.1f", min(0, max ($0, 1))) }) {
            self.setValue("\(acceptEncoding.rawValue);q=\(qualityDesc)", forHTTPHeaderField: "Accept-Encoding")
        } else {
            self.setValue(acceptEncoding.rawValue, forHTTPHeaderField: "Accept-Encoding")
        }
    }
    
    mutating func addValue(acceptEncoding: Encoding, quality: Double? = nil) {
        if let qualityDesc = quality.flatMap({ String(format: "%.1f", min(0, max ($0, 1))) }) {
            self.addValue("\(acceptEncoding.rawValue);q=\(qualityDesc)", forHTTPHeaderField: "Accept-Encoding")
        } else {
            self.addValue(acceptEncoding.rawValue, forHTTPHeaderField: "Accept-Encoding")
        }
    }
    
    mutating func setValue(acceptLanguage: Locale, quality: Double? = nil) {
        let langCode = acceptLanguage.identifier.replacingOccurrences(of: "_", with: "-")
        if let qualityDesc = quality.flatMap({ String(format: "%.1f", min(0, max ($0, 1))) }) {
            self.setValue("\(langCode);q=\(qualityDesc)", forHTTPHeaderField: "Accept-Language")
        } else {
            self.setValue(langCode, forHTTPHeaderField: "Accept-Language")
        }
    }
    
    mutating func addValue(acceptLanguage: Locale, quality: Double? = nil) {
        let langCode = acceptLanguage.identifier.replacingOccurrences(of: "_", with: "-")
        if let qualityDesc = quality.flatMap({ String(format: "%.1f", min(0, max ($0, 1))) }) {
            self.addValue("\(langCode);q=\(qualityDesc)", forHTTPHeaderField: "Accept-Language")
        } else {
            self.addValue(langCode, forHTTPHeaderField: "Accept-Language")
        }
    }
    
    mutating func setValue(rangeWithOffset offset: Int64, length: Int) {
        if length > 0 {
            self.setValue("bytes=\(offset)-\(offset + Int64(length) - 1)", forHTTPHeaderField: "Range")
        } else if offset > 0 && length < 0 {
            self.setValue("bytes=\(offset)-", forHTTPHeaderField: "Range")
        }
    }
    
    mutating func setValue(range: Range<Int>) {
        let range = max(0, range.lowerBound)..<range.upperBound
        if range.upperBound < Int.max && range.count > 0 {
            self.setValue("bytes=\(range.lowerBound)-\(range.upperBound - 1)", forHTTPHeaderField: "Range")
        } else if range.lowerBound > 0 {
            self.setValue("bytes=\(range.lowerBound)-", forHTTPHeaderField: "Range")
        }
    }
    
    mutating func setValue(contentRange range: Range<Int64>, totalBytes: Int64) {
        let range = max(0, range.lowerBound)..<range.upperBound
        if range.upperBound < Int.max && range.count > 0 {
            self.setValue("bytes \(range.lowerBound)-\(range.upperBound - 1)/\(totalBytes)", forHTTPHeaderField: "Content-Range")
        } else if range.lowerBound > 0 {
            self.setValue("bytes \(range.lowerBound)-/\(totalBytes)", forHTTPHeaderField: "Content-Range")
        } else {
            self.setValue("bytes 0-/\(totalBytes)", forHTTPHeaderField: "Content-Range")
        }
    }
    
    mutating func setValue(contentType: ContentMIMEType, charset: String.Encoding? = nil) {
        var parameter = ""
        if let charset = charset {
            let cfEncoding = CFStringConvertNSStringEncodingToEncoding(charset.rawValue)
            if let charsetString = CFStringConvertEncodingToIANACharSetName(cfEncoding) as String? {
                parameter = ";charset=" + charsetString
            }
        }
        
        self.setValue(contentType.rawValue + parameter, forHTTPHeaderField: "Content-Type")
    }
    
    mutating func setValue(dropboxArgKey requestDictionary: [String: Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestDictionary, options: []) else {
            return
        }
        guard var jsonString = String(data: jsonData, encoding: .utf8) else { return }
        jsonString = jsonString.asciiEscaped().replacingOccurrences(of: "\\/", with: "/")
        
        self.setValue(jsonString, forHTTPHeaderField: "Dropbox-API-Arg")
    }
    
    mutating func setValues(forHTTPHeaderFields fields: [String : String]) {
        for (key, value) in fields {
            self.setValue(value, forHTTPHeaderField: key)
        }
    }
}

internal extension CharacterSet {
    static let filePathAllowed = CharacterSet.urlPathAllowed.subtracting(CharacterSet(charactersIn: ":"))
}

extension Data {
    var isPDF: Bool {
        return self.count > 4 && self.scanString(length: 4, using: .ascii) == "%PDF"
    }
    
    init? (jsonDictionary dictionary: [String: Any]) {
        guard JSONSerialization.isValidJSONObject(dictionary) else { return nil }
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: []) else {
            return nil
        }
        self = data
    }
    
    func deserializeJSON() -> [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: self, options: [])) as? [String: Any]
    }
    
    init<T>(value: T) {
        var value = value
        self = Data(buffer: UnsafeBufferPointer(start: &value, count: 1))
    }
    
    func scanValue<T>() -> T? {
        guard MemoryLayout<T>.size <= self.count else { return nil }
        #if swift(>=5.0)
        return self.withUnsafeBytes { $0.load(as: T.self) }
        #else
        return self.withUnsafeBytes { $0.pointee }
        #endif
    }
    
    func scanValue<T>(start: Int) -> T? {
        let length = MemoryLayout<T>.size
        guard self.count >= start + length else { return nil }
        let subdata = self.subdata(in: start..<start+length)
        #if swift(>=5.0)
        return subdata.withUnsafeBytes { $0.load(as: T.self) }
        #else
        return subdata.withUnsafeBytes { $0.pointee }
        #endif
    }
    
    func scanString(start: Int = 0, length: Int, using encoding: String.Encoding = .utf8) -> String? {
        guard self.count >= start + length else { return nil }
        return String(data: self.subdata(in: start..<start+length), encoding: encoding)
    }
}

internal extension String {
    init? (jsonDictionary: [String: Any]) {
        guard let data = Data(jsonDictionary: jsonDictionary) else {
            return nil
        }
        self.init(data: data, encoding: .utf8)
    }
    
    func deserializeJSON(using encoding: String.Encoding = .utf8) -> [String: Any]? {
        guard let data = self.data(using: encoding) else {
            return nil
        }
        return data.deserializeJSON()
    }
    
    func asciiEscaped() -> String {
        var res = ""
        for char in self.unicodeScalars {
            let substring = String(char)
            if substring.canBeConverted(to: .ascii) {
                res.append(substring)
            } else {
                res = res.appendingFormat("\\u%04x", char.value)
            }
        }
        return res
    }
}

extension NSNumber {
    internal func format(precision: Int = 2, style: NumberFormatter.Style = .decimal) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = precision
        formatter.numberStyle = style
        return formatter.string(from: self)!
    }
}

extension String {
    internal var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    internal func appendingPathComponent(_ pathComponent: String) -> String {
        return (self as NSString).appendingPathComponent(pathComponent)
    }
    
    internal var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    internal var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
}

extension TimeInterval {
    var formatshort: String {
        var result = "0:00"
        if self < TimeInterval(Int32.max) {
            result = ""
            var time = DateComponents()
            time.hour   = Int(self / 3600)
            time.minute = Int((self.truncatingRemainder(dividingBy: 3600)) / 60)
            time.second = Int(self.truncatingRemainder(dividingBy: 60))
            let formatter = NumberFormatter()
            formatter.paddingCharacter = "0"
            formatter.minimumIntegerDigits = 2
            formatter.maximumFractionDigits = 0
            let formatterFirst = NumberFormatter()
            formatterFirst.maximumFractionDigits = 0
            if time.hour! > 0 {
                result = "\(formatterFirst.string(from: NSNumber(value: time.hour!))!):\(formatter.string(from: NSNumber(value: time.minute!))!):\(formatter.string(from: NSNumber(value: time.second!))!)"
            } else {
                result = "\(formatterFirst.string(from: NSNumber(value: time.minute!))!):\(formatter.string(from: NSNumber(value: time.second!))!)"
            }
        }
        result = result.trimmingCharacters(in: CharacterSet(charactersIn: ": "))
        return result
    }
}

extension Date {
    /// Date formats used commonly in internet messaging defined by various RFCs.
    public enum RFCStandards: String {
        /// Obsolete (2-digit year) date format defined by RFC 822 for http.
        case rfc822 = "EEE',' dd' 'MMM' 'yy HH':'mm':'ss z"
        /// Obsolete (2-digit year) date format defined by RFC 850 for usenet.
        case rfc850 = "EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z"
        /// Date format defined by RFC 1123 for http.
        case rfc1123 = "EEE',' dd' 'MMM' 'yyyy HH':'mm':'ss z"
        /// Date format defined by RFC 3339, as a profile of ISO 8601.
        case rfc3339 = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZZZ"
        /// Date format defined RFC 3339 as rare case with milliseconds.
        case rfc3339Extended = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZZZZZ"
        /// Date string returned by asctime() function.
        case asctime = "EEE MMM d HH':'mm':'ss yyyy"
        
        //  Defining a http alias allows changing default time format if a new RFC becomes standard.
        /// Equivalent to and defined by RFC 1123.
        public static let http = RFCStandards.rfc1123
        /// Equivalent to and defined by RFC 850.
        public static let usenet = RFCStandards.rfc850
        
        /* re. [RFC7231 section-7.1.1.1](https://tools.ietf.org/html/rfc7231#section-7.1.1.1)
         "HTTP servers and client MUST accept all three HTTP-date formats" which are IMF-fixdate,
         obsolete RFC 850 format and ANSI C's asctime() format.
         
         ISO 8601 format is common in JSON and XML fields, defined by RFC 3339 as a timestamp format.
         Though not mandated, we check string against them to allow using Date(rfcString:) in
         wider and more general sitations.
         
         We use RFC 822 instead of RFC 1123 to convert from string because NSDateFormatter can parse
         both 2-digit and 4-digit year correctly when `dateFormat` year is 2-digit.
         
         These values are sorted by frequency.
         */
        fileprivate static let parsingCases: [RFCStandards] = [.rfc822, .rfc850, .asctime, .rfc3339, .rfc3339Extended]
    }
    
    private static let posixLocale = Locale(identifier: "en_US_POSIX")
    private static let utcTimezone = TimeZone(identifier: "UTC")
    
    /// Checks date string against various RFC standards and returns `Date`.
    public init?(rfcString: String) {
        let dateFor: DateFormatter = DateFormatter()
        dateFor.locale = Date.posixLocale
        
        for standard in RFCStandards.parsingCases {
            dateFor.dateFormat = standard.rawValue
            if let date = dateFor.date(from: rfcString) {
                self = date
                return
            }
        }
        
        return nil
    }
    
    /// Formats date according to RFCs standard.
    /// - Note: local and timezone paramters should be nil for `.http` standard
    internal func format(with standard: RFCStandards, locale: Locale? = nil, timeZone: TimeZone? = nil) -> String {
        let fm = DateFormatter()
        fm.dateFormat = standard.rawValue
        fm.timeZone = timeZone ?? Date.utcTimezone
        fm.locale = locale ?? Date.posixLocale
        return fm.string(from: self)
    }
}

extension InputStream {
    func readData(ofLength length: Int) throws -> Data {
        var data = Data(count: length)
        #if swift(>=5.0)
        let result = data.withUnsafeMutableBytes { (buf) -> Int in
            let p = buf.bindMemory(to: UInt8.self).baseAddress!
            return self.read(p, maxLength: buf.count)
        }
        #else
        let bufcount = data.count
        let result = data.withUnsafeMutableBytes { (p) -> Int in
            return self.read(p, maxLength: bufcount)
        }
        #endif
        if result < 0 {
            throw self.streamError ?? POSIXError(.EIO)
        } else {
            data.count = result
            return data
        }
    }
}

extension OutputStream {
    func write(data: Data) throws -> Int {
        #if swift(>=5.0)
        let result = data.withUnsafeBytes { (buf) -> Int in
            let p = buf.bindMemory(to: UInt8.self).baseAddress!
            return self.write(p, maxLength: buf.count)
        }
        #else
        let bufcount = data.count
        let result = data.withUnsafeBytes { (p) -> Int in
            return self.write(p, maxLength: bufcount)
        }
        #endif
        if result < 0 {
            throw self.streamError ?? POSIXError(.EIO)
        } else {
            return result
        }
    }
}


internal extension NSPredicate {
    func findValue(forKey key: String?, operator op: NSComparisonPredicate.Operator? = nil) -> Any? {
        let val = findAllValues(forKey: key).lazy.filter { (op == nil || $0.operator == op!) && !$0.not }
        return val.first?.value
    }
    
    func findAllValues(forKey key: String?) -> [(value: Any, operator: NSComparisonPredicate.Operator, not: Bool)] {
        if let cQuery = self as? NSCompoundPredicate {
            let find = cQuery.subpredicates.flatMap { ($0 as! NSPredicate).findAllValues(forKey: key) }
            if cQuery.compoundPredicateType == .not {
                return find.map { return ($0.value, $0.operator, !$0.not) }
            }
            return find
        } else if let cQuery = self as? NSComparisonPredicate {
            if cQuery.leftExpression.expressionType == .keyPath, key == nil || cQuery.leftExpression.keyPath == key!, let const = cQuery.rightExpression.constantValue {
                return [(value: const, operator: cQuery.predicateOperatorType, false)]
            }
            if cQuery.rightExpression.expressionType == .keyPath, key == nil || cQuery.rightExpression.keyPath == key!, let const = cQuery.leftExpression.constantValue {
                return [(value: const, operator: cQuery.predicateOperatorType, false)]
            }
            return []
        } else {
            return []
        }
    }
}

func ~=<T>(pattern: (T) -> Bool, value: T) -> Bool {
    return pattern(value)
}

func hasPrefix(_ prefix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasPrefix(prefix)
    }
}

func hasSuffix(_ suffix: String) -> (_ value: String) -> Bool {
    return { (value: String) -> Bool in
        value.hasSuffix(suffix)
    }
}

// Legacy Swift versions support

#if swift(>=4.0)
#else
extension String {
    var count: Int {
        return self.characters.count
    }
}
#endif

#if swift(>=4.1)
#else
extension Array {
    func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
        return try self.flatMap(transform)
    }
}

extension ArraySlice {
    func compactMap<ElementOfResult>(_ transform: (Element) throws -> ElementOfResult?) rethrows -> [ElementOfResult] {
        return try self.flatMap(transform)
    }
}
#endif

// MARK: - FPSynchronizedArray
/// A thread-safe array.
public class FPSynchronizedArray<Element> {
    fileprivate let queue = DispatchQueue(label: "FPSynchronizedArray", attributes: .concurrent)
    fileprivate var array = [Element]()
    
    public init(array: [Element] = [Element]()) {
        self.array = array
    }
}

public extension FPSynchronizedArray {
    
    /// The first element of the collection.
    var first: Element? {
        var result: Element?
        queue.sync { result = self.array.first }
        return result
    }
    
    /// The last element of the collection.
    var last: Element? {
        var result: Element?
        queue.sync { result = self.array.last }
        return result
    }
    
    /// The number of elements in the array.
    var count: Int {
        var result = 0
        queue.sync { result = self.array.count }
        return result
    }
    
    /// A Boolean value indicating whether the collection is empty.
    var isEmpty: Bool {
        var result = false
        queue.sync { result = self.array.isEmpty }
        return result
    }
    
    /// A textual representation of the array and its elements.
    var description: String {
        var result = ""
        queue.sync { result = self.array.description }
        return result
    }
}

// MARK: - Immutable
public extension FPSynchronizedArray {
    /// Returns the first element of the sequence that satisfies the given predicate or nil if no such element is found.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element is a match.
    /// - Returns: The first match or nil if there was no match.
    func first(where predicate: (Element) -> Bool) -> Element? {
        var result: Element?
        queue.sync { result = self.array.first(where: predicate) }
        return result
    }
    
    /// Returns an array containing, in order, the elements of the sequence that satisfy the given predicate.
    ///
    /// - Parameter isIncluded: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element should be included in the returned array.
    /// - Returns: An array of the elements that includeElement allowed.
    func filter(_ isIncluded: (Element) -> Bool) -> [Element] {
        var result = [Element]()
        queue.sync { result = self.array.filter(isIncluded) }
        return result
    }
    
    /// Returns the first index in which an element of the collection satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    /// - Returns: The index of the first element for which predicate returns true. If no elements in the collection satisfy the given predicate, returns nil.
    func index(where predicate: (Element) -> Bool) -> Int? {
        var result: Int?
        queue.sync { result = self.array.firstIndex(where: predicate) }
        return result
    }
    
    /// Returns the elements of the collection, sorted using the given predicate as the comparison between elements.
    ///
    /// - Parameter areInIncreasingOrder: A predicate that returns true if its first argument should be ordered before its second argument; otherwise, false.
    /// - Returns: A sorted array of the collection’s elements.
    func sorted(by areInIncreasingOrder: (Element, Element) -> Bool) -> [Element] {
        var result = [Element]()
        queue.sync { result = self.array.sorted(by: areInIncreasingOrder) }
        return result
    }
    
    /// Returns an array containing the non-nil results of calling the given transformation with each element of this sequence.
    ///
    /// - Parameter transform: A closure that accepts an element of this sequence as its argument and returns an optional value.
    /// - Returns: An array of the non-nil results of calling transform with each element of the sequence.
    func flatMap<ElementOfResult>(_ transform: (Element) -> ElementOfResult?) -> [ElementOfResult] {
        var result = [ElementOfResult]()
        queue.sync { result = self.array.flatMap(transform) }
        return result
    }
    
    /// Calls the given closure on each element in the sequence in the same order as a for-in loop.
    ///
    /// - Parameter body: A closure that takes an element of the sequence as a parameter.
    func forEach(_ body: (Element) -> Void) {
        queue.sync { self.array.forEach(body) }
    }
    
    /// Returns a Boolean value indicating whether the sequence contains an element that satisfies the given predicate.
    ///
    /// - Parameter predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value that indicates whether the passed element represents a match.
    /// - Returns: true if the sequence contains an element that satisfies predicate; otherwise, false.
    func contains(where predicate: (Element) -> Bool) -> Bool {
        var result = false
        queue.sync { result = self.array.contains(where: predicate) }
        return result
    }
}

// MARK: - Mutable
public extension FPSynchronizedArray {
    
    /// Adds a new element at the end of the array.
    ///
    /// - Parameter element: The element to append to the array.
    func append( _ element: Element) {
        queue.async(flags: .barrier) {
            self.array.append(element)
        }
    }
    
    /// Adds a new element at the end of the array.
    ///
    /// - Parameter element: The element to append to the array.
    func append( _ elements: [Element]) {
        queue.async(flags: .barrier) {
            self.array += elements
        }
    }
    
    /// Inserts a new element at the specified position.
    ///
    /// - Parameters:
    ///   - element: The new element to insert into the array.
    ///   - index: The position at which to insert the new element.
    func insert( _ element: Element, at index: Int) {
        queue.async(flags: .barrier) {
            self.array.insert(element, at: index)
        }
    }
    
    /// Removes and returns the element at the specified position.
    ///
    /// - Parameters:
    ///   - index: The position of the element to remove.
    ///   - completion: The handler with the removed element.
    func remove(at index: Int, completion: ((Element) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let element = self.array.remove(at: index)
            
            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }
    
    /// Removes and returns the element at the specified position.
    ///
    /// - Parameters:
    ///   - predicate: A closure that takes an element of the sequence as its argument and returns a Boolean value indicating whether the element is a match.
    ///   - completion: The handler with the removed element.
    func remove(where predicate: @escaping (Element) -> Bool, completion: ((Element) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            guard let index = self.array.firstIndex(where: predicate) else { return }
            let element = self.array.remove(at: index)
            
            DispatchQueue.main.async {
                completion?(element)
            }
        }
    }
    
    /// Removes all elements from the array.
    ///
    /// - Parameter completion: The handler with the removed elements.
    func removeAll(completion: (([Element]) -> Void)? = nil) {
        queue.async(flags: .barrier) {
            let elements = self.array
            self.array.removeAll()
            
            DispatchQueue.main.async {
                completion?(elements)
            }
        }
    }
}

public extension FPSynchronizedArray {
    
    /// Accesses the element at the specified position if it exists.
    ///
    /// - Parameter index: The position of the element to access.
    /// - Returns: optional element if it exists.
    subscript(index: Int) -> Element? {
        get {
            var result: Element?
            
            queue.sync {
                guard self.array.startIndex..<self.array.endIndex ~= index else { return }
                result = self.array[index]
            }
            
            return result
        }
        set {
            guard let newValue = newValue else { return }
            
            queue.async(flags: .barrier) {
                self.array[index] = newValue
            }
        }
    }
}


// MARK: - Equatable
public extension FPSynchronizedArray where Element: Equatable {
    
    /// Returns a Boolean value indicating whether the sequence contains the given element.
    ///
    /// - Parameter element: The element to find in the sequence.
    /// - Returns: true if the element was found in the sequence; otherwise, false.
    func contains(_ element: Element) -> Bool {
        var result = false
        queue.sync { result = self.array.contains(element) }
        return result
    }
}

// MARK: - Infix operators
public extension FPSynchronizedArray {
    
    static func +=(left: inout FPSynchronizedArray, right: Element) {
        left.append(right)
    }
    
    static func +=(left: inout FPSynchronizedArray, right: [Element]) {
        left.append(right)
    }
}

// MARK: - FPSynchronizedDictionary

public class FPSynchronizedDictionary<V: Hashable, T>: Collection {
    
    private var dictionary: [V: T]
    private let queue = DispatchQueue(label: "FPSynchronizedDictionary", attributes: .concurrent)
    
    public var startIndex: Dictionary<V, T>.Index {
        self.queue.sync {
            return self.dictionary.startIndex
        }
    }
    
    public var endIndex: Dictionary<V, T>.Index {
        self.queue.sync {
            return self.dictionary.endIndex
        }
    }
    
    public init(dict: [V: T] = [V:T]()) {
        self.dictionary = dict
    }
    // this is because it is an apple protocol method
    // swiftlint:disable identifier_name
    public func index(after i: Dictionary<V, T>.Index) -> Dictionary<V, T>.Index {
        self.queue.sync {
            return self.dictionary.index(after: i)
        }
    }
    // swiftlint:enable identifier_name
    
    public subscript(key: V) -> T? {
        set(newValue) {
            self.queue.async(flags: .barrier) { [weak self] in
                self?.dictionary[key] = newValue
            }
        }
        get {
            self.queue.sync {
                return self.dictionary[key]
            }
        }
    }
    
    // has implicity get
    public subscript(index: Dictionary<V, T>.Index) -> Dictionary<V, T>.Element {
        self.queue.sync {
            return self.dictionary[index]
        }
    }
    
    public func removeValue(forKey key: V) {
        self.queue.async(flags: .barrier) { [weak self] in
            self?.dictionary.removeValue(forKey: key)
        }
    }
    
    public func removeAll() {
        self.queue.async(flags: .barrier) { [weak self] in
            self?.dictionary.removeAll()
        }
    }
}
