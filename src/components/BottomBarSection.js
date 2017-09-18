import React, { Component } from 'react';
import { View, TouchableOpacity, Text } from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet';
import TextTheme from './TextTheme';
import CameraModeButton from './CameraModeButton';

class BottomBarSection extends Component {
  state = {
    buttonActive: false
  };

  toggleButton = () => {
    this.setState({
      buttonActive: !this.state.buttonActive
    })
  };

  outputCamInfo = () => {
      return 'Camera '.concat(this.props.currentCamera.toString());
  }

  render() {
    const { buttonActive } = this.state;

    return (
      <View style={[styles.container, { zIndex: buttonActive ? 2 : 1}]} pointerEvents={'box-none'}>
        <View style={styles.buttonContainer} pointerEvents={'box-none'}>
          <CameraModeButton
              buttonActive={buttonActive}
              toggleButton={this.toggleButton}
              toogleViewCamMode={this.props.toogleViewCamMode}
              viewActiveCamMode={this.props.viewActiveCamMode}
          />
        </View>

        { this.props.settingsNavActive ?
          <View style={ styles.statusStyles }>
            <TextTheme>{ (this.props.viewActiveCamMode === 'cam') ? this.outputCamInfo() : 'Settings' }</TextTheme>
          </View>
          : null }

      </View>
    )
  }
}

const styles = EStyleSheet.create({
  container: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    flexDirection: 'row',
    width: '100%',
    alignContent: 'center',
    alignItems: 'flex-end',
    height: '40.33%'
  },
  statusStyles: {
    width: '83%',
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: 'rgba(16, 20, 22, .8)',
    height: '25.07%'
  },
  buttonContainer: {
    width: '16.46%',
    height: '100%',
    justifyContent: 'flex-end',
  },
  '@media (min-width: 1024)': {
    container: {
      height: '30%'
    }
  }
});

export default BottomBarSection;
