import React from 'react'
import { View, TouchableOpacity, Dimensions } from 'react-native';
import Icon from '../Icon';
import TextTheme from '../TextTheme';

const NavButton = ({ navButtonIndex, index, title, active, iconName, text, handlePress, width, height, pickSettings }) => {
  const options = {
    width: width || '16.46%',
    height: height || '50%'
  };

  return (
    <TouchableOpacity onPress={() => {
            if (active != 0) {
                (pickSettings !== undefined) ? handlePress(navButtonIndex, index, pickSettings) : handlePress(index);
            }
          }} style={[styles.container, options]}>
      <TextTheme size={Dimensions.get('window').width >= 1024 ? 11 : 8}>{title}</TextTheme>
      <View style={styles.iconStyles}>
        <Icon name={iconName}/>
      </View>
      <TextTheme size={Dimensions.get('window').width >= 1024 ? 11 : 8} lowCase>{text}</TextTheme>
    </TouchableOpacity>
  )
};

const styles = {
  container: {
    height: '50%',
    backgroundColor: 'rgba(28,42,57, .7)',
    justifyContent: 'center',
    flexDirection: 'column',
    alignItems: 'center',
    marginRight: 1,
    marginBottom: 1
  },
  iconStyles: {
    padding: 5
  }
};

export default NavButton;
