import React from 'react'
import { View, Text } from 'react-native';
import Icon from './Icon';
import TextTheme from './TextTheme';

const StatusIcon = ({ iconName, text }) => {
  return (
    <View style={styles.container}>
      <Icon name={iconName}/>
      <TextTheme>{text}</TextTheme>
    </View>
  )
};

const styles = {
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingRight: 5,
    paddingLeft: 5
  }
};

export default StatusIcon;