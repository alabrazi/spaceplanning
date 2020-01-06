import QtQuick 2.12
import Felgo 3.0
 // for accessing the Body.Static type

EntityBase {
  entityType: "wall"
  // default width and height
  width: 10
  height: 10
  z:1000
  Rectangle{
      anchors.fill: parent
      color: "red"
  }
  // only collider since we want the wall to be invisible
  BoxCollider {
    anchors.fill: parent
    bodyType: Body.Static // the body shouldn't move
  }
   DragHandler { id: dragHandler }
}
