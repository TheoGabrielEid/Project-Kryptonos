import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: root
    width: 1920
    height: 1200
    color: "#11111b"

    property int selectedUserIndex: (userModel && userModel.lastIndex >= 0) ? userModel.lastIndex : 0
    property int sessionIndex: (sessionModel && sessionModel.lastIndex >= 0) ? sessionModel.lastIndex : 0
    property bool showPassword: false

    // Background Wallpaper
    Image {
        id: bgImage
        anchors.fill: parent
        source: "/usr/share/backgrounds/krypton/krypton-default.png"
        fillMode: Image.PreserveAspectCrop
        smooth: true
        asynchronous: false
    }

    // Multi-Stop Glassmorphic Dark Gradient Vignette Overlay
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#a611111b" }
            GradientStop { position: 0.5; color: "#73181825" }
            GradientStop { position: 1.0; color: "#cc11111b" }
        }
    }

    // Subtle Ambient Purple Top Glow
    Rectangle {
        width: 720
        height: 320
        radius: 160
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: -180
        color: "#22cba6f7"
    }

    // =========================================================================
    // TOP BAR: System Status Badge + Live Clock Pill + Power Controls
    // =========================================================================
    Item {
        id: topBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 28
        height: 44

        // Top-Left Distro Badge
        Rectangle {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: 40
            width: brandRow.width + 32
            radius: 20
            color: "#cc181825"
            border.color: "#44cba6f7"
            border.width: 1

            Row {
                id: brandRow
                anchors.centerIn: parent
                spacing: 10

                Text {
                    text: "⬢"
                    color: "#cba6f7"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "KryptonOS  •  Hyprland Wayland"
                    color: "#cdd6f4"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 13
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        // Top-Center Live Date & Time Pill
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            height: 40
            width: topClockText.width + 36
            radius: 20
            color: "#cc181825"
            border.color: "#3389b4fa"
            border.width: 1

            Text {
                id: topClockText
                anchors.centerIn: parent
                color: "#cdd6f4"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 13
                font.bold: true
                text: Qt.formatDateTime(new Date(), "ddd, MMM d   •   hh:mm:ss AP")
            }
        }

        // Top-Right Power & Reboot Buttons
        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 12

            // Reboot Button
            Rectangle {
                width: 118
                height: 40
                radius: 20
                color: rebootMouse.containsMouse ? "#313244" : "#cc181825"
                border.color: rebootMouse.containsMouse ? "#89b4fa" : "#45475a"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "󰜉  Reboot"
                    color: rebootMouse.containsMouse ? "#89b4fa" : "#cdd6f4"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 13
                    font.bold: true
                }

                MouseArea {
                    id: rebootMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.reboot()
                }
            }

            // Shutdown Button
            Rectangle {
                width: 134
                height: 40
                radius: 20
                color: powerMouse.containsMouse ? "#3b2230" : "#cc181825"
                border.color: powerMouse.containsMouse ? "#f38ba8" : "#45475a"
                border.width: 1

                Text {
                    anchors.centerIn: parent
                    text: "⏻  Power Off"
                    color: powerMouse.containsMouse ? "#f38ba8" : "#cdd6f4"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 13
                    font.bold: true
                }

                MouseArea {
                    id: powerMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: sddm.powerOff()
                }
            }
        }
    }

    // =========================================================================
    // CENTER GLASSMORPHIC LOGIN CARD
    // =========================================================================
    // Outer Neon Glow Frame
    Rectangle {
        width: loginCard.width + 8
        height: loginCard.height + 8
        anchors.centerIn: parent
        radius: 28
        color: "#1acba6f7"
        border.color: "#33cba6f7"
        border.width: 1
    }

    Rectangle {
        id: loginCard
        width: 440
        height: 550
        anchors.centerIn: parent
        radius: 24
        color: "#e6181825"
        border.color: "#cba6f7"
        border.width: 2

        // Inner Top Subtle Accent Bar
        Rectangle {
            width: 140
            height: 4
            radius: 2
            anchors.top: parent.top
            anchors.topMargin: 14
            anchors.horizontalCenter: parent.horizontalCenter
            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#89b4fa" }
                GradientStop { position: 0.5; color: "#cba6f7" }
                GradientStop { position: 1.0; color: "#f5c2e7" }
            }
        }

        Column {
            anchors.fill: parent
            anchors.topMargin: 34
            anchors.bottomMargin: 28
            anchors.leftMargin: 38
            anchors.rightMargin: 38
            spacing: 14

            // Avatar Ring with KryptonOS Crystal Shield Logo
            Rectangle {
                width: 96
                height: 96
                radius: 48
                anchors.horizontalCenter: parent.horizontalCenter
                color: "#1e1e2e"
                border.color: "#cba6f7"
                border.width: 2

                Image {
                    width: 68
                    height: 68
                    anchors.centerIn: parent
                    source: "/usr/share/pixmaps/kryptonos.png"
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
            }

            // Large Hero Time & Welcome Header
            Column {
                width: parent.width
                spacing: 4

                Text {
                    id: bigClock
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDateTime(new Date(), "hh:mm")
                    color: "#cdd6f4"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 34
                    font.bold: true
                }

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "Welcome to KryptonOS"
                    color: "#cba6f7"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    font.bold: true
                }

                Text {
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                    text: "Enter your credentials to unlock your workspace"
                    color: "#a6adc8"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 12
                }
            }

            // Spacer
            Item { width: 1; height: 4 }

            // USERNAME INPUT FIELD
            Column {
                width: parent.width
                spacing: 6

                Text {
                    text: "USER ACCOUNT"
                    color: "#89b4fa"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    font.bold: true
                }

                Rectangle {
                    id: userBox
                    width: parent.width
                    height: 46
                    radius: 12
                    color: "#11111b"
                    border.color: userInput.activeFocus ? "#cba6f7" : "#313244"
                    border.width: userInput.activeFocus ? 2 : 1

                    Text {
                        id: userIcon
                        anchors.left: parent.left
                        anchors.leftMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        text: "👤"
                        font.pixelSize: 15
                        color: "#cba6f7"
                    }

                    TextInput {
                        id: userInput
                        anchors.left: userIcon.right
                        anchors.leftMargin: 10
                        anchors.right: cycleUserBtn.left
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: (userModel && userModel.lastUser && userModel.lastUser !== "" && userModel.lastUser !== "live") ? userModel.lastUser : "krypton"
                        color: "#cdd6f4"
                        font.family: "JetBrainsMono Nerd Font"
                        font.pixelSize: 15
                        font.bold: true
                        selectByMouse: true
                        clip: true
                        KeyNavigation.tab: passInput
                        Keys.onReturnPressed: passInput.forceActiveFocus()
                        Keys.onEnterPressed: passInput.forceActiveFocus()
                    }

                    // Quick User Switcher Pill ("krypton" <-> "root")
                    Rectangle {
                        id: cycleUserBtn
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        width: 68
                        height: 30
                        radius: 8
                        color: cycleUserMouse.containsMouse ? "#313244" : "#1e1e2e"
                        border.color: "#45475a"
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: "Switch ⟳"
                            color: "#a6adc8"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 10
                            font.bold: true
                        }

                        MouseArea {
                            id: cycleUserMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (userInput.text === "krypton") {
                                    userInput.text = "root"
                                } else {
                                    userInput.text = "krypton"
                                }
                                passInput.forceActiveFocus()
                            }
                        }
                    }
                }
            }

            // PASSWORD INPUT FIELD
            Column {
                width: parent.width
                spacing: 6

                Text {
                    text: "PASSWORD"
                    color: "#89b4fa"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 11
                    font.bold: true
                }

                Rectangle {
                    id: passBox
                    width: parent.width
                    height: 46
                    radius: 12
                    color: "#11111b"
                    border.color: passInput.activeFocus ? "#cba6f7" : "#313244"
                    border.width: passInput.activeFocus ? 2 : 1

                    Text {
                        id: lockIcon
                        anchors.left: parent.left
                        anchors.leftMargin: 14
                        anchors.verticalCenter: parent.verticalCenter
                        text: "🔒"
                        font.pixelSize: 15
                        color: "#cba6f7"
                    }

                    Item {
                        anchors.left: lockIcon.right
                        anchors.leftMargin: 10
                        anchors.right: eyeBtn.left
                        anchors.rightMargin: 8
                        anchors.top: parent.top
                        anchors.bottom: parent.bottom

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: "Enter password (default: krypton)"
                            color: "#585b70"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 13
                            visible: passInput.text.length === 0
                        }

                        TextInput {
                            id: passInput
                            anchors.fill: parent
                            verticalAlignment: TextInput.AlignVCenter
                            echoMode: root.showPassword ? TextInput.Normal : TextInput.Password
                            passwordCharacter: "●"
                            color: "#cdd6f4"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 15
                            focus: true
                            selectByMouse: true
                            clip: true
                            KeyNavigation.tab: userInput
                            Keys.onReturnPressed: root.doLogin()
                            Keys.onEnterPressed: root.doLogin()
                        }
                    }

                    // Show/Hide Password Eye Button
                    Rectangle {
                        id: eyeBtn
                        anchors.right: parent.right
                        anchors.rightMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        width: 34
                        height: 30
                        radius: 8
                        color: eyeMouse.containsMouse ? "#313244" : "transparent"

                        Text {
                            anchors.centerIn: parent
                            text: root.showPassword ? "🙈" : "👁"
                            font.pixelSize: 14
                            color: "#a6adc8"
                        }

                        MouseArea {
                            id: eyeMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.showPassword = !root.showPassword
                                passInput.forceActiveFocus()
                            }
                        }
                    }
                }
            }

            // UNLOCK SESSION BUTTON
            Rectangle {
                id: loginBtnRect
                width: parent.width
                height: 48
                radius: 12
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: loginBtnMouse.containsMouse ? "#b4befe" : "#cba6f7" }
                    GradientStop { position: 1.0; color: loginBtnMouse.containsMouse ? "#89dceb" : "#89b4fa" }
                }

                Text {
                    anchors.centerIn: parent
                    text: "Unlock Session   ➜"
                    color: "#11111b"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 15
                    font.bold: true
                }

                MouseArea {
                    id: loginBtnMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.doLogin()
                }
            }

            // Error / Status Banner
            Text {
                id: errorLabel
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: ""
                color: "#f38ba8"
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 12
                font.bold: true
                visible: text !== ""
            }
        }
    }

    // =========================================================================
    // BOTTOM BAR: Hint & Session Info
    // =========================================================================
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 24
        anchors.horizontalCenter: parent.horizontalCenter
        height: 36
        width: hintText.width + 32
        radius: 18
        color: "#b3181825"
        border.color: "#3345475a"
        border.width: 1

        Text {
            id: hintText
            anchors.centerIn: parent
            text: "🔑 Default login:  krypton / krypton   •   Press Enter to sign in"
            color: "#a6adc8"
            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 12
        }
    }

    // Clock Update Timer
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var now = new Date()
            topClockText.text = Qt.formatDateTime(now, "ddd, MMM d   •   hh:mm:ss AP")
            bigClock.text = Qt.formatDateTime(now, "hh:mm")
        }
    }

    // SDDM Signal Handlers
    Connections {
        target: sddm
        function onLoginFailed() {
            passInput.text = ""
            passInput.forceActiveFocus()
            errorLabel.text = "⚠️ Authentication failed — please check your password"
        }
        function onLoginSucceeded() {
            errorLabel.color = "#a6e3a1"
            errorLabel.text = "✓ Welcome back! Launching Hyprland..."
        }
    }

    Component.onCompleted: {
        passInput.forceActiveFocus()
    }

    function doLogin() {
        errorLabel.text = ""
        var uname = userInput.text.trim()
        if (uname === "") {
            uname = "krypton"
        }
        sddm.login(uname, passInput.text, root.sessionIndex)
    }
}
