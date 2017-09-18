import React, {Component} from 'react';
import {View, Image} from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet';
import { VideoView } from 'react-native-360';

export default class VRViewComponent extends Component {
    render() {
        /*
        return (
            <View style={styles.wrapper}>
                <Image style={styles.backgroundImage} source={require('../../../assets/images/background.jpg')}/>
                <Image style={styles.backgroundImage} source={require('../../../assets/images/background.jpg')}/>
            </View>
        )
         */
        return (
            <VideoView
            style={{height:'100%',width:'100%'}}
            video={{ uri:'https://raw.githubusercontent.com/googlevr/gvr-ios-sdk/master/Samples/VideoWidgetDemo/resources/congo.mp4',
                type: 'stereo'}}
                displayMode={'embedded'}
                volume={1}
                enableFullscreenButton
                enableCardboardButton
                enableTouchTracking
                hidesTransitionView
                enableInfoButton={false}
            />   
        )
    }
}

var styles = EStyleSheet.create({
    wrapper: {
        flex: 1,
        flexDirection: 'row'
    },
    backgroundImage: {
        flex: 1,
        width: '50%',
        height: '100%'
    }
});
