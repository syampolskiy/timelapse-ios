import React, { Component } from 'react';
import { View, Dimensions } from 'react-native';
import Icon from '../Icon';
import TextTheme from '../TextTheme';
import EStyleSheet from 'react-native-extended-stylesheet';


class SettingsSubNav extends Component {

  renderChildren = () => {
    if (this.props.noChildren) {
      return null
    }

    return (
      <View style={ styles.buttonsContainer }>
        { this.props.children }
      </View>
    )
  };

  render() {
    return (
      <View style={ styles.container }>
        <View style={ styles.subMenuNav }>
          <TextTheme size={Dimensions.get('window').width >= 1024 ? 11 : 8}>{ this.props.title }</TextTheme>
          <View style={styles.iconStyles}>
            <Icon name={ this.props.iconName }/>
          </View>
          <TextTheme size={Dimensions.get('window').width >= 1024 ? 11 : 8} lowCase>{ this.props.text }</TextTheme>
        </View>
        {this.renderChildren()}
      </View>
    )
  }
}

const styles = EStyleSheet.create({
  container: {
    flex: 1
  },
  subMenuNav: {
    alignItems: 'center',
    justifyContent: 'center',
    height: '50%',
    backgroundColor: 'rgba(28,42,57, .7)',
    marginBottom: 1
  },
  iconStyles: {
    padding: 5
  },
  buttonsContainer: {
    height: '50%',
    flexDirection: 'row'
  }
});

export default SettingsSubNav;
