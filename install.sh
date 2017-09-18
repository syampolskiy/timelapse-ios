#!/bin/bash


# NOTES:
# * Source manual: https://facebook.github.io/react-native/docs/getting-started.html
# * Additional manual: http://facebook.github.io/react-native/docs/integration-with-existing-apps.html
# * Except installed Xcode 8+, we need install CommandLineTools manually. To do it follow React Native official:
# “You will also need to install the Xcode Command Line Tools. Open Xcode, then choose "Preferences..." from the 
# Xcode menu. Go to the Locations panel and install the tools by selecting the most recent version in 
# the Command Line Tools dropdown.”

# Install Homebrew (pkg manager):
if [[ `which brew` == '' ]]; then
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo Homebrew already installed
fi

# Install node
if [[ `which node` == '' && `gem which node` == '' ]]; then
    brew install node
else
    echo Node already installed
fi

# Install watchman
if [[ `which watchman` == '' && `gem which watchman` == '' ]]; then
    brew install watchman
else
    echo Watchman already installed
fi

# Install CocoaPods
# CocoaPods is a package management tool for iOS and macOS development.
# Facebook(owner of React Native) use it to add the actual React Native framework code locally into current project.
if [[ `gem which cocoapods` == '' ]]; then
    brew install cocoapods
else
    echo CocoaPods already installed
fi

brew update
brew upgrade

# Node comes with npm, which lets to install the React Native command line interface.
if [[ `npm list -g | grep react` == '' ]]; then
    npm install -g react-native-cli
else
    echo React Native CLI already installed
fi



# remove old modules
rm -rf node_modules

# reset packages cache
rm -fr $TMPDIR/react-*

# Clear watchman watches
watchman watch-del-all

# Install the packages
# It will create a new /node_modules folder in root directory.
# This folder stores all the JavaScript dependencies required to build project.
npm install --save react react-native react-native-timer-mixin react-native-animatable react-native-customisable-switch react-native-extended-stylesheet react-native-linear-gradient react-native-swiper react-native-360

# Because we have created ./ios/Podfile, we are ready to install the React Native pod
cd ./ios
pod install

# To run app on simulator, we need to first start the development server. 
cd ../
npm start

# For aumatization, we run the app from the command line using:
# react-native run-ios