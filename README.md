# Flickr-App
A simple, fun &amp; creative way show images that people share with the world.
# Features 
- Application Connects to Flicker API and Display an infinity list of photo.
- When scroll to the end of the list it will send another request to get more photos.
- Application have the feature to configure and check for the network connection.
- Application can search for all popular images and also have their description.
- If application have no connection to internet it will retrieve images from cached locally .
- Application is able to run in all iPhone Layouts and orientations .
- Application have the ability to run in different languages cause it have all localization needed(EN - AR).

# Requirements
- Xcode 11.4
- Not that API Key may be changed after a period of time if that happen you  just cahnge "apiKey" in  Constants file  in the Project .

# Used 3rd Party Library
- Realm Mobile DB (https://github.com/realm/realm-cocoa )
- SDWebImage (to render Images : https://github.com/rs/SDWebImage)
- AFNetworking (to send requests and handle : https://github.com/AFNetworking/AFNetworking)
