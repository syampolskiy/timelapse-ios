import React, { Component } from 'react';
import { ScrollView, Text, View } from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet'

class ScrollMenu extends Component {
  state = {
    activeItem: null
  };

  handlePressItem = (index) => {
    this.setState({ activeItem: index })
  };

  getActiveItemStyle = (index) => {
    if (this.state.activeItem === index) {
      return { backgroundColor: 'rgba(28, 42, 57, .8)' }
    }
  };

  centerText = () => {
    if (this.props.centered) {
      return {
        textAlign: 'center'
      }
    }
  };

  render() {
    return (
      <View style={styles.container}>
        <ScrollView>
          {this.props.data.map((item, index) =>
            <Text
              key={index}
              style={[styles.item, this.getActiveItemStyle(index), this.centerText()]}
                               onPress={() => {this.props.handlePress !== undefined ? this.props.handlePress(this.props.navButtonIndex, index, this.props.pickSettings) : this.handlePressItem(index)}}
            >
              {item}
            </Text>
          )}
        </ScrollView>
      </View>
    )
  }
}

const styles = EStyleSheet.create({
  item: {
    color: '#FFF',
    padding: 4
  },
  container: {
    width: '100%',
    paddingTop: 10,
    paddingBottom: 10,
    paddingLeft: 6,
    paddingRight: 6,
    backgroundColor: 'rgba(28, 42, 57, .7)',
  },
  '@media (max-width: 568)': {
    item: {
      padding: 2
    }
  },
  '@media (min-width: 1024)': {
    container: {
      paddingTop: 20,
      paddingBottom: 20,
    },
    item: {
      fontSize: 20
    }
  }
});

export default ScrollMenu;
