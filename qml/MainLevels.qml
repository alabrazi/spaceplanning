import Felgo 3.0
import QtQuick 2.0
import "scenes"

  GameWindow {
//      onSplashScreenFinished: scene.startGame()
      App {
        id: app

        licenseKey: "7A4F9FF2BF264262671E606B940524202D11BC678A0664937DF716D16E9E5156CF18D8F34721C1A7C705BC730173D018B938E9F871DC435B41BC52AF0BA46212A123C2E671E63FB02613B63D6953867152202A5EDC7D16B77738FBD7D7D60295C6559651037B8307EE622D17DBABC4816F2076E082DB721DC55551CA63B5E7006E5934E9A069799102675B9B8ADAFD8DB930FEA777BA0BDA82539F1CF10997C853B16AC958D8C08F3B4A77C7973979C5D3AE64611A2EAD26F6ECF64FBECEE73ACDCDDB809F7E3A277A1D1D52B5589C55BAB73BADCAB2D409C39E0D4AAA221FD6DB467B4435D39606ECE73168915DA9590C9A4F5565A55842F7F1B7A905303310F835FC61DD5F30AB4B8822AFDD93309508FAABD92546EB2E3FDC4D58D16762D0C775BD41CA8FF6D557E10711C7712BBE"
      }
      id: window
      screenWidth: 960
      screenHeight: 640
      licenseKey: "7A4F9FF2BF264262671E606B940524202D11BC678A0664937DF716D16E9E5156CF18D8F34721C1A7C705BC730173D018B938E9F871DC435B41BC52AF0BA46212A123C2E671E63FB02613B63D6953867152202A5EDC7D16B77738FBD7D7D60295C6559651037B8307EE622D17DBABC4816F2076E082DB721DC55551CA63B5E7006E5934E9A069799102675B9B8ADAFD8DB930FEA777BA0BDA82539F1CF10997C853B16AC958D8C08F3B4A77C7973979C5D3AE64611A2EAD26F6ECF64FBECEE73ACDCDDB809F7E3A277A1D1D52B5589C55BAB73BADCAB2D409C39E0D4AAA221FD6DB467B4435D39606ECE73168915DA9590C9A4F5565A55842F7F1B7A905303310F835FC61DD5F30AB4B8822AFDD93309508FAABD92546EB2E3FDC4D58D16762D0C775BD41CA8FF6D557E10711C7712BBE"

      // You get free licenseKeys from https://felgo.com/licenseKey
      // With a licenseKey you can:
      //  * Publish your games & apps for the app stores
      //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
      //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
      //licenseKey: "<generate one from https://felgo.com/licenseKey>"

      // create and remove entities at runtime
      EntityManager {
          id: entityManager
      }

      // menu scene
      MenuScene {
          id: menuScene
          // listen to the button signals of the scene and change the state according to it
          onSelectLevelPressed: window.state = "selectLevel"
          onCreditsPressed: window.state = "credits"
          // the menu scene is our start scene, so if back is pressed there we ask the user if he wants to quit the application
          onBackButtonPressed: {
              nativeUtils.displayMessageBox(qsTr("Really quit the game?"), "", 2);
          }
          // listen to the return value of the MessageBox
          Connections {
              target: nativeUtils
              onMessageBoxFinished: {
                  // only quit, if the activeScene is menuScene - the messageBox might also get opened from other scenes in your code
                  if(accepted && window.activeScene === menuScene)
                      Qt.quit()
              }
          }
      }

      // scene for selecting levels
      SelectLevelScene {
          id: selectLevelScene
          onLevelPressed: {
              // selectedLevel is the parameter of the levelPressed signal
              gameScene.setLevel(selectedLevel)
              window.state = "game"

          }
          onBackButtonPressed: window.state = "menu"
      }

      // credits scene
      CreditsScene {
          id: creditsScene
          onBackButtonPressed: window.state = "menu"
      }

      // game scene to play a level
      GameScene {
          id: gameScene
          onBackButtonPressed: window.state = "selectLevel"
      }

      // menuScene is our first scene, so set the state to menu initially
      state: "menu"
      activeScene: menuScene

      // state machine, takes care reversing the PropertyChanges when changing the state, like changing the opacity back to 0
      states: [
          State {
              name: "menu"
              PropertyChanges {target: menuScene; opacity: 1}
              PropertyChanges {target: window; activeScene: menuScene}
          },
          State {
              name: "selectLevel"
              PropertyChanges {target: selectLevelScene; opacity: 1}
              PropertyChanges {target: window; activeScene: selectLevelScene}
          },
          State {
              name: "credits"
              PropertyChanges {target: creditsScene; opacity: 1}
              PropertyChanges {target: window; activeScene: creditsScene}
          },
          State {
              name: "game"
              PropertyChanges {target: gameScene; opacity: 1}
              PropertyChanges {target: window; activeScene: gameScene}
          }
      ]
  }


