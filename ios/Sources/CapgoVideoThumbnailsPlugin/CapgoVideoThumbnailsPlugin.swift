import Foundation
import Capacitor
import AVFoundation
import UIKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CapgoVideoThumbnailsPlugin)
public class CapgoVideoThumbnailsPlugin: CAPPlugin, CAPBridgedPlugin {
    private let pluginVersion: String = "8.1.6"
    public let identifier = "CapgoVideoThumbnailsPlugin"
    public let jsName = "CapgoVideoThumbnails"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "getThumbnail", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getPluginVersion", returnType: CAPPluginReturnPromise)
    ]

    @objc func getThumbnail(_ call: CAPPluginCall) {
        guard let sourceUri = call.getString("sourceUri") else {
            call.reject("sourceUri is required")
            return
        }

        let time = call.getDouble("time") ?? 0
        let quality = call.getDouble("quality") ?? 1.0
        let headers = call.getObject("headers") as? [String: String]

        DispatchQueue.global(qos: .userInitiated).async {
            self.generateThumbnail(sourceUri: sourceUri, time: time, quality: quality, headers: headers) { result in
                switch result {
                case .success(let thumbnailResult):
                    call.resolve(thumbnailResult)
                case .failure(let error):
                    call.reject(error.localizedDescription)
                }
            }
        }
    }

    private func generateThumbnail(
        sourceUri: String,
        time: Double,
        quality: Double,
        headers: [String: String]?,
        completion: @escaping (Result<[String: Any], Error>) -> Void
    ) {
        var asset: AVAsset

        if sourceUri.hasPrefix("http://") || sourceUri.hasPrefix("https://") {
            guard let url = URL(string: sourceUri) else {
                completion(.failure(NSError(domain: "CapgoVideoThumbnails", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL: \(sourceUri)"])))
                return
            }

            if let headers = headers, !headers.isEmpty {
                var urlRequest = URLRequest(url: url)
                for (key, value) in headers {
                    urlRequest.setValue(value, forHTTPHeaderField: key)
                }
                asset = AVURLAsset(url: url, options: ["AVURLAssetHTTPHeaderFieldsKey": headers])
            } else {
                asset = AVURLAsset(url: url)
            }
        } else {
            // Handle local file paths
            var fileUrl: URL
            if sourceUri.hasPrefix("file://") {
                guard let url = URL(string: sourceUri) else {
                    completion(.failure(NSError(domain: "CapgoVideoThumbnails", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid file URL: \(sourceUri)"])))
                    return
                }
                fileUrl = url
            } else {
                fileUrl = URL(fileURLWithPath: sourceUri)
            }

            guard FileManager.default.fileExists(atPath: fileUrl.path) else {
                completion(.failure(NSError(domain: "CapgoVideoThumbnails", code: 2, userInfo: [NSLocalizedDescriptionKey: "File does not exist: \(sourceUri)"])))
                return
            }

            asset = AVURLAsset(url: fileUrl)
        }

        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.requestedTimeToleranceAfter = .zero
        imageGenerator.requestedTimeToleranceBefore = .zero

        // Convert milliseconds to CMTime
        let timeInSeconds = time / 1000.0
        let cmTime = CMTime(seconds: timeInSeconds, preferredTimescale: 600)

        do {
            let cgImage = try imageGenerator.copyCGImage(at: cmTime, actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)

            // Save to temporary file
            guard let imageData = uiImage.jpegData(compressionQuality: CGFloat(quality)) else {
                completion(.failure(NSError(domain: "CapgoVideoThumbnails", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to JPEG"])))
                return
            }

            let tempDir = FileManager.default.temporaryDirectory
            let fileName = "thumbnail_\(UUID().uuidString).jpg"
            let fileUrl = tempDir.appendingPathComponent(fileName)

            try imageData.write(to: fileUrl)

            let result: [String: Any] = [
                "uri": fileUrl.absoluteString,
                "width": cgImage.width,
                "height": cgImage.height
            ]

            DispatchQueue.main.async {
                completion(.success(result))
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(NSError(domain: "CapgoVideoThumbnails", code: 4, userInfo: [NSLocalizedDescriptionKey: "Failed to generate thumbnail: \(error.localizedDescription)"])))
            }
        }
    }

    @objc func getPluginVersion(_ call: CAPPluginCall) {
        call.resolve(["version": self.pluginVersion])
    }
}
