import React, { Component } from 'react';
import { View } from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet';
import StatusIcon from '../components/StatusIcon';
import LinearGradient from 'react-native-linear-gradient';

const initialState = {
  menuActiveSections: [
    [
      { iconName: "res", text: "2K" },
      { iconName: "shutter", text: "10" }
    ],
    [
      { iconName: "format", text: "8-bit" },
      { iconName: "fps", text: "30" }
    ],
    [
      { iconName: "iso", text: "400" },
      { iconName: "balance", text: "5200" }
    ],
    [
      { iconName: "sharpness", text: "50%" },
      { iconName: "exposure", text: "1.0" }
    ],
    [
      { iconName: "saturation", text: "50%" },
      { iconName: "contrast", text: "50%" }
    ],
    [
      { iconName: "speed", text: "x3" }
    ]

  ],
  menuInactiveSections: [
    [
      { iconName: "res", text: "2K" },
    ],
    [
      { iconName: "format", text: "8-bit" },
    ],
    [
      { iconName: "iso", text: "400" },
    ],
    [
      { iconName: "shutter", text: "10" } // 1/180
    ],
    [
      { iconName: "speed", text: "OFF" },
    ]
  ]
};

const formatValues = ["8 bit", "12 bit", "16 bit"];

class StatusBar extends Component {
  state = initialState;

    
    componentWillReceiveProps(nextProps) {
        this.state.menuActiveSections[0][0].text = nextProps.resolution;
        this.state.menuActiveSections[0][1].text = nextProps.shutterspeed + "ms";
        this.state.menuActiveSections[1][0].text = formatValues[nextProps.pixFmtInd];
        this.state.menuActiveSections[1][1].text = nextProps.fps;
        this.state.menuActiveSections[2][0].text = nextProps.iso;
        this.state.menuActiveSections[2][1].text = nextProps.awb + "K";
        this.state.menuActiveSections[3][0].text = nextProps.sharpness;
        this.state.menuActiveSections[3][1].text = nextProps.exposure;
        this.state.menuActiveSections[4][0].text = nextProps.saturation;
        this.state.menuActiveSections[4][1].text = nextProps.contrast;
        //
        this.state.menuInactiveSections[0][0].text = nextProps.resolution;
        this.state.menuInactiveSections[1][0].text = formatValues[nextProps.pixFmtInd];
        this.state.menuInactiveSections[2][0].text = nextProps.iso;
        this.state.menuInactiveSections[3][0].text = nextProps.shutterspeed + "ms";
    }

    
  renderContainer() {
    if (this.props.settingsNavActive) {
      return (
          <LinearGradient
              colors={[
                  'rgba(28, 42, 57, .7)',
                  'rgba(28, 42, 57, .7)',
                  'transparent',
                  'transparent',
                  'rgba(28, 42, 57, .7)',
                  'rgba(28, 42, 57, .7)'
              ]}
              locations={[0, 0.47, 0.47, 0.53, 0.53, 1]}
              style={styles.container}>
            <View style={styles.inner}>
                {this.renderSections(this.state.menuActiveSections)}
            </View>

          </LinearGradient>
      )
    } else {
      return (
        <View style={ styles.oneRowContainer }>
          {this.renderSections(this.state.menuInactiveSections)}
        </View>
      )
    }
  }

  renderSections = (data) => {
    return data.map((item, index) => {
      return <View key={index} style={styles.sectionContainer}>
        {item.map((item, index) => <StatusIcon key={index} iconName={item.iconName} text={item.text}/>)}
      </View>
    })
  };

  render() {
      /*
    this.state.menuActiveSections[0][0].text = this.props.resolution;
    this.state.menuActiveSections[0][1].text = this.props.shutterspeed + "ms";
    this.state.menuActiveSections[1][0].text = formatValues[this.props.pixFmtInd];
    this.state.menuActiveSections[1][1].text = this.props.fps;
    this.state.menuActiveSections[2][0].text = this.props.iso;
    this.state.menuActiveSections[2][1].text = this.props.awb + "K";
    this.state.menuActiveSections[3][0].text = this.props.sharpness;
    this.state.menuActiveSections[3][1].text = this.props.exposure;
    this.state.menuActiveSections[4][0].text = this.props.saturation;
    this.state.menuActiveSections[4][1].text = this.props.contrast;
    //
    this.state.menuInactiveSections[0][0].text = this.props.resolution;
    this.state.menuInactiveSections[1][0].text = formatValues[this.props.pixFmtInd];
    this.state.menuInactiveSections[2][0].text = this.props.iso;
    this.state.menuInactiveSections[3][0].text = this.props.shutterspeed + "ms";
*/
    return (
      <View style={ styles.mainContainer }>
        {this.renderContainer()}
      </View>
    )
  }
}

const styles = EStyleSheet.create({
  mainContainer: {
    height: '18.76%',
    marginBottom: '.65%',
    zIndex: 2
  },
  container: {
    width: '100%',
    height: '100%'
  },
  inner: {
    justifyContent: 'space-between',
    flexDirection: 'row',
    padding: 4,
    paddingRight: 7,
    paddingLeft: 7,
    alignContent: 'stretch',
    height: '100%'
  },
  sectionContainer: {
    justifyContent: 'space-between',
    backgroundColor: 'transparent'
  },
  oneRowContainer: {
    flexDirection: 'row',
    padding: 4,
    paddingRight: 30,
    paddingLeft: 7,
    backgroundColor: 'rgba(28, 42, 57, .7)',
    justifyContent: 'space-between',
    zIndex: 2
  },
  '@media (max-width: 568)': {
    mainContainer: {
      height: '22%'
    }
  },
  '@media (min-width: 1024)': {
    container: {
      paddingTop: 5,
      paddingBottom: 5
    },
    oneRowContainer: {
      padding: 7
    },
    mainContainer: {
      height: '16%',
      marginBottom: '.65%',
      zIndex: 2
    },
  }
});


export default StatusBar;
