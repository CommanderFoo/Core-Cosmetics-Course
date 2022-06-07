Assets {
  Id: 3827273825478670255
  Name: "Custom Mad Hatter Silk"
  PlatformAssetType: 13
  SerializationVersion: 115
  CustomMaterialAsset {
    BaseMaterialId: 10928861825251085005
    ParameterOverrides {
      Overrides {
        Name: "deep color"
        Color {
          R: 0.0872166082
          G: 0.041658
          B: 0.131000012
          A: 1
        }
      }
      Overrides {
        Name: "shallow color"
        Color {
          R: 0.344371557
          G: 0.100000024
          B: 1
          A: 1
        }
      }
      Overrides {
        Name: "foam color"
        Color {
          R: 0.732317924
          G: 0.53
          B: 1
          A: 1
        }
      }
      Overrides {
        Name: "arc"
        Float: 0
      }
      Overrides {
        Name: "scrollspeedy"
        Float: 0.0374342091
      }
      Overrides {
        Name: "waterbreakuptransition"
        Float: 0.767595768
      }
      Overrides {
        Name: "depthfadedistance"
        Float: 1
      }
    }
    Assets {
      Id: 10928861825251085005
      Name: "Waterfall"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "fxmi_waterfall"
      }
    }
  }
}
