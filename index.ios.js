import React, { Component } from 'react';
import { AppRegistry } from 'react-native';
import Index from "./src/components/Index";

export default class RNCameraApp extends Component {
    render() {
        return (
            <Index/>
        );
    }
}

AppRegistry.registerComponent('RNCameraApp', () => RNCameraApp);

