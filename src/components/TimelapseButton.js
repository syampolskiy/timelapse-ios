import React, {Component} from 'react';
import Svg,{
    Circle,
    G
} from 'react-native-svg';
import {View, TouchableOpacity, Text, Animated} from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet';
import Dimensions from 'Dimensions';
import Pie from './Circle';

class TmlpsBtnWrapper extends Component {
  render() {
    var innerRadius = parseFloat(this.props.radius) - parseFloat(this.props.strokeWidth);

    return (
      <View style={styles.containerForPressingBtn}>
        <Pie
          radius={this.props.radius}
          innerRadius={innerRadius}
          series={[this.props.series]}
          colors={[this.props.strokeColor]}
          backgroundColor={this.props.strokeBackground} />
        {this.props.children}
      </View>
    )
  }
}

export default class TimelapseButton extends Component{
  constructor(props) {
    super(props);

    this.state = {
      progress: new Animated.Value(0),
      timelapseColor: true
    }

    this.time = this.props.seconds * 1000;
    this.isAnimating = false;
    this.stopAnimationTriggered = false;
    this.animationTimeoutFunction = null;
  }

  countTime = () => {
    var self = this;
    
    if (!self.isAnimating){
      self.isAnimating = true;

       Animated.timing(self.state.progress, {
          toValue: 100,
          duration: self.time
       }).start();

       self.animationTimeoutFunction = setTimeout(() => {
          self.setState({
            timelapseColor: !self.state.timelapseColor,
            progress: new Animated.Value(0)
          });
          self.isAnimating = false;
          // eval(self.props.functionToSendSignal + '();');
          self.countTime();
       }, self.time);
    } else{
      self.stopTmlpsAnimation();
    }
  }

  stopTmlpsAnimation = () => {
    clearTimeout(this.animationTimeoutFunction);
    this.state.progress.stopAnimation();
    this.setState({
      timelapseColor: true,
      progress: new Animated.Value(0)
    });
    this.isAnimating = false;
  }

  render() {
    const AnimatedTmlpsBtnWrapper = Animated.createAnimatedComponent(TmlpsBtnWrapper);
    return (
          <AnimatedTmlpsBtnWrapper series={this.state.progress} strokeWidth={1} radius={(Dimensions.get('window').width) >= 1024 ? 48 : 30} strokeColor={this.state.timelapseColor ? '#E62B08' : '#fff'} strokeBackground={this.state.timelapseColor == 1 ? '#fff' : '#E62B08'}>
            <TouchableOpacity
              onPress={this.time ? this.countTime : this.sidebarProps.pickButton.bind(this, 'startStopWriting')} style={[styles.buttonTmlpsStyles, {backgroundColor: (this.time) ? '#fff' : (this.sidebarProps.startStopWriting) ? '#E62B08' : '#FFF'}]}
            />
          </AnimatedTmlpsBtnWrapper>
    );
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
  '@media (min-width: 1024)': {
    buttonTmlpsStyles: {
      width: 86,
      height: 86,
      borderRadius: 86
    },
  }
});


EStyleSheet.build();