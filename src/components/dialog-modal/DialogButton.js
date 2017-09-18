import React from 'react';
import {TouchableOpacity} from 'react-native';
import TextTheme from '../TextTheme';
import EStyleSheet from 'react-native-extended-stylesheet';

const DialogButton = ({children, backColor}) => {

	const options = {
		backgroundColor: backColor || 'rgba(28, 42, 57, .7)'
	};

	return (
		<TouchableOpacity style={[styles.button, options]}>
			<TextTheme>{children}</TextTheme>
		</TouchableOpacity>
	)
};

const styles = EStyleSheet.create({
	button: {
		width: '32.76%',
		height: '100%',
		marginRight: 1,
		alignItems: 'center',
		justifyContent: 'center'
	}
});

export default DialogButton;