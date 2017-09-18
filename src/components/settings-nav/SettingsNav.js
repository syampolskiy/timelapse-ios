import React, { Component } from 'react';
import { View } from 'react-native';
import EStyleSheet from 'react-native-extended-stylesheet';
import NavButton from './NavButton';
import NavSlider from '../../containers/NavSlider';
import SettingsSubNav from './SettingsSubNav';
import SubNavButton from './SubNavButton';
import ScrollMenu from '../../containers/ScrollMenu';

const navButtons = [
  { title: "resolution", text: "2K", iconName: "res", active:1 },
  { title: "format", text: "8 bit", iconName: "format", active:1 },
  { title: "iso", text: "400", iconName: "iso", active:1 },
  { title: "sharpness", text: "50%", iconName: "sharpness", active:1 },
  { title: "saturation", text: "50%", iconName: "saturation", active:1 },
  { title: "timelapse", text: "x2", iconName: "speed", active:1 },
  { title: "shutterspeed", text: "10", iconName: "shutter", active:1 },
  { title: "fps", text: "30", iconName: "fps", active:1 },
  { title: "awb", text: "5200", iconName: "balance", active:1 },
  { title: "exposure", text: "1.0", iconName: "exposure", active:1 },
  { title: "contrast", text: "50%", iconName: "contrast", active:1 },
  { title: "brightness", text: "0%", iconName: "brightness", active:1 }
];

const subNavButtons = [
  { title: "resolution", text: "2K", iconName: "res", buttons: ["2K", "1K"] },
  { title: "format", text: "8 bit", iconName: "format", buttons: ["8 bit", "12 bit", "16 bit"] },
  { title: "iso", text: "400", iconName: "iso", list: ["Auto", "400", "500", "600", "700", "800", "900", "1000", "1100", "1200"] },
  { title: "sharpness", text: "50%", iconName: "sharpness", slider: [0, 100, 1, 0], trSymb: "%"  },
  { title: "saturation", text: "50%", iconName: "saturation", slider: [0, 100, 1, 0], trSymb: "%" },
  { title: "timelapse", text: "x2", iconName: "timelapse", buttons: ["x1", "x2", "x3"] },
  { title: "shutterspeed", text: "10", iconName: "shutter", list: ["Auto", "1000", "500", "250", "125", "60", "30", "15", "8", "4", "2", "1"]/*denominators*/ },
  { title: "fps", text: "30", iconName: "fps", list: ["30", "60", "90"] }, // fps should not be able under auto-control
  { title: "awb", text: "5200", iconName: "balance", custom: -6, iconlist:
                       [{iconName:"wb_auto", text:"Auto", value:"2000"},
                        {iconName:"wb_daylight", text:"Daylight", value:"5200"},
                        {iconName:"wb_shade", text:"Shade", value:"7000"},
                        {iconName:"wb_cloudy", text:"Cloudy,twilight,sunset", value:"6000"},
                        {iconName:"wb_tungstenLight", text:"Tungsten light", value:"3200"},
                        {iconName:"wb_fluorescentLight", text:"Fluorescent light", value:"4000"},
                        {iconName:"wb_custom", text:"Custom", value:"4444"}] },
  { title: "exposure", text: "1.0", iconName: "exposure", slider: [-75, 24, 0.1, 1], trSymb: ""},
  { title: "contrast", text: "50%", iconName: "contrast", slider: [0, 100, 1, 0], trSymb: "%" },
  { title: "brightness", text: "0%", iconName: "brightness", slider: [0, 100, 1, 0], trSymb: "%"}
];

const formatValues = ["8 bit", "12 bit", "16 bit"];

const initialState = {
  navButtons,
  subNavButtons,
  navButtonsActive: true,
  activeItem: null
};

class SettingsNav extends Component {
    state = initialState;
    
    nearest_shutter (text_ms) {
        abs_ms = Math.abs(parseFloat(text_ms));
        curr_res = "1/" + subNavButtons[6].list[1];
        curr_ms = 1000.0 / parseFloat(subNavButtons[6].list[1]);
        
        diff = Math.abs (abs_ms - curr_ms);
        for (var val = 1; val < subNavButtons[6].list.length; val++) {
            var newdiff = Math.abs (abs_ms - 1000.0 / parseFloat(subNavButtons[6].list[val]));
            if (newdiff < diff) {
                diff = newdiff;
                curr_res = "1/" + subNavButtons[6].list[val];
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
        this.state.navButtons[3].text = nextProps.sharpness;
        this.state.navButtons[4].text = nextProps.saturation;
//        this.state.navButtons[6].text = txt_new_shutter_nearest;
        this.state.navButtons[6].text = parseFloat(nextProps.shutterspeed) < 0 ? "Auto" : txt_new_shutter_nearest;
        this.state.navButtons[7].text = parseFloat(nextProps.fps) < 0 ? "Auto" : nextProps.fps;
        this.state.navButtons[8].text = parseFloat(nextProps.awb) < 0 ? "Auto" : nextProps.awb + "K";
//        this.state.navButtons[9].text = nextProps.isAutoExposure ? "Auto" : nextProps.exposure;
//        this.state.navButtons[9].active = nextProps.isAutoExposure == 0 ? 1 : 0;
        this.state.navButtons[9].text = nextProps.exposure;
        this.state.navButtons[10].text = nextProps.contrast;
        this.state.navButtons[11].text = nextProps.brightness;
        //
        this.state.subNavButtons[0].text = nextProps.resolution;
        this.state.subNavButtons[1].text = formatValues[nextProps.pixFmtInd];
        this.state.subNavButtons[2].text = parseFloat(nextProps.iso) < 0 ? "Auto" : nextProps.iso;
        this.state.subNavButtons[3].text = nextProps.sharpness;
        this.state.subNavButtons[4].text = nextProps.saturation;
        this.state.subNavButtons[6].text = parseFloat(nextProps.shutterspeed) < 0 ? "Auto" : txt_new_shutter_nearest;
        this.state.subNavButtons[7].text = parseFloat(nextProps.fps) < 0 ? "Auto" : nextProps.fps;
        this.state.subNavButtons[8].text = parseFloat(nextProps.awb) < 0 ? "Auto" : nextProps.awb + "K";
//        this.state.subNavButtons[9].text = nextProps.isAutoExposure ? "Auto" : nextProps.exposure;
        this.state.subNavButtons[9].text = nextProps.exposure;
        this.state.subNavButtons[10].text = nextProps.contrast;
        this.state.subNavButtons[11].text = nextProps.brightness;
    }
    
    updateInitialState = (navButtonIndex, subNavButtonIndex, pickSettings) => {
        var st = initialState;
        
        if (st.subNavButtons[navButtonIndex].buttons !== undefined)
            st.navButtons[navButtonIndex].text = st.subNavButtons[navButtonIndex].buttons[subNavButtonIndex];
        else if (st.subNavButtons[navButtonIndex].list !== undefined)
            st.navButtons[navButtonIndex].text = st.subNavButtons[navButtonIndex].list[subNavButtonIndex];
        else if (st.subNavButtons[navButtonIndex].slider !== undefined) {
//            st.navButtons[navButtonIndex].text = subNavButtonIndex.toString().concat("%");
//            st.subNavButtons[navButtonIndex].text = subNavButtonIndex.toString().concat("%");
            st.navButtons[navButtonIndex].text = subNavButtonIndex;
            st.subNavButtons[navButtonIndex].text = subNavButtonIndex;
        }
        else if (st.subNavButtons[navButtonIndex].iconlist !== undefined)
        {
            // Iconed-buttons mode
            if (st.subNavButtons[navButtonIndex].custom < 0)
            {
                st.navButtons[navButtonIndex].text = st.subNavButtons[navButtonIndex].iconlist[subNavButtonIndex].value;

                // Turn to slider mode
                if (subNavButtonIndex == -st.subNavButtons[navButtonIndex].custom)
                {
                    st.subNavButtons[navButtonIndex].custom = -st.subNavButtons[navButtonIndex].custom;
                    st.navButtonsActive = false;
                    st.activeItem = navButtonIndex;
                }
            }
            else
            {
                st.subNavButtons[navButtonIndex].iconlist[st.subNavButtons[navButtonIndex].custom].value = subNavButtonIndex;
                st.navButtons[navButtonIndex].text = subNavButtonIndex;
                st.subNavButtons[navButtonIndex].text = subNavButtonIndex;

                st.subNavButtons[navButtonIndex].custom = -st.subNavButtons[navButtonIndex].custom;
                st.navButtonsActive = true;
                st.activeItem = null;
            }
        }
        
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

  renderNavButtons = () => {
    return this.state.navButtons.map((item, index) => {
      return <NavButton
        key={index}
        index={index}
        title={item.title}
        text={item.text}
        active={item.active}
        iconName={item.iconName}
        handlePress={this.assignActiveItem}
      />
    })
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
    
    renderIconList (navButtonIndex, elem) {
        if (elem.custom < 0)
            return (elem.iconlist.map((item, index) =>
                            <NavButton
                                  key={index}
                                  navButtonIndex={navButtonIndex}
                                  index={index}
                                  title={item.text}
                                  text={item.value}
                                  active={1}
                                  width={"14.28%"}
                                  height={"100%"}
                                  iconName={item.iconName}
                                  handlePress={this.updateInitialState}
                                  pickSettings={this.props.pickSettings}
                            />));
        else
            return (<NavSlider centered
                            value={parseFloat(elem.text)}
                            minimumValue={2000}
                            maximumValue={10000}
                            precNb={0}
                            valueMultiplier={1}
                            trSymb={"K"}
                            onSlidingComplete={this.updateInitialState}
                            navButtonIndex={navButtonIndex}
                            pickSettings={this.props.pickSettings}
                    />);
        
    };

  renderSubNavButton = (navButtonIndex, item) => {
    if (item && (item.buttons !== undefined || item.list !== undefined || item.slider !== undefined || item.iconlist !== undefined)) {
      return (
        <SettingsSubNav title={item.title} text={item.text} iconName={item.iconName}>
          {item.buttons ? item.buttons.map((it, index) =>
                                        <SubNavButton
                                           key={index}
                                           handlePress={this.updateInitialState}
                                           pickSettings={this.props.pickSettings}
                                           navButtonIndex={navButtonIndex}
                                           index={index}
                                           text={it}
                                           width={(100.0/item.buttons.length).toString()+"%"}
                                        />)
              : item.list ? this.renderList(navButtonIndex, item)
              : item.iconlist ? this.renderIconList(navButtonIndex, item)
              : item.slider ? <NavSlider centered
                                value={item.trSymb.length > 0 ? parseInt(item.text.slice(0,-1)):
                                                                        parseFloat(item.text)}
                                minimumValue={item.slider[0]}
                                maximumValue={item.slider[1]}
                                valueMultiplier={item.slider[2]}
                                precNb={item.slider[3]}
                                trSymb={item.trSymb}
                                onSlidingComplete={this.updateInitialState}
                                navButtonIndex={navButtonIndex}
                                pickSettings={this.props.pickSettings}
                              />
              : null}
        </SettingsSubNav>
      )
    } else if(item) {
      return <SettingsSubNav title={item.title} text={item.text} iconName={item.iconName}/>
    }
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
    justifyContent: 'space-between'
  }
});

export default SettingsNav;
