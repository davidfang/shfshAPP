import { StyleSheet } from 'react-native'
import { Colors ,ScreenUtil} from '../../Themes/'

export default StyleSheet.create({
  header: {
    backgroundColor: Colors.backgroundColor
  },
  icon: {
    width: ScreenUtil.scaleSize(18),
    height: ScreenUtil.scaleSize(18)
  }
})
