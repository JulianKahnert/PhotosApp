# LazyVStack Example

This example app shows all images from your Photos library.
It uses a `LazyVStack` in `ScrollView`. The images are grouped by day:

```swift
ScrollView {
    LazyVStack {
        ForEach(Array(groupedAssets.keys.sorted().reversed()), id: \.self) { key in
            Section(header: Text(key)) {
                WrappedPhotoLayout(assets: groupedAssets[key, default: []])
             }
        }
    }
}
```

## Problem

The `LibImage`s in the `LazyVStack` will not be released.
In the `LibImage.RefrenceTest` the `deinit` will not be called.

```swift
deinit {
    // this should be called when the view gets released, right!?
    print("Releasing view with asset id: \(id)")
}
```


## Steps to reproduce

* Change Team to your Apple Developer Account 
* Install the App
* Open App and Allow Access (you might have to restart the app)
* Scroll around => images will be reloaded 
* have a look at the memory graph => memory usage does not increase continuously

... but the deinit will not be called 🤔🧐   


## Requirements

* Operating System
    * iOS 14 (not tested yet)
    * iPadOS 14 (18A5301v)
    * macOS 11 (not tested yet)
