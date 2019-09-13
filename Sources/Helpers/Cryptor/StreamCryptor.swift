//
//  StreamCryptor.swift
//  Cryptor
//
// 	Licensed under the Apache License, Version 2.0 (the "License");
// 	you may not use this file except in compliance with the License.
// 	You may obtain a copy of the License at
//
// 	http://www.apache.org/licenses/LICENSE-2.0
//
// 	Unless required by applicable law or agreed to in writing, software
// 	distributed under the License is distributed on an "AS IS" BASIS,
// 	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 	See the License for the specific language governing permissions and
// 	limitations under the License.
//

import Foundation
import CommonCrypto

///
/// Encrypts or decrypts return results as they become available.
///
/// - Note: The underlying cipher may be a block or a stream cipher.
///
///   Use for large files or network streams.
///
///   For small, in-memory buffers Cryptor may be easier to use.
///
public class StreamCryptor {
	
    ///
    /// Enumerates Cryptor operations
    ///
    public enum Operation {

		/// Encrypting
        case encrypt
		
		/// Decrypting
        case decrypt


        /// Convert to native `CCOperation`
        func nativeValue() -> CCOperation {

            switch self {

            case .encrypt:
                return CCOperation(kCCEncrypt)

            case .decrypt:
                return CCOperation(kCCDecrypt)
            }
        }
    }
	
    ///
	/// Enumerates valid key sizes.
	///
    public enum ValidKeySize {
		
        case fixed(Int)
        case discrete([Int])
        case range(Int, Int)
        
        ///
		///	Determines if a given `keySize` is valid for this algorithm.
		///
		/// - Parameter keySize: The size to test for validity.
		///
		/// - Returns: True if valid, false otherwise.
		///
        func isValidKeySize(keySize: Int) -> Bool {
			
            switch self {
				
            case .fixed(let fixed):
				return (fixed == keySize)
				
            case .range(let min, let max):
				return ((keySize >= min) && (keySize <= max))
				
            case .discrete(let values):
				return values.contains(keySize)
            }
        }
        
        ///
		///	Determines the next valid key size; that is, the first valid key size larger
		///	than the given value.
		///
		/// - Parameter keySize: The size for which the `next` size is desired.
		///
		/// - Returns: Will return `nil` if the passed in `keySize` is greater than the max.
        ///
        func paddedKeySize(keySize: Int) -> Int? {
			
            switch self {
				
            case .fixed(let fixed):
                return (keySize <= fixed) ? fixed : nil
				
            case .range(let min, let max):
                return (keySize > max) ? nil : ((keySize < min) ? min : keySize)
				
			case .discrete(let values):
                return values.sorted().reduce(nil) { answer, current in
                    return answer ?? ((current >= keySize) ? current : nil)
                }
            }
        }
        
        
    }
	
	///
	/// Maps CommonCryptoOptions onto a Swift struct.
	///
	public struct Options: OptionSet {
		
		public typealias RawValue = Int
		public let rawValue: RawValue
		
		/// Convert from a native value (i.e. `0`, `kCCOptionpkcs7Padding`, `kCCOptionECBMode`)
		public init(rawValue: RawValue) {
			self.rawValue = rawValue
		}
		
		/// Convert from a native value (i.e. `0`, `kCCOptionpkcs7Padding`, `kCCOptionECBMode`)
		public init(_ rawValue: RawValue) {
			self.init(rawValue: rawValue)
		}
		
		/// No options
		public static let none = Options(rawValue: 0)

        /// Use padding. Needed unless the input is a integral number of blocks long.
        public static var pkcs7Padding =  Options(rawValue:kCCOptionPKCS7Padding)

        /// Electronic Code Book Mode. Don't use this.
        public static var ecbMode = Options(rawValue:kCCOptionECBMode)
	}
	
    ///
    /// Enumerates available algorithms
    ///
    public enum Algorithm {

        /// Advanced Encryption Standard
        /// - Note: aes and aes128 are equivalent.
        case aes, aes128, aes192, aes256

        /// Data Encryption Standard
        case des

        /// Triple des
        case tripleDes

        /// cast
        case cast

        /// rc2
        case rc2

        /// blowfish
        case blowfish

        /// Blocksize, in bytes, of algorithm.
		public var blockSize: Int {
			
            switch self {
				
            case .aes, .aes128, .aes192, .aes256:
				return kCCBlockSizeAES128
				
            case .des:
				return kCCBlockSizeDES
				
            case .tripleDes:
				return kCCBlockSize3DES
				
            case .cast:
				return kCCBlockSizeCAST
				
            case .rc2:
				return kCCBlockSizeRC2
				
            case .blowfish:
				return kCCBlockSizeBlowfish
            }
        }
		
		public var defaultKeySize: Int {
			
			switch self {
				
			case .aes, .aes128:
				return kCCKeySizeAES128
				
			case .aes192:
				return kCCKeySizeAES192
				
			case .aes256:
				return kCCKeySizeAES256
				
			case .des:
				return kCCKeySizeDES
				
			case .tripleDes:
				return kCCKeySize3DES
				
			case .cast:
				return kCCKeySizeMinCAST
				
			case .rc2:
				return kCCKeySizeMinRC2
				
			case .blowfish:
				return kCCKeySizeMinBlowfish
			}
		}


        /// Native, CommonCrypto constant for algorithm.
        func nativeValue() -> CCAlgorithm {

            switch self {

            case .aes, .aes128, .aes192, .aes256:
                return CCAlgorithm(kCCAlgorithmAES)

            case .des:
                return CCAlgorithm(kCCAlgorithmDES)

            case .tripleDes:
                return CCAlgorithm(kCCAlgorithm3DES)

            case .cast:
                return CCAlgorithm(kCCAlgorithmCAST)

            case .rc2:
                return CCAlgorithm(kCCAlgorithmRC2)

            case .blowfish:
                return CCAlgorithm(kCCAlgorithmBlowfish)
            }
        }
		
		///
        /// Determines the valid key size for this algorithm
		///
		/// - Returns: Valid key size for this algorithm.
		///
        func validKeySize() -> ValidKeySize {
			
            switch self {

            case .aes, .aes128, .aes192, .aes256:
                return .discrete([kCCKeySizeAES128, kCCKeySizeAES192, kCCKeySizeAES256])

            case .des:
                return .fixed(kCCKeySizeDES)

            case .tripleDes:
                return .fixed(kCCKeySize3DES)

            case .cast:
                return .range(kCCKeySizeMinCAST, kCCKeySizeMaxCAST)

            case .rc2:
                return .range(kCCKeySizeMinRC2, kCCKeySizeMaxRC2)

            case .blowfish:
                return .range(kCCKeySizeMinBlowfish, kCCKeySizeMaxBlowfish)
            }
        }
		
		///
        /// Tests if a given keySize is valid for this algorithm
		///
		/// - Parameter keySize: The key size to be validated.
		///
		/// - Returns: True if valid, false otherwise.
		///
        func isValidKeySize(keySize: Int) -> Bool {
            return self.validKeySize().isValidKeySize(keySize: keySize)
        }
		
		///
        /// Calculates the next, if any, valid keySize greater or equal to a given `keySize` for this algorithm
		///
		/// - Parameter keySize: Key size for which the next size is requested.
		///
		/// - Returns: Next key size or nil
		///
        func paddedKeySize(keySize: Int) -> Int? {
            return self.validKeySize().paddedKeySize(keySize: keySize)
        }
    }
	
    ///
    /// The status code resulting from the last method call to this Cryptor.
    ///    Used to get additional information when optional chaining collapes.
	///
    public internal(set) var status: Status = .success
	
	///
	/// Context obtained. True if we have it, false otherwise.
	///
	private var haveContext: Bool = false


    /// CommonCrypto Context
    private var context = UnsafeMutablePointer<CCCryptorRef?>.allocate(capacity: 1)
	
	
	// MARK: Lifecycle Methods
	
	///
	///	Default Initializer
	///
	/// - Parameters: 
	///		- operation: 	The operation to perform see Operation (Encrypt, Decrypt)
	/// 	- algorithm: 	The algorithm to use see Algorithm (AES, des, tripleDes, cast, rc2, blowfish)
	/// 	- keyBuffer: 	Pointer to key buffer
	/// 	- keyByteCount: Number of bytes in the key
	/// 	- ivBuffer: 	Initialization vector buffer
	///		- ivLength:		Length of the ivBuffer
	///
	/// - Returns: New StreamCryptor instance.
	///
	public init(operation: Operation, algorithm: Algorithm, options: Options, keyBuffer: [UInt8], keyByteCount: Int, ivBuffer: UnsafePointer<UInt8>, ivLength: Int = 0) throws {
		
		guard algorithm.isValidKeySize(keySize: keyByteCount) else {
			throw CryptorError.invalidKeySize
		}
		
		guard options.contains(.ecbMode) || ivLength == algorithm.blockSize else {
			throw CryptorError.invalidIVSizeOrLength
		}
		


        let rawStatus = CCCryptorCreate(operation.nativeValue(), algorithm.nativeValue(), CCOptions(options.rawValue), keyBuffer, keyByteCount, ivBuffer, self.context)

        if let status = Status.fromRaw(status: rawStatus) {

            self.status = status

        } else {

            throw CryptorError.fail(rawStatus, "Cryptor init returned unexpected status.")
        }

        self.haveContext = true
		
	}
	
    ///
	///	Creates a new StreamCryptor
	///
	/// - Parameters:
 	///		- operation: 	The operation to perform see Operation (Encrypt, Decrypt)
	///		- algorithm: 	The algorithm to use see Algorithm (AES, des, tripleDes, cast, rc2, blowfish)
	///		- key: 			A byte array containing key data
	///		- iv: 			A byte array containing initialization vector
    ///
	/// - Returns: New StreamCryptor instance.
	///
	public convenience init(operation: Operation, algorithm: Algorithm, options: Options, key: [UInt8], iv: [UInt8]) throws {
		
        guard let paddedKeySize = algorithm.paddedKeySize(keySize: key.count) else {
			throw CryptorError.invalidKeySize
        }
        
        try self.init(operation:operation,
                  algorithm:algorithm,
                  options:options,
                  keyBuffer:CryptoUtils.zeroPad(byteArray:key, blockSize: paddedKeySize),
                  keyByteCount:paddedKeySize,
                  ivBuffer:iv,
                  ivLength:iv.count)
    }
	
    ///
	/// Creates a new StreamCryptor
	///
	/// - Parameters:
 	///		- operation: 	The operation to perform see Operation (Encrypt, Decrypt)
	///		- algorithm: 	The algorithm to use see Algorithm (AES, des, tripleDes, cast, rc2, blowfish)
	///		- key: 			A string containing key data (will be interpreted as UTF8)
	///		- iv: 			A string containing initialization vector data (will be interpreted as UTF8)
    ///
	/// - Returns: New StreamCryptor instance.
	///
	public convenience init(operation: Operation, algorithm: Algorithm, options: Options, key: String, iv: String) throws {
		
        let keySize = key.utf8.count
        guard let paddedKeySize = algorithm.paddedKeySize(keySize: keySize) else {
			throw CryptorError.invalidKeySize
        }
        
        try self.init(operation:operation,
                  algorithm:algorithm,
                  options:options,
                  keyBuffer:CryptoUtils.zeroPad(string: key, blockSize: paddedKeySize),
                  keyByteCount:paddedKeySize,
                  ivBuffer:iv,
                  ivLength:iv.utf8.count)
    }
	
	///
	/// Cleanup
	///
	deinit {
		
		// Ensure we've got a context before attempting to get rid of it...
		if self.haveContext == false {
			return
		}

        // Ensure we've got a context before attempting to get rid of it...
        if self.context.pointee == nil {
            return
        }

        let rawStatus = CCCryptorRelease(self.context.pointee)
        if let status = Status.fromRaw(status: rawStatus) {

            if status != .success {

                NSLog("WARNING: CCCryptoRelease failed with status \(rawStatus).")
            }

        } else {

            fatalError("CCCryptorUpdate returned unexpected status.")
        }

        #if swift(>=4.1)
        context.deallocate()
        #else
        context.deallocate(capacity: 1)
        #endif

        self.haveContext = false
	}
	
	// MARK: Public Methods
	
	///
	///	Add the contents of an Data buffer to the current encryption/decryption operation.
	///
	/// - Parameters:
	///		- dataIn: 		The input data
	///		- byteArrayOut: Output data
	///
	/// - Returns: A tuple containing the number of output bytes produced and the status (see Status)
	///
	public func update(dataIn: Data, byteArrayOut: inout [UInt8]) -> (Int, Status) {
		
		let dataOutAvailable = byteArrayOut.count
		var dataOutMoved = 0
		#if swift(>=5.0)
			dataIn.withUnsafeBytes() { 
				_ = update(bufferIn: $0.baseAddress!, byteCountIn: dataIn.count, bufferOut: &byteArrayOut, byteCapacityOut: dataOutAvailable, byteCountOut: &dataOutMoved)
			}
		#else
			dataIn.withUnsafeBytes() { (buffer: UnsafePointer<UInt8>) in
				_ = update(bufferIn: buffer, byteCountIn: dataIn.count, bufferOut: &byteArrayOut, byteCapacityOut: dataOutAvailable, byteCountOut: &dataOutMoved)
			}
		#endif
		return (dataOutMoved, self.status)
	}
	
    ///
	///	Add the contents of an NSData buffer to the current encryption/decryption operation.
    ///
	/// - Parameters:
 	///		- dataIn: 		The input data
	///		- byteArrayOut: Output data
	///
	/// - Returns: A tuple containing the number of output bytes produced and the status (see Status)
    ///
	public func update(dataIn: NSData, byteArrayOut: inout [UInt8]) -> (Int, Status) {
		
        let dataOutAvailable = byteArrayOut.count
        var dataOutMoved = 0
		var ptr = dataIn.bytes.assumingMemoryBound(to: UInt8.self).pointee
        _ = update(bufferIn: &ptr, byteCountIn: dataIn.length, bufferOut: &byteArrayOut, byteCapacityOut: dataOutAvailable, byteCountOut: &dataOutMoved)
        return (dataOutMoved, self.status)
    }
	
    ///
	///	Add the contents of a byte array to the current encryption/decryption operation.
	///
	/// - Parameters:
 	///		- byteArrayIn: 	The input data
	///		- byteArrayOut: Output data
	///
	/// - Returns: A tuple containing the number of output bytes produced and the status (see Status)
    ///
	public func update(byteArrayIn: [UInt8], byteArrayOut: inout [UInt8]) -> (Int, Status) {
		
        let dataOutAvailable = byteArrayOut.count
        var dataOutMoved = 0
        _ = update(bufferIn: byteArrayIn, byteCountIn: byteArrayIn.count, bufferOut: &byteArrayOut, byteCapacityOut: dataOutAvailable, byteCountOut: &dataOutMoved)
        return (dataOutMoved, self.status)
    }
	
    ///
	///	Add the contents of a string (interpreted as UTF8) to the current encryption/decryption operation.
	///
    /// - Parameters:
 	///		- byteArrayIn: 	The input data
	///		- byteArrayOut:	Output data
	///
	/// - Returns: A tuple containing the number of output bytes produced and the status (see Status)
    ///
	public func update(stringIn: String, byteArrayOut: inout [UInt8]) -> (Int, Status) {
		
        let dataOutAvailable = byteArrayOut.count
        var dataOutMoved = 0
        _ = update(bufferIn: stringIn, byteCountIn: stringIn.utf8.count, bufferOut: &byteArrayOut, byteCapacityOut: dataOutAvailable, byteCountOut: &dataOutMoved)
        return (dataOutMoved, self.status)
    }
	
    ///
	///	Retrieves all remaining encrypted or decrypted data from this cryptor.
	///
	/// - Note: If the underlying algorithm is an block cipher and the padding option has
	/// not been specified and the cumulative input to the cryptor has not been an integral
	///	multiple of the block length this will fail with an alignment error.
	///
	/// - Note: This method updates the status property
	///
	/// - Parameter byteArrayOut: The output bffer
	///
	/// - Returns: a tuple containing the number of output bytes produced and the status (see Status)
    ///
	public func final(byteArrayOut: inout [UInt8]) -> (Int, Status) {
		
        let dataOutAvailable = byteArrayOut.count
        var dataOutMoved = 0
        _ = final(bufferOut: &byteArrayOut, byteCapacityOut: dataOutAvailable, byteCountOut: &dataOutMoved)
        return (dataOutMoved, self.status)
    }
    
    // MARK: - Low-level interface
	
    ///
	///	Update the buffer
	///
	/// - Parameters:
	///		- bufferIn: 		Pointer to input buffer
	///		- inByteCount: 		Number of bytes contained in input buffer
	///		- bufferOut: 		Pointer to output buffer
	///		- outByteCapacity: 	Capacity of the output buffer in bytes
	///		- outByteCount: 	On successful completion, the number of bytes written to the output buffer
	///
	/// - Returns: Status of the update
	///
	public func update(bufferIn: UnsafeRawPointer, byteCountIn: Int, bufferOut: UnsafeMutablePointer<UInt8>, byteCapacityOut: Int, byteCountOut: inout Int) -> Status {
		
        if self.status == .success {

            let rawStatus = CCCryptorUpdate(self.context.pointee, bufferIn, byteCountIn, bufferOut, byteCapacityOut, &byteCountOut)
            if let status = Status.fromRaw(status: rawStatus) {
                self.status =  status
            } else {
                fatalError("CCCryptorUpdate returned unexpected status.")
            }

        }
		
        return self.status
    }
	
    ///
	///	Retrieves all remaining encrypted or decrypted data from this cryptor.
	///
	/// - Note: If the underlying algorithm is an block cipher and the padding option has
	///	not been specified and the cumulative input to the cryptor has not been an integral
	///	multiple of the block length this will fail with an alignment error.
    ///
	/// - Note: This method updates the status property
	///
	/// - Parameters:
 	///		- bufferOut: 		Pointer to output buffer
	///		- outByteCapacity: 	Capacity of the output buffer in bytes
	///		- outByteCount: 	On successful completion, the number of bytes written to the output buffer
	///
	/// - Returns: Status of the update
	///
	public func final(bufferOut: UnsafeMutablePointer<UInt8>, byteCapacityOut: Int, byteCountOut: inout Int) -> Status {
		
		if self.status == Status.success {

            let rawStatus = CCCryptorFinal(self.context.pointee, bufferOut, byteCapacityOut, &byteCountOut)
            if let status = Status.fromRaw(status: rawStatus) {
                self.status =  status
            } else {
                fatalError("CCCryptorUpdate returned unexpected status.")
            }
        }
		
        return self.status
    }
	
    ///
	///	Determines the number of bytes that will be output by this Cryptor if inputBytes of additional
	///	data is input.
	///
	/// - Parameters:
 	///		- inputByteCount: 	Number of bytes that will be input.
	///		- isFinal: 			True if buffer to be input will be the last input buffer, false otherwise.
	///
	/// - Returns: The final output length
	///
	public func getOutputLength(inputByteCount: Int, isFinal: Bool = false) -> Int {
        return CCCryptorGetOutputLength(self.context.pointee, inputByteCount, isFinal)
    }
	
}
