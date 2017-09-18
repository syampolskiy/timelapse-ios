import React, { Component } from 'react';
import {
    StyleSheet,
    Text,
    View,
    Slider
} from 'react-native';

class NavSlider extends Component {
    constructor(props) {
        super(props)
        this.state = { sval: props.value / this.props.valueMultiplier}
    }

    render() {
        
        return (
                <View style={styles.container}>
                
                    <Slider
                        style={{ width: 300 }}
                        step={1}
                        minimumValue={this.props.minimumValue}
                        maximumValue={this.props.maximumValue}
                        value={this.state.sval }
                        onValueChange={val =>
                            this.setState({ sval: val })}
                        onSlidingComplete={ val =>
                            this.props.onSlidingComplete(this.props.navButtonIndex,
                                                ((val*this.props.valueMultiplier).toFixed(this.props.precNb)).toString().concat(this.props.trSymb),
                                                this.props.pickSettings)}
                    />
                    <Text style={styles.welcome}>
                        {(this.state.sval * this.props.valueMultiplier).toFixed(this.props.precNb)}{this.props.trSymb}
                    </Text>
                </View>
                );
    }
}

const styles = StyleSheet.create({
                                 container: {
                                 flex: 1,
                                 justifyContent: 'center',
                                 alignItems: 'center',
                                 backgroundColor: 'rgba(28,42,57, .7)',
                                 },
                                 welcome: {
                                 fontSize: 20,
                                 textAlign: 'center',
                                 margin: 10,
                                 },
                                 instructions: {
                                 textAlign: 'center',
                                 color: '#333333',
                                 marginBottom: 5,
                                 },
                                 });
export default NavSlider;
