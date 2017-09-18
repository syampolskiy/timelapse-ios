import React, {Component} from 'react';
import {View, Image, Dimensions} from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet';
import SimpleVideo  from '../player/SimpleVideo.js';

export default class PANViewComponent extends Component {
    
    constructor(props) {
        super(props);
    }
    
    render(){
        return (
                /*
            <View style={styles.wrapper}>
               <Image style={styles.backgroundImage} source={require('../../../assets/images/background.jpg')}/>
            </View>
                 */
                <SimpleVideo uri={this.props.VStreamURL} buttonSize={10} />
        )
    }
}

var styles = EStyleSheet.create({
    wrapper: {
        flex: 1,
        backgroundColor: 'rgba(67, 82, 89, 1)'
    },
    backgroundImage: {
        height: '60%',
        width: '100%',
        marginBottom: '15%',
        marginTop: '15%',
        resizeMode: 'stretch',
        justifyContent: 'center'
    }
});
