## About apptics

Fastlane plugin for Apptics to handle store relates operations

## dSYM upload plugin

This plugin allows uploading the dSYM files automatically even for the bitcode-enabled apps. 

Setup the Xcode CLT using the 

```bash
xcode-select --install
```
* To install Fastlane on your Mac, follow the steps below.
* Open the terminal on your Mac.
*	Navigate to the project folder.

## You can install Fastlane using System Ruby and Ruby Gems (macOS/Linux/Windows) or Homebrew (macOS)

* Install the Fastlane using 'sudo gem install fastlane -NV'
* To confirm the Fastlane installation, use the 'fastlane -v' command.
* Go to the project's directory and run sudo fastlane init to create a gemfile and Fastlane directory in the project.
* You can now create custom lanes in your Fastlane. For more information, please visit https://docs.fastlane.tools/getting-started/ios/setup/

## Homebrew (macOS)
 	
  Using homebrew will install the correct Ruby version needed for Fastlane. For more information, please visit https://formulae.brew.sh/formula/fastlane 

```bash
brew install fastlane
```
## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-apptics`, add it to your project by running:

```bash
sudo fastlane add_plugin apptics
```

## Download dSYM using Fastlane
* To download the dSYM files from App Store Connect for bitcode-enabled apps, use the below command.

```bash
download_dsyms(app_identifier:"" ,version:"", build_number:"")
```
## Parameters
* app_identifier - The app bundle identifier for the dSYMs that you want to download.
* build_number - The app build_number for the dSYMs that you want to download.
* version - The app version for the dSYMs that you want to download.
## Example
The following environment variables maybe used in place of parameters:
app_identifier: com.zoho.apptics
build_number: 2.3
version: 2.7

```bash
download_dsyms(app_identifier: "com.zoho.apptics",version: "2.7",build_number: "2.3 ")
```
## Upload dSYM files to Apptics

Use the below to upload the dSYM files to Apptics.

```bash
upload_dsym_to_apptics(appversion:"",bundleid:"", dsymfilepath: "",modevalue:"", platformvalue:"" ,configfilepath:"",buildversion:"")
```
## Parameters
* appversion - The app version for the dSYMs that you want to download.
* bundleid - The bundle id for the dSYMs that you want to upload.
* dsymfilepath - Path to the dSYM file or zip to upload.
* modevalue - development or release (0 or 1).
* platformvalue - The app platform for the dSYMs that you want to upload (iOS,watchOS,macOS…).
* configfilepath - Path to the Config file (<PROJECT_PATH>/apptics-config.plist )

## Clean_build_artifacts

Use this action to delete files created as a result of running download_dsyms.

```bash
clean_build_artifacts
```
## Lane Setup

Add the below to the Fastlane/Fastfile.
```bash
default_platform(:ios)
platform :ios do
  desc "Download and upload dSYM files to apptics"
  lane :custom_lane do |options|
download_dsyms(app_identifier: "com.zoho.apptics",version: "2.7.1",build_number: "2.3")
upload_dsym_to_apptics(appversion:"2.7.1",bundleid:"com.zoho.apptics", dsymfilepath: "com.zoho.apptics-2.7.1-2.0.534.dSYM.zip",modevalue:"1", platformvalue:"iOS" ,configfilepath:"/Documents/apptics-config.plist",buildversion:"2.0.4")
clean_build_artifacts
  end
end
```

Try running the lane in the CLT using 

```bash
fastlane custom_lane or fastlane lane_name
```
## Lane Setup Using CLT
Add the below to the Fastlane/Fastfile.

```bash
default_platform(:ios)
platform :ios do
    desc "Description of what the lane does"
    lane :custom_lane do |options|
    bundleid = options[:bundleid]
    version = options[:version]
    buildnumber = options[:buildnumber]
    configpath = options[:configpath]
    mode = options[:mode]
    platform = options[:platform]

  download_dsyms(app_identifier: bundleid,version: version,build_number: buildnumber)
  upload_dsym_to_apptics(appversion:version,bundleid:"#{bundleid}", dsymfilepath: "#{bundleid}-#{version}-#{buildnumber}.dSYM.zip",modevalue:mode, platformvalue:platform ,configfilepath:"#{configpath}",buildversion:buildnumber)
  clean_build_artifacts
  end
end
```


Try running the lane in the CLT using the below.

```bash
fastlane custom_lane  bundleid:com.zoho.apptics version:2.7  buildnumber:2.5  configpath:<PROJECT_PATH>/apptics-config.plist  mode:1 platform:iOS
```

