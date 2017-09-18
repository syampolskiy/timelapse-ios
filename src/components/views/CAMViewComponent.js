import React, {Component} from 'react';
import Swiper from 'react-native-swiper';
import EStyleSheet from 'react-native-extended-stylesheet';
import {View, Text, Dimensions, Image} from 'react-native';
import SimpleVideo  from '../player/SimpleVideo.js';

export default class CAMViewComponent extends Component {
    swiper:Object;
    
    constructor(props) {
        super(props);
    }
    
    
    componentWillReceiveProps(nextProps) {

        const currentIndex = this.swiper.state.index;
        const offset = nextProps.currentCamera - currentIndex;
        if (offset != 0 && nextProps.currentCamera > 0)
            this.swiper.scrollBy(offset);
    }
    
    onMomentumScrollEnd =  (e, state, context) => {
        this.props.toogleCurrentCam(state.index);
    }

    loopCams = () => {
        
        camsList = [];
        for (i=0; i < this.props.CAMnb; ++i)
            camsList.push({});
        
        return camsList.map((cam, i) => {
                return (
                    <SimpleVideo uri={this.props.VStreamURL} buttonSize={10} key={i}  />
                );
        })
    }

    render() {
        
        return (
            <View style={styles.wrapper}>
                <Swiper
                    showsButtons={true}
                    showsPagination={false}
                    loop={false}
                    onMomentumScrollEnd={this.onMomentumScrollEnd}
                    loadMinimal={true}
                    loadMinimalSize={0}
                    nextButton={<Image style={[{ marginRight: "27%"}, styles.buttonControll]}  source={require('../../../assets/images/arrow_right.png')}></Image>}
                    prevButton={<Image style={[{ marginLeft: "48%"}, styles.buttonControll]} source={require('../../../assets/images/arrow_left.png')}></Image>}
                    ref={component => this.swiper = component}>
                    {this.loopCams()}
                </Swiper>
            </View>
        )
    }
}

const styles = EStyleSheet.create({
    $arrowHeight: 75,
    $arrowWidth: 50,
    wrapper: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        paddingTop: '8%',
        backgroundColor: 'rgba(67, 82, 89, 1)'

    },
    slidesContainer: {
        flex:1
    },
    image: {
        width: "30%",
        height: "50%",
    },
    buttonControll: {
        width: '$arrowWidth',
        height: '$arrowHeight'
    },
    slide: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        width: null,
        height: null
    }
});
