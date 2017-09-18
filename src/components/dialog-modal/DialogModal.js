import React, {Component} from 'react';
import {View} from 'react-native';
import TextTheme from '../TextTheme';
import EStyleSheet from 'react-native-extended-stylesheet';


class DialogModal extends Component {

	render() {
		return (
			<View style={ styles.wrapper }>
				<View style={ styles.container }>
					<View style={styles.textContainer}>
						<TextTheme size={Dimensions.get('window').width >= 1024 ? 15 : 12} lowCase>{this.props.text }</TextTheme>
					</View>
					<View style={ styles.buttonsContainer }>
						{ this.props.children }
					</View>
				</View>
			</View>
		)
	}
}

const styles = EStyleSheet.create({
	wrapper: {
		justifyContent: 'center',
		alignItems: 'center',
		position: 'absolute',
		top: 0,
		left: 0,
		right: 0,
		bottom: 0,
		zIndex: 1
	},
	container: {
		backgroundColor: 'rgba(28, 42, 57, .7)',
		height: '29.90%',
		width: '100%',
		paddingLeft: '13.65%',
		alignItems: 'center',
		justifyContent: 'space-between'
	},
	textContainer: {
		justifyContent: 'center',
		height: '46.45%'
	},
	buttonsContainer: {
		flexDirection: 'row',
		justifyContent: 'center',
		height: '46.45%'
	}
});

export default DialogModal;
