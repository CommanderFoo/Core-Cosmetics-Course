Assets {
  Id: 11500067732916630713
  Name: "Skull"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 2799239553926454771
      Objects {
        Id: 2799239553926454771
        Name: "Skull"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 4781671109827199097
        ChildIds: 2409208901005721860
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
            Name: "cs:SecondaryColor:isrep"
            Bool: true
          }
          Overrides {
            Name: "cs:TertiaryColor:isrep"
            Bool: true
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
        Id: 2409208901005721860
        Name: "Geo"
        Transform {
          Location {
            X: -8.88613605
            Y: 2.68919393e-06
            Z: -4.59533501
          }
          Rotation {
          }
          Scale {
            X: 0.782668352
            Y: 0.782668352
            Z: 0.782668352
          }
        }
        ParentId: 2799239553926454771
        ChildIds: 5715000217380646537
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
        Id: 5715000217380646537
        Name: "Skull"
        Transform {
          Location {
          }
          Rotation {
            Yaw: -89.9999924
          }
          Scale {
            X: 2
            Y: 2
            Z: 2
          }
        }
        ParentId: 2409208901005721860
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
            Id: 9657493880047444718
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
      Id: 9657493880047444718
      Name: "Bone Human Skull 01"
      PlatformAssetType: 1
      PrimaryAsset {
        AssetType: "StaticMeshAssetRef"
        AssetId: "sm_bones_human_skull_01_ref"
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
