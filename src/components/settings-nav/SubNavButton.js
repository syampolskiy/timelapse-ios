import React from 'react'
import {TouchableOpacity} from 'react-native';
import TextTheme from '../TextTheme';

const SubNavButton = ({navButtonIndex, index, text, width, height, handlePress, pickSettings}) => {
    const options = {
        width: width || '33.20%',
        height: height || '100%'
    };
    
    return (
		<TouchableOpacity onPress={() => handlePress(navButtonIndex, index, pickSettings)}  style={[styles.container, options]}>
            <TextTheme>{text}</TextTheme>
		</TouchableOpacity>
	)
};

const styles = {
	container: {
		alignItems: 'center',
		justifyContent: 'center',
		height: '100%',
		width: '33.20%',
		marginRight: 1,
		backgroundColor: 'rgba(28,42,57, .7)',
	}
};

export default SubNavButton;
