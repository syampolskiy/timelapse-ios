import React, {Component} from 'react';
import {View, Text, TouchableOpacity, Dimensions} from 'react-native';
import EStylesheet from 'react-native-extended-stylesheet';
import Icon from './Icon';
import TextTheme from './TextTheme';


class CameraModeButton extends Component {

    renderMenu = () => {
        if (this.props.buttonActive) {
            return (
                <View style={styles.menu}>
                    <TouchableOpacity style={styles.menuItem} onPress={() => this.toogleViewCamMode('2d')}>
                        <TextTheme size={Dimensions.get('window').width >= 1024 ? 20 : 15}>2D</TextTheme>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.menuItem} onPress={() => this.toogleViewCamMode('cam')}>
                        <TextTheme size={Dimensions.get('window').width >= 1024 ? 20 : 15}>CAM</TextTheme>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.menuItem} onPress={() => this.toogleViewCamMode('pan')}>
                        <TextTheme size={Dimensions.get('window').width >= 1024 ? 20 : 15}>PAN</TextTheme>
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.menuItem} onPress={() => this.toogleViewCamMode('vr')}>
                        <Icon size={25} name="vr"/>
                    </TouchableOpacity>
                </View>
            )
        }
    };

    toogleViewCamMode = (mode) => {
        if (mode) {
            this.props.toggleButton();
            this.props.toogleViewCamMode(mode);
        } else {
            console.error('No camera mode selected!')
        }
    }

    renderActiveMenu = () => {
        let viewActiveCamMode = this.props.viewActiveCamMode;
        if (viewActiveCamMode) {
            if (viewActiveCamMode === 'cam' || viewActiveCamMode === 'pan' || viewActiveCamMode === '2d') {
                return (
                    <TouchableOpacity style={{padding: 5}} onPress={this.props.toggleButton}>
                        <TextTheme
                            size={Dimensions.get('window').width >= 1024 ? 20 : 15}>{ viewActiveCamMode.toUpperCase() }</TextTheme>
                    </TouchableOpacity>
                )
            } else if (viewActiveCamMode === 'vr') {
                return (
                    <TouchableOpacity style={{padding: 5}} onPress={this.props.toggleButton}>
                        <Icon size={25} name="vr"/>
                    </TouchableOpacity>
                )
            }
        }
    }

    render() {
        return (
            <View style={styles.wrapper}>
                {this.renderMenu()}
                <View style={{
                    height: '25.07%',
                    backgroundColor: (this.props.viewActiveCamMode != 'vr') ? 'rgba(16, 20, 22, .8)' : null,
                    justifyContent: 'center',
                    alignItems: 'center'
                }}>
                    { this.renderActiveMenu() }
                </View>
            </View>
        )
    }
}

const styles = EStylesheet.create({
    menu: {
        backgroundColor: 'rgba(16, 20, 22, .8)',
        width: '100%',
        alignItems: 'center',
        height: '74.93%',
        justifyContent: 'space-between',
        padding: 5,
        opacity: 0.6
    },
    wrapper: {
        height: '100%',
        justifyContent: 'flex-end',
        marginRight: 1
    },
    '@media (min-width: 1024)': {
        menu: {
            height: '60%',
            padding: 10
        }
    }
});

export default CameraModeButton;