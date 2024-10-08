Assets {
  Id: 13622717713304891639
  Name: "Bubble"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 123755685876164344
      Objects {
        Id: 123755685876164344
        Name: "Bubble"
        Transform {
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        ParentId: 4781671109827199097
        ChildIds: 2777897330754654723
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
        Id: 2777897330754654723
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
            X: 0.381481
            Y: 0.381481
            Z: 0.381481
          }
        }
        ParentId: 123755685876164344
        ChildIds: 17779387849359632885
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
        Id: 17779387849359632885
        Name: "Ball"
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
        ParentId: 2777897330754654723
        UnregisteredParameters {
          Overrides {
            Name: "ma:Shared_BaseMaterial:id"
            AssetReference {
              Id: 17313432403184081615
            }
          }
        }
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
            Id: 16015076451403376387
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
      Id: 16015076451403376387
      Name: "Sphere"
      PlatformAssetType: 1
      PrimaryAsset {
        AssetType: "StaticMeshAssetRef"
        AssetId: "sm_sphere_002"
      }
    }
    Assets {
      Id: 17313432403184081615
      Name: "Bubble"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "fxmi_bubble"
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
