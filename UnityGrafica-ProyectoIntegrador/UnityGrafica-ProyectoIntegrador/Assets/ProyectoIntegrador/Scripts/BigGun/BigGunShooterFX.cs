using System.Collections;
using UnityEngine;

public class BigGunShooterFX : MonoBehaviour
{
    [Header("Muzzle / Destello")]
    [Tooltip("Origen del raycast (hacia donde se mira). Si es null usa este transform.")]
    public Transform muzzle;
    [Tooltip("Punto donde aparece el destello (punta del canyon). Si es null usa muzzle.")]
    public Transform flashPoint;
    [Tooltip("Color del destello (sci-fi).")]
    public Color flashColor = new Color(0.35f, 0.85f, 1f);
    [Tooltip("Brillo del destello (satura el Bloom).")]
    public float flashIntensity = 3.5f;
    [Tooltip("Tamano del quad del destello en unidades del mundo.")]
    public float flashSize = 0.22f;
    public float flashDuration = 0.06f;
    [Tooltip("Textura del destello (fondo negro para blend aditivo). Si es null usa una radial procedural.")]
    public Texture2D flashTexture;

    [Header("Luz breve del disparo")]
    public float lightIntensity = 1.5f;
    public float lightRange = 2.5f;

    [Header("Disparo / Impacto")]
    public float range = 60f;
    public LayerMask hitMask = ~0;
    [Tooltip("Material que usa el shader Custom/DecalProjector")]
    public Material burnMaterial;
    public float decalSize = 0.6f;
    public float decalLifetime = 8f;
    public float decalFadeStart = 5f;

    private Transform flashTr;
    private Material flashMat;
    private Light muzzleLight;
    private Camera _cam;

    void Start()
    {
        if (muzzle == null) muzzle = transform;
        BuildMuzzle();
    }

    void BuildMuzzle()
    {
        _cam = Camera.main;

        Transform fp = flashPoint != null ? flashPoint : muzzle;

        var quad = GameObject.CreatePrimitive(PrimitiveType.Quad);
        var col = quad.GetComponent<Collider>();
        if (col != null) Destroy(col);
        quad.name = "MuzzleFlash";
        quad.transform.SetParent(fp, false);
        quad.transform.localPosition = Vector3.zero;
        quad.transform.localScale = Vector3.one * flashSize;

        var shader = Shader.Find("Legacy Shaders/Particles/Additive");
        if (shader == null) shader = Shader.Find("Particles/Additive");
        flashMat = new Material(shader);
        flashMat.mainTexture = flashTexture != null ? (Texture)flashTexture : BuildFlashTexture();
        flashMat.SetColor("_TintColor", Color.black);

        var r = quad.GetComponent<Renderer>();
        r.sharedMaterial = flashMat;
        r.shadowCastingMode = UnityEngine.Rendering.ShadowCastingMode.Off;
        r.receiveShadows = false;

        flashTr = quad.transform;
        flashTr.gameObject.SetActive(false);

        var lgo = new GameObject("MuzzleLight");
        lgo.transform.SetParent(fp, false);
        lgo.transform.localPosition = Vector3.zero;
        muzzleLight = lgo.AddComponent<Light>();
        muzzleLight.type = LightType.Point;
        muzzleLight.color = flashColor;
        muzzleLight.range = lightRange;
        muzzleLight.intensity = 0f;
    }

    Texture2D BuildFlashTexture()
    {
        const int size = 128;
        var tex = new Texture2D(size, size, TextureFormat.RGBA32, false);
        tex.wrapMode = TextureWrapMode.Clamp;
        float half = size * 0.5f;
        for (int y = 0; y < size; y++)
        {
            for (int x = 0; x < size; x++)
            {
                float dx = (x + 0.5f - half) / half;
                float dy = (y + 0.5f - half) / half;
                float d = Mathf.Sqrt(dx * dx + dy * dy);
                float core = Mathf.Pow(Mathf.Clamp01(1f - d), 2.4f);
                float ang = Mathf.Atan2(dy, dx);
                float rays = Mathf.Pow(Mathf.Abs(Mathf.Cos(ang * 3f)), 10f) * Mathf.Clamp01(1f - d) * 0.7f;
                float v = Mathf.Clamp01(core + rays);
                tex.SetPixel(x, y, new Color(v, v, v, v));
            }
        }
        tex.Apply();
        return tex;
    }

    public void Shoot()
    {
        if (flashTr == null) BuildMuzzle();
        StartCoroutine(FlashRoutine());
        SpawnImpact();
    }

    IEnumerator FlashRoutine()
    {
        flashTr.gameObject.SetActive(true);
        float roll = Random.Range(0f, 360f);
        float t = 0f;
        while (t < flashDuration)
        {
            float k = 1f - (t / flashDuration);

            if (_cam == null) _cam = Camera.main;
            if (_cam != null)
            {
                flashTr.rotation = Quaternion.LookRotation(flashTr.position - _cam.transform.position, _cam.transform.up)
                                   * Quaternion.Euler(0f, 0f, roll);
            }

            flashTr.localScale = Vector3.one * flashSize * (0.7f + 0.3f * k);
            flashMat.SetColor("_TintColor", flashColor * flashIntensity * k);
            if (muzzleLight != null) muzzleLight.intensity = lightIntensity * k;

            t += Time.deltaTime;
            yield return null;
        }
        if (muzzleLight != null) muzzleLight.intensity = 0f;
        flashMat.SetColor("_TintColor", Color.black);
        flashTr.gameObject.SetActive(false);
    }

    void SpawnImpact()
    {
        RaycastHit hit;
        if (!Physics.Raycast(muzzle.position, muzzle.forward, out hit, range, hitMask))
            return;
        if (burnMaterial == null) return;

        var go = new GameObject("BurnDecal");
        float offset = 0.25f;
        go.transform.position = hit.point + hit.normal * offset;
        go.transform.rotation = Quaternion.LookRotation(-hit.normal);

        var proj = go.AddComponent<Projector>();
        proj.orthographic = true;
        proj.orthographicSize = decalSize * Random.Range(0.7f, 1.2f);
        proj.nearClipPlane = 0.05f;
        proj.farClipPlane = offset + 0.35f;
        proj.material = new Material(burnMaterial);

        StartCoroutine(FadeDecal(go, proj));
    }

    IEnumerator FadeDecal(GameObject go, Projector proj)
    {
        float t = 0f;
        Color baseCol = proj.material.HasProperty("_Color") ? proj.material.GetColor("_Color") : Color.black;
        while (t < decalLifetime && go != null)
        {
            if (t > decalFadeStart)
            {
                float k = 1f - (t - decalFadeStart) / (decalLifetime - decalFadeStart);
                proj.material.SetColor("_Color", Color.Lerp(Color.white, baseCol, k));
            }
            t += Time.deltaTime;
            yield return null;
        }
        if (go != null) Destroy(go);
    }
}
