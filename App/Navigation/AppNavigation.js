import React from 'react'
import { createStackNavigator, createAppContainer, createBottomTabNavigator } from 'react-navigation'
import { Image } from 'react-native'
import Icon from 'react-native-vector-icons/FontAwesome'
import Me from '../Containers/Me'
import Order from '../Containers/Order'
import Task from '../Containers/Task'
import Home from '../Containers/Home'
import LaunchScreen from '../Containers/LaunchScreen'

import styles from './Styles/NavigationStyles'

const TabNavigator = createBottomTabNavigator(
  {
    Home: {
      screen: Home,
      navigationOptions: {
        tabBarVisible: true,
        tabBarLabel: '网红刷粉',
        tabBarIcon: ({focused, horizontal, tintColor}) => <Image source={require('../Images/网红刷粉.png')}
                                                               style={[styles.icon, {tintColor: tintColor}]} />
      }
    },
    Task: {
      screen: Task,
      navigationOptions: {
        tabBarVisible: true,
        tabBarLabel: '刷手任务',
        tabBarIcon: ({focused, horizontal, tintColor}) => <Image source={require('../Images/刷手任务.png')}
                                                                 style={[styles.icon, {tintColor: tintColor}]} />
      }},
    Order: {
      screen: Order,
      navigationOptions: {
        tabBarVisible: true,
        tabBarLabel: '订单',
        tabBarIcon: ({focused, horizontal, tintColor}) => <Image source={require('../Images/订单.png')}
                                                                 style={[styles.icon, {tintColor: tintColor}]} />
      }},
    Me: {
      screen: Me,
      navigationOptions: {
        tabBarVisible: true,
        tabBarLabel: '我的',
        tabBarIcon: ({focused, horizontal, tintColor}) => <Image source={require('../Images/我的.png')}
                                                                 style={[styles.icon, {tintColor: tintColor}]} />
      }}
  },
  {
    initialRouteName: 'Home',
    tabBarOptions: {
      activeTintColor: '#e91e63',
      labelStyle: {
        fontSize: 12,
      },
      style: {
        backgroundColor: '#c5bfc1',
      },
    }
  }
)
// Manifest of possible screens
const PrimaryNav = createStackNavigator({
  TabScreen: TabNavigator,
  LaunchScreen: {screen: LaunchScreen}
}, {
  // Default config for all screens
  headerMode: 'none',
  mode: 'card',
  initialRouteName: 'TabScreen',
  // 默认标题栏样式
  defaultNavigationOptions: {
    headerStyle: {
      backgroundColor: '#f4511e',
    },
    headerTintColor: '#fff',
    headerTitleStyle: {
      fontWeight: 'bold',
    },
  },
})

export default createAppContainer(PrimaryNav)
