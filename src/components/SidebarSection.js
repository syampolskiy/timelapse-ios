import React, { Component } from 'react';
import { View, TouchableOpacity, Dimensions } from 'react-native';
import Icon from './Icon';
import TextTheme from './TextTheme';
import EStyleSheet from 'react-native-extended-stylesheet';
import Switch from 'react-native-customisable-switch';
import TimelapseButton from './TimelapseButton';

class SidebarSection extends Component {
  constructor(props) {
    super(props);
/*
    this.state = {
    };
      */
  }

  render() {
    return (
      <View style={ styles.container }>
        <TextTheme>MENU</TextTheme>


        <View style={styles.switchContainer}>
          <View style={styles.modeContainerStyles}>
            <Icon name="photo" size={20}/>
            <Icon name="video" size={20}/>
          </View>

          <Switch
            activeBackgroundColor={'rgba(28, 42, 57, 0)'}
            inactiveBackgroundColor={'rgba(28, 42, 57, 0)'}
            switchWidth={Dimensions.get('window').width >= 1024 ? 108 : 60}
            switchHeight={Dimensions.get('window').width >= 1024 ? 28 : 18}
            switchBorderRadius={Dimensions.get('window').width >= 1024 ? 28 : 18}
            switchBorderColor={'rgba(255, 255, 255, 1)'}
            switchBorderWidth={1}
            buttonWidth={Dimensions.get('window').width >= 1024 ? 28 : 18}
            buttonHeight={Dimensions.get('window').width >= 1024 ? 28 : 18}
            buttonBorderRadius={18}
            padding={false}
            value={this.props.photoVideoMode !== 0 ? false : true}
            onChangeValue={(value) => {this.props.changeFotoVideoMode(value)}}
          />
        </View>

        <View style={styles.buttonContainerStyles}>
          <TimelapseButton seconds={3} functionToSendSignal={'timeIsOver'} sidebarProps={this.props}/>
        </View>

        <TouchableOpacity onPress={this.props.toggleScrollMenu} style={styles.buttonPlayStyles}>
          <Icon name="play"/>
        </TouchableOpacity>

        <TouchableOpacity onPress={this.props.toggleSettingsNav} style={{ padding: 5 }}>
          <Icon name="settings"/>
        </TouchableOpacity>
      </View>
    )
  }
}

const styles = EStyleSheet.create({
  containerTmlps:{
    backgroundColor: 'rgba(28, 42, 57, .7)',
  },
  containerForPressingBtn:{
    alignItems: 'center',
    justifyContent: 'center'
  },
  buttonTmlpsStyles: {
    width: 50,
    height: 50,
    borderRadius: 50,
    position: 'absolute'
  },
  container: {
    width: '11.56%',
    backgroundColor: 'rgba(28, 42, 57, .7)',
    paddingTop: 5,
    paddingBottom: 10,
    flex: 1,
    flexDirection: 'column',
    justifyContent: 'space-between',
    alignItems: 'center'
  },
  modeContainerStyles: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    width: '100%',
    paddingLeft: 5,
    paddingRight: 5,
    marginTop: 10,
    marginBottom: 5
  },
  buttonContainerStyles: {
    padding: 1,
    width: 60,
    height: 60,
    borderWidth: 1,
    borderColor: '#FFF',
    borderRadius: 60,
    justifyContent: 'center',
    alignItems: 'center',
    // marginTop: 30,
    // marginBottom: 20
  },
  buttonStyles: {
    width: 50,
    height: 50,
    borderRadius: 50
  },
  buttonPlayStyles: {
    marginBottom: 25,
    padding: 5
  },
  switchContainer: {
    width: '100%',
    alignItems: 'center'
  },
  '@media (min-width: 1024)': {
    container: {
      paddingTop: 20,
      paddingBottom: 15
    },
    buttonContainerStyles: {
      width: 100,
      height: 100,
      borderRadius: 100
    },
    buttonStyles: {
      width: 86,
      height: 86,
      borderRadius: 86
    },
  }
});

export default SidebarSection;
