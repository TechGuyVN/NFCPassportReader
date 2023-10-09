//
//  NFCViewDisplayMessage.swift
//  NFCPassportReader
//
//  Created by Andy Qua on 09/02/2021.
//

import Foundation

@available(iOS 13, macOS 10.15, *)
public enum NFCViewDisplayMessage {
    case requestPresentPassport
    case authenticatingWithPassport(Int)
    case readingDataGroupProgress(DataGroupId, Int)
    case error(NFCPassportReaderError)
    case successfulRead
}

@available(iOS 13, macOS 10.15, *)
extension NFCViewDisplayMessage {
    public var description: String {
        switch self {
            case .requestPresentPassport:
                return "Giữ Iphone gần đầu đọc NFC..."
            case .authenticatingWithPassport(let progress):
                let progressString = handleProgress(percentualProgress: progress)
                return "Đang xác minh.....\n\n\(progressString)"
            case .readingDataGroupProgress(let dataGroup, let progress):
                let progressString = handleProgress(percentualProgress: progress)
                return "Đang đọc dữ liệu.....\n\n\(progressString)"
            case .error(let tagError):
                switch tagError {
                    case NFCPassportReaderError.TagNotValid:
                        return "Card không hợp lệ."
                    case NFCPassportReaderError.MoreThanOneTagFound:
                        return "More than 1 tags was found. Please present only 1 tag."
                    case NFCPassportReaderError.ConnectionError:
                        return "Kết nối bị lỗi, vui lòng thử lại."
                    case NFCPassportReaderError.InvalidMRZKey:
                        return "MRZ Key không hợp lệ cho CCCD này."
                    case NFCPassportReaderError.ResponseError(let description, let sw1, let sw2):
                        return "Có lỗi xảy ra khi đọc dữ liệu từ CCCD này vui lòng thử lại. \(description) - (0x\(sw1), 0x\(sw2)"
                    default:
                        return "Có lỗi xảy ra khi đọc dữ liệu từ CCCD này vui lòng thử lại"
                }
            case .successfulRead:
                return "Đọc Dữ liệu CCCD Thành công"
        }
    }
    
    func handleProgress(percentualProgress: Int) -> String {
        let p = (percentualProgress/20)
        let full = String(repeating: "🟢 ", count: p)
        let empty = String(repeating: "⚪️ ", count: 5-p)
        return "\(full)\(empty)"
    }
}
