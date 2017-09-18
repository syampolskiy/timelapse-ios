import React, { Component } from 'react';
import { View, TouchableOpacity, Text, Dimensions } from 'react-native';
import TextTheme from './TextTheme';
import EStyleSheet from 'react-native-extended-stylesheet';
import Icon from './Icon';
const writingProgressTimer = require('react-native-timer-mixin');

const tick_ms = 100;
const ask_period_ms = 2000;
const strWritingProgressDef = "00:00:00:000";

class TopbarSection extends Component {

    constructor(props) {
        super(props);
        
        this.state = {
            writingProgressAfterAsk: 0,
            strWritingProgress: strWritingProgressDef,
            camStatusError: this.props.camStatusError,
            isConnected: this.props.isServerConnected,
            writingProgressMS: this.props.writingProgressMS,
            startStopWriting: this.props.startStopWriting
        };
    }
    
    componentWillReceiveProps(nextProps) {
        
        this.setState({...this.state,
                      isConnected: nextProps.isServerConnected,
                      camStatusError: nextProps.camStatusError,
                      writingProgressMS: nextProps.writingProgressMS,
                      startStopWriting: nextProps.startStopWriting});
    }
    
    componentDidMount() {
        writingProgressTimer.setInterval(() => {
                                         if (this.state.startStopWriting != 0 &&
                                             this.state.isConnected != 0)
                                            this.tickWritingProgress();
                                         },
                                         tick_ms );
    }
    
    componentWillUnmount() {
        writingProgressTimer.clearTimeout(this);
    }
    
    pad2 (d) {
        return (d < 10) ? '0' + d.toString() : d.toString();
    }
    pad3 (d) {
        return (d < 10) ? '00' + d.toString() : (d < 100) ? '0' + d.toString() : d.toString();
    }
    
    tickWritingProgress() {
        newtime_ms = this.state.writingProgressMS + tick_ms;
        
        ms = newtime_ms;
        isNegativeTime = false;
        if (ms < 0) {
            isNegativeTime = true;
            ms = -ms;
        }
        
        sec = 0;
        min = 0;
        hrs = 0;
        
        if (ms >= 1000) {
            sec = Math.floor(ms / 1000);
            ms = ms % 1000;
        }
        if (sec >= 60) {
            min = Math.floor(sec / 60);
            sec = sec % 60;
        }
        if (min > 60) {
            hrs = Math.floor(min / 60);
            min = min % 60;
        }
        strWritingProgress = this.pad2(hrs) + ':' + this.pad2(min) + ':' + this.pad2(sec) + ':' + this.pad3(ms);
        
        if (isNegativeTime)
            strWritingProgress = '-' + strWritingProgress;
        
        writingProgressAfterAsk = this.state.writingProgressAfterAsk + tick_ms;
        if (writingProgressAfterAsk > ask_period_ms) {
            writingProgressAfterAsk = 0;
            this.props.pickButton('doUpdateWritingProgress');
        }
        
        this.setState({
                      ...this.state,
                      strWritingProgress: strWritingProgress,
                      writingProgressMS: newtime_ms,
                      writingProgressAfterAsk: writingProgressAfterAsk
                      });

    }
    
  render() {
    return (
      <View style={ styles.container } pointerEvents={'box-none'}>
        <TouchableOpacity style={{ zIndex: 2, padding: 5 }}>
          <Icon name="home"/>
        </TouchableOpacity>

        <View style={styles.connectButtonContainer}>
            <View style={this.state.isConnected !== 0 ? (!this.state.camStatusError.length ? styles.connectButton : styles.warningButton) : styles.disconnectButton}>
            <TextTheme>
                {this.state.isConnected !== 0 ?
                    ( !this.state.camStatusError.length ? "CONNECTED" : this.state.camStatusError) :
                    "DISCONNECTED"}
            </TextTheme>
          </View>
        </View>

        <View style={styles.rightContainer}>
          <TouchableOpacity onPress={this.props.toggleWritingProgress.bind(this)}>
            <View style={{ flexDirection: 'row', alignItems: 'center' }}>
              <Icon name="timer"/>
              <View style={{ justifyContent: 'center', marginRight: 20, marginLeft: 5 }}>
                <Text style={{ color: '#FFF', fontSize: Dimensions.get('window').width <= 568 ? 15 : 20, fontWeight: 'bold' }}>
                    { (!this.state.startStopWriting || !this.state.isConnected) ? strWritingProgressDef : this.state.strWritingProgress}
                </Text>
              </View>
            </View>
          </TouchableOpacity>
          <TouchableOpacity onPress={this.props.toggleMainSettingsNav}
                            style={{padding: 5, alignItems: 'center', justifyContent: 'center' }}>
            <Icon name="menu"/>
          </TouchableOpacity>
        </View>
      </View>
    )
  }
}

const styles = EStyleSheet.create({
  container: {
    position: 'relative',
    height: "12.04%",
    backgroundColor: "rgba(28, 42, 57, .7)",
    marginBottom: ".65%",
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingLeft: 15,
    paddingRight: 20,
  },
  connectButtonContainer: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    justifyContent: 'center',
    alignItems: 'center',
    zIndex: 1
  },
  connectButton: {
    justifyContent: 'center',
    alignItems: 'center',
    width: '24.64%',
    height: '100%',
    backgroundColor: '#009c00'
  },
  warningButton: {
    justifyContent: 'center',
    alignItems: 'center',
    width: '24.64%',
    height: '100%',
    backgroundColor: '#ff7f00'
  },
  disconnectButton: {
    justifyContent: 'center',
    alignItems: 'center',
    width: '24.64%',
    height: '100%',
    backgroundColor: '#9c0000'
  },
  rightContainer: {
    flexDirection: 'row',
    zIndex: 2,
    alignItems: 'center'
  },
  '@media (min-width: 1024)': {
    container: {
      height: "9%",
    }
  }
});

export default TopbarSection;


