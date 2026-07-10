using UnityEngine;

public class Bullet : MonoBehaviour
{
    [Header("Movimiento")]
    public float speed = 45f;
    public float lifetime = 4f;

    [Header("Impacto")]
    public LayerMask hitMask = ~0;
    [Tooltip("Margen extra del cast para no atravesar paredes")]
    public float skin = 0.05f;
    [Tooltip("Multiplicador del tamano de la marca de impacto")]
    public float decalScale = 1f;

    private Vector3 dir;
    private BigGunShooterFX owner;
    private float age;
    private float radius;

    public void Launch(Vector3 direction, BigGunShooterFX fx, LayerMask mask, float spd, float decalMul)
    {
        dir = direction.normalized;
        owner = fx;
        hitMask = mask;
        speed = spd;
        decalScale = decalMul;
        transform.forward = dir;

        Vector3 s = transform.localScale;
        radius = Mathf.Max(s.x, s.y) * 0.5f;
    }

    void Update()
    {
        age += Time.deltaTime;
        if (age >= lifetime)
        {
            Destroy(gameObject);
            return;
        }

        float step = speed * Time.deltaTime;

        RaycastHit hit;
        bool got = radius > 0.001f
            ? Physics.SphereCast(transform.position, radius, dir, out hit, step + skin, hitMask, QueryTriggerInteraction.Ignore)
            : Physics.Raycast(transform.position, dir, out hit, step + skin, hitMask, QueryTriggerInteraction.Ignore);

        if (got)
        {
            if (owner != null) owner.SpawnDecalAt(hit.point, hit.normal, decalScale);
            transform.position = hit.point;
            Destroy(gameObject);
            return;
        }

        transform.position += dir * step;
    }
}
