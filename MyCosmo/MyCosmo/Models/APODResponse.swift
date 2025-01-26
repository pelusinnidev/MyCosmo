import Foundation

/// APODResponse: A model representing NASA's Astronomy Picture of the Day (APOD)
/// This struct decodes the JSON response from NASA's APOD API
/// - Note: APOD is a daily service providing high-quality astronomy images with explanations
struct APODResponse: Codable {
    /// The date when the astronomy picture was featured
    let date: String
    
    /// Detailed explanation of the astronomical object or phenomenon
    let explanation: String
    
    /// Optional URL for the high-definition version of the image
    let hdurl: String?
    
    /// Type of media (usually "image" or "video")
    let mediaType: String
    
    /// Title of the astronomy picture
    let title: String
    
    /// URL of the standard resolution media
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case date
        case explanation
        case hdurl
        case mediaType = "media_type"
        case title
        case url
    }
}
