Assets {
  Id: 7517662919555118005
  Name: "Custom Mad Hatter Blend"
  PlatformAssetType: 13
  SerializationVersion: 113
  CustomMaterialAsset {
    BaseMaterialId: 271728502152210848
    ParameterOverrides {
      Overrides {
        Name: "cmp:Material1"
        AssetReference {
          Id: 14582790818618070150
        }
      }
      Overrides {
        Name: "cmp:Material2"
        AssetReference {
          Id: 5052177013897088937
        }
      }
      Overrides {
        Name: "blend_amount"
        Float: 0.4127509
      }
      Overrides {
        Name: "mask_scale"
        Float: 1
      }
      Overrides {
        Name: "u_tiles2"
        Float: 0.767004848
      }
      Overrides {
        Name: "v_tiles2"
        Float: 1.61472332
      }
      Overrides {
        Name: "material2_scale"
        Float: 15
      }
      Overrides {
        Name: "invert_height"
        Float: 0
      }
      Overrides {
        Name: "cmpc:Material2"
        Color {
          R: 0.342591137
          G: 0.141036
          B: 0.483
          A: 1
        }
      }
      Overrides {
        Name: "cmpc:Material1"
        Color {
          R: 0.994
          G: 0.191345051
          B: 0.0308140181
          A: 1
        }
      }
      Overrides {
        Name: "material1_scale"
        Float: 20
      }
    }
    Assets {
      Id: 271728502152210848
      Name: "Composite Mask Blend"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "mi_composite_mask_blend_001_uv"
      }
    }
    Assets {
      Id: 14582790818618070150
      Name: "Asphalt 01"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "mi_gen_asphault_001"
      }
    }
    Assets {
      Id: 5052177013897088937
      Name: "Bone Raw"
      PlatformAssetType: 2
      PrimaryAsset {
        AssetType: "MaterialAssetRef"
        AssetId: "mi_bone_raw_001_uv_ref"
      }
    }
  }
}
