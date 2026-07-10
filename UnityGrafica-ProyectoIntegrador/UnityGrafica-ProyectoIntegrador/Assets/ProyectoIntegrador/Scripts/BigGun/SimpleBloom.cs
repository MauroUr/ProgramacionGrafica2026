using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class SimpleBloom : MonoBehaviour
{
    public Material bloomMaterial;
    [Range(0f, 2f)] public float threshold = 0.7f;
    [Range(0f, 4f)] public float intensity = 1.3f;

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (bloomMaterial == null)
        {
            Graphics.Blit(src, dst);
            return;
        }

        bloomMaterial.SetTexture("_TapR", src);
        bloomMaterial.SetTexture("_TapL", src);
        bloomMaterial.SetTexture("_TapU", src);
        bloomMaterial.SetTexture("_TapD", src);
        bloomMaterial.SetFloat("_Threshold", threshold);
        bloomMaterial.SetFloat("_Intensity", intensity);

        Graphics.Blit(src, dst, bloomMaterial);
    }
}
