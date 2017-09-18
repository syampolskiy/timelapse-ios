import React, { Component } from 'react';
import { View } from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet';
import NavButton from './settings-nav/NavButton';
import SettingsSubNav from './settings-nav/SettingsSubNav';
import SubNavButton from './settings-nav/SubNavButton';
import ScrollMenu from '../containers/ScrollMenu';

// names and values according to CamAppBridge::pickSettings
const navButtons = [
  { title: "resolution", text: "2K", iconName: "res", active:1 },
  { title: "format", text: "8 bit", iconName: "format", active:1 },
  { title: "iso", text: "400", iconName: "iso", active:1 },
  { title: "shutterspeed", text: "10", iconName: "shutter", active:1 },
  { title: "fps", text: "30", iconName: "fps", active:1 },
  { title: "timelapse", text: "x2", iconName: "speed", active:1 }
];

const subNavButtons = [
  { title: "resolution", text: "2K", iconName: "res", buttons: ["2K", "1K"] },
  { title: "format", text: "8 bit", iconName: "format", buttons: ["8 bit", "12 bit", "16 bit"] },
  { title: "iso", text: "400", iconName: "iso", list: ["Auto", "400", "500", "600", "700", "800", "900", "1000", "1100", "1200"] },
  { title: "shutterspeed", text: "10", iconName: "shutter", list: ["Auto", "1000", "500", "250", "125", "60", "30", "15", "8", "4", "2", "1"]/*denominators*/ },
  { title: "fps", text: "30", iconName: "fps", list: ["30", "60", "90"] }, // fps should not be able under auto-control
  { title: "timelapse", text: "x2", iconName: "speed", buttons: ["x1", "x2", "x3"] }
];

const formatValues = ["8 bit", "12 bit", "16 bit"];

const initialState = {
  navButtons,
  subNavButtons,
  navButtonsActive: true,
  activeItem: null
};

class MainNav extends Component {
  state = initialState;

    constructor(props) {
        super(props);
        //
        this.state = initialState;
    }
    
    nearest_shutter (text_ms) {
        abs_ms = Math.abs(parseFloat(text_ms));
        curr_res = "1/" + subNavButtons[3].list[1];
        curr_ms = 1000.0 / parseFloat(subNavButtons[3].list[1]);
        
        diff = Math.abs (abs_ms - curr_ms);
        for (var val = 1; val < subNavButtons[3].list.length; val++) {
            var newdiff = Math.abs (abs_ms - 1000.0 / parseFloat(subNavButtons[3].list[val]));
            if (newdiff < diff) {
                diff = newdiff;
                curr_res = "1/" + subNavButtons[3].list[val];
            }
        }
        return curr_res;
    }
    
    componentWillReceiveProps(nextProps) {
        txt_new_shutter_nearest = this.nearest_shutter(nextProps.shutterspeed);
        
        this.state.navButtons[0].text = nextProps.resolution;
        this.state.navButtons[1].text = formatValues[nextProps.pixFmtInd];
        this.state.navButtons[1].active = nextProps.startStopWriting == 0 ? 1 : 0;
        this.state.navButtons[2].text = parseFloat(nextProps.iso) < 0 ? "Auto" : nextProps.iso;
        this.state.navButtons[3].text = txt_new_shutter_nearest;
        this.state.navButtons[4].text = parseFloat(nextProps.fps) < 0 ? "Auto" : nextProps.fps;
        //
        this.state.subNavButtons[0].text = nextProps.resolution;
        this.state.subNavButtons[1].text = formatValues[nextProps.pixFmtInd];
        this.state.subNavButtons[2].text = parseFloat(nextProps.iso) < 0 ? "Auto" : nextProps.iso;
        this.state.subNavButtons[3].text = parseFloat(nextProps.shutterspeed) < 0 ? "Auto" : txt_new_shutter_nearest;
        this.state.subNavButtons[4].text = parseFloat(nextProps.fps) < 0 ? "Auto" : nextProps.fps;
    }
    
  updateInitialState = (navButtonIndex, subNavButtonIndex, pickSettings) => {
     var st = initialState;
      
     if (st.subNavButtons[navButtonIndex].buttons !== undefined)
       st.navButtons[navButtonIndex].text = st.subNavButtons[navButtonIndex].buttons[subNavButtonIndex];
     else
       st.navButtons[navButtonIndex].text = st.subNavButtons[navButtonIndex].list[subNavButtonIndex];
     
     if (pickSettings !== undefined)
         pickSettings(st.navButtons[navButtonIndex].title, st.navButtons[navButtonIndex].text);
     
     this.setState(st)
  };
    
  assignActiveItem = (index) => {
    this.setState({
      activeItem: index,
      navButtonsActive: false
    });
  };
    
  renderList (navButtonIndex, item) {
      listFiltered = item.list;
      
      if (item.title.localeCompare("shutterspeed") == 0) {
          // Filter shutterspeed list ONLY if FPS in manual-mode.
          if (parseFloat(this.props.fps) > 0) {
              frameTime = 1000.0 / Math.abs(parseFloat(this.props.fps));
              listFiltered = item.list.filter(function(den){
                                          return den.localeCompare("Auto")==0 ||
                                                1000.0 / parseFloat(den) <= frameTime;
                                           });
          }
          // Map to "1/denominator" view
          listFiltered = listFiltered.map(function(den){
                                          return den.localeCompare("Auto")==0 || den.localeCompare("1")==0 ? den : "1/".concat(den);
                                          });
      }
      // Filter FPS list ONLY if SHUTTERSPEED in manual-mode.
      /*
      if (item.title.localeCompare("fps") == 0 && parseFloat(this.props.shutterspeed) > 0) {
          shutterFps = 1000.0 / Math.abs(parseFloat(this.props.shutterspeed));
          listFiltered = item.list.filter(function(fps){
                                          return fps.localeCompare("Auto")==0 ||
                                          parseFloat(fps) <= shutterFps;
                                          });
      }
       */
    
      return (<ScrollMenu centered
                data={listFiltered}
                navButtonIndex={navButtonIndex}
                handlePress={this.updateInitialState}
                pickSettings={this.props.pickSettings}/>)
  };

  renderSubNavButton = (navButtonIndex, item) => {
    if (item && (item.buttons !== undefined || item.list !== undefined)) {
      return (
        <SettingsSubNav title={item.title} text={item.text} iconName={item.iconName}>
          {item.buttons ? item.buttons.map((it, index) =>
                                           <SubNavButton
                                           key={index}
                                           handlePress={this.updateInitialState}
                                           pickSettings={this.props.pickSettings}
                                           navButtonIndex={navButtonIndex}
                                           index={index}
                                           width={(100.0/item.buttons.length).toString()+"%"}
                                           text={it}/>)
              : item.list ? this.renderList(navButtonIndex, item)
              : null}
        </SettingsSubNav>
      )
    } else if (item) {
      return <SettingsSubNav title={item.title} text={item.text} iconName={item.iconName}/>
    }
  };

  renderNavButtons = () => {
    return this.state.navButtons.map((item, index) => {
      return <NavButton
        key={index}
        index={index}
        title={item.title}
        text={item.text}
        active={item.active}
        width="33.1%"
        handlePress={this.assignActiveItem}
        iconName={item.iconName}
      />
    })
  };

  render() {
    return (
      <View style={styles.container}>
        {this.state.navButtonsActive ? this.renderNavButtons() : null}
        {this.state.activeItem !== null ? this.renderSubNavButton(this.state.activeItem, this.state.subNavButtons[this.state.activeItem]) : null}
      </View>
    )
  }
}

const styles = EStyleSheet.create({
  container: {
    flexDirection: 'row',
    flex: 1,
    flexWrap: 'wrap',
    justifyContent: 'flex-end'
  }
});

export default MainNav;
