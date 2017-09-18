import React, { Component } from 'react';
import { Text, Dimensions } from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet';

const TextTheme = ({ children, size, color, lowCase }) => {

  const opt = {
    fontSize: size || (Dimensions.get('window').width >= 1024 ? 15 : 10),
    color: color || "#fff"
  };

  return (
    <Text style={[styles.container, opt]}>
      { !lowCase ? children.toUpperCase() : children }
    </Text>
  )
};

const styles = EStyleSheet.create({
  container: {
    // fontFamily: 'urwgeometric-bold'
  }
});

export default TextTheme;
