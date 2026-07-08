using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class SimpleBloom : MonoBehaviour
{
    public Material bloomMaterial;
    [Range(0f, 2f)] public float threshold = 0.7f;
    [Range(0f, 4f)] public float intensity = 1.3f;
    [Range(1, 6)] public int iterations = 3;
    [Range(0.5f, 4f)] public float blurSize = 1.5f;

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (bloomMaterial == null)
        {
            Graphics.Blit(src, dst);
            return;
        }

        int w = Mathf.Max(1, src.width / 2);
        int h = Mathf.Max(1, src.height / 2);

        RenderTexture bright = RenderTexture.GetTemporary(w, h, 0, src.format);
        bloomMaterial.SetFloat("_Threshold", threshold);
        Graphics.Blit(src, bright, bloomMaterial, 0);

        for (int i = 0; i < iterations; i++)
        {
            RenderTexture tmp = RenderTexture.GetTemporary(w, h, 0, src.format);
            bloomMaterial.SetVector("_Dir", new Vector4(blurSize / w, 0f, 0f, 0f));
            Graphics.Blit(bright, tmp, bloomMaterial, 1);
            bloomMaterial.SetVector("_Dir", new Vector4(0f, blurSize / h, 0f, 0f));
            Graphics.Blit(tmp, bright, bloomMaterial, 1);
            RenderTexture.ReleaseTemporary(tmp);
        }

        bloomMaterial.SetTexture("_BloomTex", bright);
        bloomMaterial.SetFloat("_Intensity", intensity);
        Graphics.Blit(src, dst, bloomMaterial, 2);
        RenderTexture.ReleaseTemporary(bright);
    }
}
