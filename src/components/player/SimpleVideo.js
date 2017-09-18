import React, { Component ,PropTypes} from 'react';
import {
  StyleSheet,
  Text,
  View,
  Dimensions,
  TouchableOpacity
} from 'react-native';
//import PxPlayer from './camera_app/rn-rtsp-player';
import PxPlayer from 'react-native-pxplayer';
//import * as Progress from 'react-native-progress';
//import Icon from 'react-native-vector-icons/FontAwesome';
//import { Bars } from 'react-native-loader';
//import Slider from 'react-native-slider';
//var RNFS = require('react-native-fs');

const playerDefaultHeight   = Dimensions.get('window').height;
const playerDefaultWidth    = Dimensions.get('window').width;

class SimpleVideo extends Component {

  static propTypes = {
    uri:PropTypes.string
  }

  constructor(props) {
    super(props);
    this.state = {
      progress: 0,
      indeterminate: true,
      paused:false,
      playButtonColor:'rgba(255,255,255,0)',
      loadingColor:'rgba(255,255,255,0)',
      playend:false,
      position:0,
      customStyle:{},
      customButtonStyle:{},
      buttonSize:70,
      progressWidth:playerDefaultWidth
    };
//    this.state.customStyle = Object.assign({},this.props.style);
    if (this.props.style !== undefined)
      this.state.customStyle = this.props.style;

    if(this.state.customStyle.width){
      this.state.progressWidth = this.state.customStyle.width;
      this.state.customButtonStyle.width = this.state.customStyle.width;
    }

    if(this.state.customStyle.height){
      this.state.customButtonStyle.height = this.state.customStyle.height;
      this.state.customButtonStyle.top = - (this.state.customStyle.height);
    }

    if(this.props.buttonSize){
      this.state.buttonSize = this.props.buttonSize;
    }

    this.state.customButtonStyle = Object.assign(this.state.customButtonStyle,this.props.buttonStyle);
  }

  componentWillMount() {
      //
      this.setState({progress:0,playend:false});
      this.setState({paused:false});
  }
  componentWillUnmount() {
      //
      this.setState({paused:true});
      this.setState({progress:1,playend:true});
  }
    
  render() {
    let defaultControlsView = this.defaultControlsView();
    let actionButton = this.actionButton();
    return (
      <View style={styles.container}>
        <PxPlayer
        ref='player'
        paused={this.state.paused}
        style={[styles.vlcplayer,this.state.customStyle]}
        source={{uri:this.props.uri,useTcp:true,width:playerDefaultWidth,height:playerDefaultHeight}}
        onProgress={this.onProgress.bind(this)}
        onEnded={this.onEnded.bind(this)}
        onStopped={this.onEnded.bind(this)}
        onPlaying={this.onPlaying.bind(this)}
        onPaused={this.onPaused.bind(this)}
         />

      </View>
    );
  }

  actionButton()
  {
    return (
      <View>

      </View>
    );
  }

  saveVideoSnapshot()
  {
/*
    let path = RNFS.DocumentDirectoryPath + '/1.png';
    console.warn("saveVideoSnapshot path="+path);
    this.refs['player'].snapshot(path);
*/
  }


  pause()
  {
    this.setState({paused:!this.state.paused});
  }

  onPlaying(event){
    this.setState({loadingColor:'rgba(255,255,255,0)'});
    this.setState({playButtonColor:'rgba(255,255,255,0)'});
  }

  onPaused(event){
    this.setState({loadingColor:'rgba(255,255,255,0)'});
    this.setState({playButtonColor:'rgba(255,255,255,1)'});
  }


  defaultControlsView(){
    return (
      <View>
        <View style={[styles.buttonBox,{backgroundColor:'rgba(0,0,0,0)'},this.state.customButtonStyle]}>

        </View>
        <TouchableOpacity onPress={this.pause.bind(this)} activeOpacity={1} style={[styles.buttonBox,this.state.customButtonStyle]}>

        </TouchableOpacity>
      </View>
    );
  }

  onProgress(event)
  {
    //console.warn("position="+event.position+",currentTime="+event.currentTime+",remainingTime="+event.remainingTime);
    this.setState({progress:event.position});
    this.setState({loadingColor:'rgba(255,255,255,0)'});
  }

  onEnded(event)
  {
    this.setState({progress:1,playend:true});
    this.setState({playButtonColor:'rgba(255,255,255,1)'});
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  vlcplayer:{
    width:playerDefaultWidth,
    height:playerDefaultHeight,
    backgroundColor:'black',
  //  transform:[{rotate:'90deg'}]
  },
  buttonBox:{
    position:'absolute',
    top:-(playerDefaultHeight),
    alignItems: 'center',
    justifyContent: 'center',
    width:playerDefaultWidth,
    height:playerDefaultHeight
  }
});

export default SimpleVideo;
