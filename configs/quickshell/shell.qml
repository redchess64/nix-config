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

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }

  //the below is a edited snippet from https://github.com/Ly-sec/Noctalia/ subject to the following copyright notice:
  //MIT License
  //
  //Copyright (c) 2025 Ly-sec
  //
  //Permission is hereby granted, free of charge, to any person obtaining a copy
  //of this software and associated documentation files (the "Software"), to deal
  //in the Software without restriction, including without limitation the rights
  //to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  //copies of the Software, and to permit persons to whom the Software is
  //furnished to do so, subject to the following conditions:
  //
  //The above copyright notice and this permission notice shall be included in all
  //copies or substantial portions of the Software.
  Process {
    id: eventStream
    running: true
    command: ["niri", "msg", "--json", "event-stream"]

    stdout: SplitParser {
      onRead: data => {
        try {
          const event = JSON.parse(data.trim());

          if (event.OverviewOpenedOrClosed) {
            try {
              root.displayed = event.OverviewOpenedOrClosed.is_open === true;
            } catch (e) {
              console.error("Error parsing overview state:", e);
            }
          }
        } catch (e) {
          console.error("Error parsing event stream:", e, data);
        }
      }
    }
  }
}
