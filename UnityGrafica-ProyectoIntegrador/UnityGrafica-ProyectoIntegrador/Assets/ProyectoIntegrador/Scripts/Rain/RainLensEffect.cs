using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class RainLensEffect : MonoBehaviour
{
    [Tooltip("Material que usa el shader Custom/RainLens")]
    public Material rainMaterial;

    [Tooltip("Textura de gotas (RG = offset). Se asigna al material como _DropsTex")]
    public Texture dropsTexture;

    [Range(0f, 0.2f)] public float distortion = 0.05f;

    [Tooltip("Velocidad de caida de las gotas (x, y)")]
    public Vector2 speed = new Vector2(0f, -0.3f);

    [Tooltip("Intensidad global del efecto (0 = sin lluvia)")]
    [Range(0f, 1f)] public float intensity = 1f;

    void OnEnable()
    {
        var cam = GetComponent<Camera>();
        if (cam != null)
            cam.depthTextureMode |= DepthTextureMode.Depth;
    }

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        if (rainMaterial == null || intensity <= 0f)
        {
            Graphics.Blit(src, dst);
            return;
        }

        if (dropsTexture != null)
            rainMaterial.SetTexture("_DropsTex", dropsTexture);
        rainMaterial.SetFloat("_Distortion", distortion * intensity);
        rainMaterial.SetVector("_Speed", new Vector4(speed.x, speed.y, 0f, 0f));

        Graphics.Blit(src, dst, rainMaterial);
    }
}
