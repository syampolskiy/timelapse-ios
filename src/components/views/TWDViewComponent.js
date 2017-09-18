import React, {Component} from 'react';
import {Image} from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet';
import SimpleVideo  from '../player/SimpleVideo.js';

export default class TWDViewComponent extends Component {
    constructor(props) {
        super(props);
    }
    
    render(){
       return (
               /*
            <Image style={styles.backgroundImage} source={require('../../../assets/images/background.jpg')}/>
                */
               <SimpleVideo uri={this.props.VStreamURL} buttonSize={10} />
       )
   }
}

var styles = EStyleSheet.create({
    backgroundImage: {
        flex: 1,
        width: null,
        height: null
    }
});
