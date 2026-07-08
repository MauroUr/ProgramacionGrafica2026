using UnityEngine;

public class BoatBob : MonoBehaviour
{
    [Header("Flotado vertical")]
    public float bobAmplitude = 0.15f;
    public float bobSpeed = 1.1f;

    [Header("Balanceo lateral (roll)")]
    public float rollAmplitude = 5f;
    public float rollSpeed = 0.9f;

    [Header("Cabeceo (pitch)")]
    public float pitchAmplitude = 3f;
    public float pitchSpeed = 0.7f;

    private Vector3 startPos;
    private Quaternion startRot;

    void Start()
    {
        startPos = transform.position;
        startRot = transform.rotation;
    }

    void Update()
    {
        float t = Time.time;
        float y = Mathf.Sin(t * bobSpeed) * bobAmplitude;
        float roll = Mathf.Sin(t * rollSpeed) * rollAmplitude;
        float pitch = Mathf.Sin(t * pitchSpeed + 0.7f) * pitchAmplitude;

        transform.position = startPos + Vector3.up * y;
        transform.rotation = startRot * Quaternion.Euler(pitch, 0f, roll);
    }
}
