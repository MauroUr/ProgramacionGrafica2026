using UnityEngine;

public class HoverSpin : MonoBehaviour
{
    public float spinSpeed = 60f;
    public float bobAmplitude = 0.15f;
    public float bobSpeed = 2f;

    private Vector3 startPos;

    void OnEnable()
    {
        startPos = transform.localPosition;
    }

    void Update()
    {
        transform.Rotate(Vector3.up, spinSpeed * Time.deltaTime, Space.World);
        float y = Mathf.Sin(Time.time * bobSpeed) * bobAmplitude;
        transform.localPosition = startPos + Vector3.up * y;
    }
}
