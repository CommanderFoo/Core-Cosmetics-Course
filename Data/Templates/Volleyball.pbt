Assets {
  Id: 103425587346297514
  Name: "Volleyball"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 7966252939242214290
      Objects {
        Id: 7966252939242214290
        Name: "Volleyball"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 4781671109827199097
        ChildIds: 5311829816432387945
        UnregisteredParameters {
          Overrides {
            Name: "cs:PrimaryColor"
            Color {
            }
          }
          Overrides {
            Name: "cs:SecondaryColor"
            Color {
            }
          }
          Overrides {
            Name: "cs:TertiaryColor"
            Color {
            }
          }
          Overrides {
            Name: "cs:PrimaryColor:isrep"
            Bool: true
          }
          Overrides {
            Name: "cs:PrimaryColor:ml"
            Bool: false
          }
          Overrides {
            Name: "cs:SecondaryColor:isrep"
            Bool: true
          }
          Overrides {
            Name: "cs:SecondaryColor:ml"
            Bool: false
          }
          Overrides {
            Name: "cs:TertiaryColor:isrep"
            Bool: true
          }
          Overrides {
            Name: "cs:TertiaryColor:ml"
            Bool: false
          }
        }
        WantsNetworking: true
        Collidable_v2 {
          Value: "mc:ecollisionsetting:forceoff"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:forceoff"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        NetworkContext {
          DetailRelevance {
            Value: "mc:edetaillevel:low"
          }
          MinDetailLevel {
            Value: "mc:edetaillevel:low"
          }
          MaxDetailLevel {
            Value: "mc:edetaillevel:ultra"
          }
        }
        NetworkRelevanceDistance {
          Value: "mc:eproxyrelevance:critical"
        }
      }
      Objects {
        Id: 5311829816432387945
        Name: "Geo"
        Transform {
          Location {
            X: -1.94497299
            Y: 0.241017088
            Z: 13.3576765
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 7966252939242214290
        ChildIds: 17211115726435976492
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        Folder {
          IsGroup: true
        }
        NetworkRelevanceDistance {
          Value: "mc:eproxyrelevance:critical"
        }
      }
      Objects {
        Id: 17211115726435976492
        Name: "Ball - Volleyball 01"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1.2
            Y: 1.2
            Z: 1.2
          }
        }
        ParentId: 5311829816432387945
        Collidable_v2 {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        Visible_v2 {
          Value: "mc:evisibilitysetting:inheritfromparent"
        }
        CameraCollidable {
          Value: "mc:ecollisionsetting:inheritfromparent"
        }
        EditorIndicatorVisibility {
          Value: "mc:eindicatorvisibility:visiblewhenselected"
        }
        CoreMesh {
          MeshAsset {
            Id: 8643948483022031492
          }
          Teams {
            IsTeamCollisionEnabled: true
            IsEnemyCollisionEnabled: true
          }
          StaticMesh {
            Physics {
              Mass: 100
              LinearDamping: 0.01
            }
            BoundsScale: 1
          }
        }
        Relevance {
          Value: "mc:eproxyrelevance:critical"
        }
        NetworkRelevanceDistance {
          Value: "mc:eproxyrelevance:critical"
        }
      }
    }
    Assets {
      Id: 8643948483022031492
      Name: "Ball - Volleyball 01"
      PlatformAssetType: 1
      PrimaryAsset {
        AssetType: "StaticMeshAssetRef"
        AssetId: "sm_prop_urb_ball_volleyball_01_ref"
      }
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  SerializationVersion: 115
  VirtualFolderPath: "Cosmetics"
  VirtualFolderPath: "Head"
}
