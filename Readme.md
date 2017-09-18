# Build & Test

## Requirements
- MacOS
- Xcode 8+

## Setup Project
- Copy folder __./R7-Surround360/source/camera_app/__ to some  empty (NEIGHBOUR to ./camera_app) folder __./Workspace__. Each time when you pull new version from GitHub you need to copy actual project to empty folder
- Start __Terminal__ and change current folder to __./Workspace__ folder
- Close any opened Xcode projects
- In __Terminal__ start command "__bash install.sh__" 
    - Script will install necessary components
    - At the end script starts __NPM-Server__ which "freeze" the __Terminal__. It will be required for debugging of the React Native applications
    - If you do not want to debug application and want to deploy release to real device you may close __NPM-Server__ by Ctrl+C. Release version of React Native applicatios do not requires __NPM-Server__
    - To start __NPM-Server__ for debugging the React Native application:
        - In __Terminal__ set current folder to __./Workspace__ folder
        - From __Terminal__ start command "__npm start__"
        - Wait till __NPM-Server__ prompts the follow line: "_Loading dependency graph, done._"
- Navigate Finder to folder __./Workspace/ios/__
- Double Click to workspace file __camera_app.xcworkspace__
    - Note: Do not confused with project file __camera_app.xcodeproj__
- Wait till Xcode opens workspace
- Install the Xcode Command Line Tools
    - In Xcode, pick menu item __Preferences...__. Go to the __Locations__ panel and install the tools by selecting the most recent version in  the __Command Line Tools__ dropdown
- Set Build Configuration to Release (if necessary)
    - Select Project __camera_app__ (top blue icon at the left panel)
    - Pick menu item __Product >> Scheme >> Edit Scheme...__
    - In the appeared dialog select __Run__ scheme (left panel), __Info__-tab in the right panel and select __Build Configuration__ listbox to __Release__
    - Pick __Close__ button

## Setup Simulator
- Select menu item __Product >> Destination >> iPhone 6s (10.0)__
- If you have not such menu item it seems that Xcode have not installed such simulator
- You can choose any other simulator to test app in other one via choosing from the list __Product >> Destination >> iOS Simulators__
- You can install simulator and test app with it by picking menu item __Product >> Destination >> Download Simulators...__

## Build & Run
- Delete previously installed "camera_app" from simulator or device where you want to deploy application
- To Build & Run application on the selected device (or simulator), pick menu item __Product >> Run__
- If early we'd set the product destination to simulator, system will launch it firstly. It could take some time
- As simulator will be launched, Xcode installs "camera_app" application to it and start it
    - If application has been built in Debug-mode
        - __NPM-Server__ needs to be be started. Otherwise application throws __Red Screen__ exception
        - During first starting, __Server__ caches resources. It could take some time. Wait till progressbar in __NPM-Server__ process 100% and prompt "_Bundling `index.ios.js`  100.0(562/562), done._"
        - Do not try to debug application with real device. Only simulator could be setup as target platform
    - If application has been built in Release-mode
        - __NPM-Server__ does not required
        - Resources cashes during compilation and increase the compilation time
- "camera_app" configured to work in landscape mode only. Hence after starting the simulator will be rotated to horizontal position
- Return to “Home” on simulator (or device). To do it activate simulator window and pick menu item (on the top screen panel) __Hardware >> Home__

## Setup Application
- On the simulator find & run application __Settings__
- In __Settings__ application find and run item __camera_app__
- In the appeared screen you will need set __Server IP__ and __Server Port__ according to settings of your "CameraCtrl" server
    - To make symbol typing more friendly, uncheck menu item __Hardware >> Keyboard >> Uses the Same Layout as macOS__ and check menu item __Hardware >> Keyboard >> Connect Hardware Keyboard__

## Test Application
- Start "CameraCtrl" (about the top of app console will be prompted "_SERVER: server connection to port 20248 has been initialised_")
- On the simulator find & run application __camera_app__
- Simulator will rotate to landscape position and display actual layout
    - In debug mode, first start will take some time for caching resources on __NPM-Server__
- Press big white rounded button at the MENU-panel on the simulator
- Button will change colour to red. "CameraCtrl" console prompt info "_SERVER: Command "set bwritingstartstop 1" has been executed successfully_"
- Press big red rounded button at the MENU-panel on the simulator
- Button will change colour to white. "CameraCtrl" console prompt info "_SERVER: Command "set bwritingstartstop 0” has been executed successfully_"