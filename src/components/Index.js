import React, {Component} from 'react';

import {View, NativeModules, NativeEventEmitter} from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet';
import {createAnimatableComponent} from 'react-native-animatable';
import SidebarSection from './SidebarSection';
import TopbarSection from './TopbarSection';
import BottomBarSection from './BottomBarSection';
import StatusBar from '../containers/StatusBar';
import SettingsNav from './settings-nav/SettingsNav';
import MainNav from './MainNav';
import ScrollMenu from '../containers/ScrollMenu';

import CAMView from './views/CAMViewComponent';
import TWDView from './views/TWDViewComponent';
import VRView from './views/VRViewComponent';
import PANView from './views/PANViewComponent';



const AnimatableSettingsNav = createAnimatableComponent(SettingsNav);
const timer = require('react-native-timer-mixin');
const timer2 = require('react-native-timer-mixin');


const {CamAppBridge} = NativeModules;

EStyleSheet.build();

const videos = [
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 1",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 2",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 3",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 4",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 5",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 6",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 7",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 8",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 9",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 10",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 11",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 12",
    "VIDEO - 12/01/17 - 16:45:12 - 00:23 sec - 90fps - 8K 13"
];


export default class Index extends Component {

    toggleSettingsNav = () => {
        this.setState({
            ...this.state,
            mainSettingsNavActive: false,
            settingsNavActive: !this.state.settingsNavActive,
            scrollMenuActive: false
        })
    };

    toggleScrollMenu = () => {
        this.setState({
            ...this.state,
            mainSettingsNavActive: false,
            settingsNavActive: false,
            scrollMenuActive: !this.state.scrollMenuActive
        })
        if (!this.state.scrollMenuActive)
            CamAppBridge.pickButton('updateFootageList');
    };

    toggleMainSettingsNav = () => {
        this.setState({
            ...this.state,
            mainSettingsNavActive: !this.state.mainSettingsNavActive,
            settingsNavActive: false,
            scrollMenuActive: false
        })
    };

    toogleViewCamMode = (mode) => {
        this.setState({
            ...this.state,
            viewActiveCamMode: mode,
        })
        CamAppBridge.pickSettings('CamStateCamMode', mode, null);
    }

    toogleSettings = () => {
        if (this.state.settingsNavActive) {
            this.toggleSettingsNav();
        } else if (this.state.mainSettingsNavActive) {
            this.toggleMainSettingsNav();
        }

    }

    toggleWritingProgress = () => {
        CamAppBridge.toggleWritingProgress();
    };

    pickButton = (btnName) => {
        CamAppBridge.pickButton(btnName);
    }

    async_pickSettings = (settingsName, value) => {
        CamAppBridge.pickSettings(settingsName, value, null);
    }
    
    changeFotoVideoMode = (value) => {
        this.setState({
                      ...this.state,
                      scrollMenuActive: false,
                      photoVideoMode: value ? 0/*video*/ : 1/*photo*/,
                      startStopWriting: value ? this.state.startStopWriting/*no change*/ :
                                                0/*stopped*/
                      });
        CamAppBridge.pickSettings('photoVideoMode', value ? '0':'1', null);
    }
    
    toogleCurrentCam = (position) => {
        this.setState({
            ...this.state,
            currentCamera: position
        });
        CamAppBridge.pickSettings('CamStateCurrentCam', position.toString(), null);
    }

    async pickSettings(settingsName, value) {
        try {
            let newState = await CamAppBridge.syncPickSettings(this.state, settingsName, value);
            
            this.setState(...this.state, newState);
            
        } catch (e) {
            console.error(e);
        }
    }
    
    async processEvents(eventName) {
        try {
            let newState = await CamAppBridge.processEvents(this.state, eventName);

            this.setState(...this.state, newState);

        } catch (e) {
            console.error(e);
        }
    }

    constructor(props) {
        super(props);

        this.state = {
            mainSettingsNavActive: false,
            settingsNavActive: false,
            scrollMenuActive: false,
            startStopWriting: 0, // stopped
            camStatusError: "", // no errors
            photoVideoMode: 0, // video
            fps: "30",
            iso: "400",
            exposure: "1.0",
            awb: "5200",
            resolution: "2K",
            shutterspeed: "10",
            isAutoExposure: 0, // false
            brightness: "0%", // 0..100 + '%'
            contrast: "50%", // 0..100 + '%'
            saturation: "50%", // 0..100 + '%'
            sharpness: "50%", // 0..100 + '%'
            writingProgressMS: 0, // -ms for remain time. +ms for writing time
            isServerConnected: 0, // disconnected
            VStreamURL: '', // no url for video stream
            viewActiveCamMode: 'cam',
            currentCamera: 0,
            footageList: [],
            CAMnb: 3,
            pixFmtInd: 0 // 8bit
        };
        //
        //
        //
        const camAppBridgeEmitter = new NativeEventEmitter(CamAppBridge);
        const subscription = camAppBridgeEmitter.addListener(
                                                             'EventReminder',
                                                             (reminder) => this.processEvents(reminder.name)
                                                             );
    }
    componentDidMount() {
        timer.setInterval(() => {
                          if (this.state.isServerConnected)
                            this.pickButton("udtCamStatusError")
                          else
                            this.pickButton("udtStateFromServer");
                          },
                          2000 );
        
        timer2.setInterval(() => {
                           if (this.state.isServerConnected)
                             this.pickButton("udtCamState0");
                           },
                           1000 );
    }
    componentWillUnmount() {
        timer.clearTimeout(this);
        timer2.clearTimeout(this);
        subscription.remove();
    }

    render() {
        const {settingsNavActive, scrollMenuActive, mainSettingsNavActive, viewActiveCamMode} = this.state;
        const uri = this.state.VStreamURL;

        return (
            <View style={ styles.container }>
                {/*<SimpleVideo uri={uri} buttonSize={10}  />*/}

                { this.rendeView() }

                <View style={ styles.absoluteContainer } pointerEvents={'box-none'}>
                    { (viewActiveCamMode != 'vr') ?
                        <TopbarSection
                            toggleMainSettingsNav={this.toggleSettingsNav}
                            isServerConnected={this.state.isServerConnected}
                            writingProgressMS={this.state.writingProgressMS}
                            startStopWriting={this.state.startStopWriting}
                            camStatusError={this.state.camStatusError}
                            toggleWritingProgress={this.toggleWritingProgress.bind(this)}
                            pickButton={this.pickButton.bind(this)}
                        />
                        : null }
                    <View style={ styles.mainSection } pointerEvents={'box-none'}>
                        <View style={ styles.contentSection } pointerEvents={'box-none'}>

                            { (viewActiveCamMode != 'vr') ?
                                <View pointerEvents={'box-none'}>
                                    <StatusBar
                                        settingsNavActive={this.state.settingsNavActive}
                                        fps={this.state.fps}
                                        iso={this.state.iso}
                                        awb={this.state.awb}
                                        pixFmtInd={this.state.pixFmtInd}
                                        resolution={this.state.resolution}
                                        shutterspeed={this.state.shutterspeed}
                                        exposure={this.state.exposure}
                                        contrast={this.state.contrast}
                                        saturation={this.state.saturation}
                                        sharpness={this.state.sharpness}
                                    />
                                    <View style={styles.middleSection} pointerEvents={'box-none'}>
                                        {settingsNavActive ?
                                            <AnimatableSettingsNav
                                                animation="fadeIn"
                                                duration={400}
                                                startStopWriting={this.state.startStopWriting}
                                                fps={this.state.fps}
                                                iso={this.state.iso}
                                                shutterspeed={this.state.shutterspeed}
                                                awb={this.state.awb}
                                                exposure={this.state.exposure}
                                                isAutoExposure={this.state.isAutoExposure}
                                                pixFmtInd={this.state.pixFmtInd}
                                                brightness={this.state.brightness}
                                                contrast={this.state.contrast}
                                                saturation={this.state.saturation}
                                                resolution={this.state.resolution}
                                                sharpness={this.state.sharpness}
                                                pickSettings={this.pickSettings.bind(this)}
                                            />
                                            : null}

                                        {scrollMenuActive ?
                                            <ScrollMenu data={this.state.footageList}/>
                                            : null}

                                        {mainSettingsNavActive ?
                                            <MainNav
                                                startStopWriting={this.state.startStopWriting}
                                                fps={this.state.fps}
                                                iso={this.state.iso}
                                                pixFmtInd={this.state.pixFmtInd}
                                                resolution={this.state.resolution}
                                                shutterspeed={this.state.shutterspeed}
                                                pickSettings={this.pickSettings.bind(this)}/>
                                            : null}
                                    </View>
                                </View>
                                : null }


                            {/*<DialogModal text="Are you sure you want to permanently delete your footage?">*/}
                            {/*<DialogButton backColor="#9c3100">Yes</DialogButton>*/}
                            {/*<DialogButton>No</DialogButton>*/}
                            {/*</DialogModal>*/}

                            {/*<DialogModal text="VIDEO -DD/MM/YY - time of day - time recorded - fps - resolution">*/}
                            {/*<DialogButton>Change name</DialogButton>*/}
                            {/*<DialogButton backColor="#9c3100">Delete</DialogButton>*/}
                            {/*</DialogModal>*/}

                            {/*<DialogModal text="VIDEO -DD/MM/YY - time of day - time recorded - fps - resolution">*/}
                            {/*<DialogButton backColor="rgba(110, 132, 146, .7)">Monoscopic player</DialogButton>*/}
                            {/*<DialogButton backColor="#939393">Render stereo</DialogButton>*/}
                            {/*<DialogButton backColor="#9c3100">Delete</DialogButton>*/}
                            {/*</DialogModal>*/}

                            <BottomBarSection
                                settingsNavActive={this.state.settingsNavActive || this.state.mainSettingsNavActive || this.state.viewActiveCamMode == 'cam'}
                                toogleViewCamMode={this.toogleViewCamMode}
                                viewActiveCamMode={this.state.viewActiveCamMode}
                                currentCamera={this.state.currentCamera}
                            />

                        </View>
                        { (viewActiveCamMode != 'vr') ?
                            <SidebarSection
                                toggleSettingsNav={this.toggleMainSettingsNav}
                                toggleScrollMenu={this.toggleScrollMenu}
                                startStopWriting={this.state.startStopWriting}
                                photoVideoMode={this.state.photoVideoMode}
                                pickButton={this.pickButton.bind(this)}
                                changeFotoVideoMode={this.changeFotoVideoMode.bind(this)}
                            />
                            : null }
                    </View>
                </View>
            </View>
        );
    }
    rendeView = () => {
        let viewActiveCamMode = this.state.viewActiveCamMode;

        switch (viewActiveCamMode) {
            case '2d':
                return <TWDView
                    VStreamURL={this.state.VStreamURL}
                />
                break;
            case 'cam':
                return <CAMView
                    toogleCurrentCam={ this.toogleCurrentCam }
                    CAMnb={this.state.CAMnb}
                    VStreamURL={this.state.VStreamURL}
                    currentCamera={this.state.currentCamera}
                />
                break;
            case 'pan':
                return <PANView
                    VStreamURL={this.state.VStreamURL}
                />
                break;
            case 'vr':
                this.toogleSettings();
                return <VRView/>
                break;
            default:
                return <TWDView/>
        }

    }
}

const styles = EStyleSheet.create({
    container: {
        flex: 1,
        width: null,
        height: null
    },
    mainSection: {
        flex: 1,
        flexDirection: "row",
        marginBottom: ".65%"
    },
    contentSection: {
        position: "relative",
        width: '87.24%',
        marginLeft: ".65%",
        marginRight: ".65%"
    },
    middleSection: {
        height: '57%',
        zIndex: 2
    },
    '@media (min-width: 1024)': {
        middleSection: {
            height: '42%',
            marginTop: 70
        }
    },
    wrapper: {},
    absoluteContainer: {
        position: 'absolute',
        flex: 1,
        width: '100%',
        height: '100%'
    }
});
