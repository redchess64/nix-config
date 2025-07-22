import Quickshell
import Quickshell.Widgets
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string time
  property bool displayed

  Variants {
    model: Quickshell.screens

    PanelWindow {
      property var modelData
      screen: modelData
      color: "#6c7086"
      visible: root.displayed

      anchors {
        top: true
        //left: true
        right: true
      }

      implicitHeight: 30
      implicitWidth: 225


      Text {
        color: "#cdd6f4"
        anchors.centerIn: parent
        font.pointSize: 12
        text: root.time
      }
    }
  }

  Process {
    id: dateProc
    command: ["date", "+%a, %F %I:%M %p"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.time = this.text
    }
  }
  Process {
    id: overviewProc
    command: ["niri", "msg", "-j", "overview-state"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.displayed = JSON.parse(this.text).is_open
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }
  Timer {
    interval: 10
    running: true
    repeat: true
    onTriggered: overviewProc.running = true
  }
}
