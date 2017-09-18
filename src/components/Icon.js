import React from 'react';
import {View, Image} from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet';

const icons = {
	'vr': require('../../assets/icons/vr.png'),
	'home': require('../../assets/icons/home.png'),
	'timer': require('../../assets/icons/timer.png'),
	'balance': require('../../assets/icons/balance.png'),
	'contrast': require('../../assets/icons/contrast.png'),
	'exposure': require('../../assets/icons/exposure.png'),
	'favourite': require('../../assets/icons/favourite.png'),
	'format': require('../../assets/icons/format.png'),
	'fps': require('../../assets/icons/fps.png'),
	'image': require('../../assets/icons/image.png'),
	'iso': require('../../assets/icons/iso.png'),
	'menu': require('../../assets/icons/menu.png'),
	'photo': require('../../assets/icons/photo.png'),
	'play': require('../../assets/icons/play.png'),
	'res': require('../../assets/icons/res.png'),
	'saturation': require('../../assets/icons/saturation.png'),
	'settings': require('../../assets/icons/settings.png'),
	'sharpness': require('../../assets/icons/sharpness.png'),
	'shutter': require('../../assets/icons/shutter.png'),
	'speed': require('../../assets/icons/speed.png'),
	'video': require('../../assets/icons/video.png'),
    'wb_auto': require('../../assets/icons/wb_auto.png'),
    'wb_daylight': require('../../assets/icons/wb_daylight.png'),
    'wb_shade': require('../../assets/icons/wb_shade.png'),
    'wb_cloudy': require('../../assets/icons/wb_cloudy.png'),
    'wb_tungstenLight': require('../../assets/icons/wb_tungstenLight.png'),
    'wb_fluorescentLight': require('../../assets/icons/wb_fluorescentLight.png'),
    'wb_custom': require('../../assets/icons/wb_custom.png'),
    'brightness': require('../../assets/icons/brightness.png')
};

const Icon = (props) => {
  const chosenIcon = icons[props.name],
		iconSize = {
  			width: props.size || 20 ,
  			height: props.size || 20
		};

	return (
		<View>
			<Image source={chosenIcon} style={[iconSize, styles.ipadSizes]}></Image>
		</View>
	)
};

const styles = EStyleSheet.create({
  '@media (min-width: 1024)': {
    ipadSizes: {
    	width: 35,
      height: 35
    }
  }
});

export default Icon;
