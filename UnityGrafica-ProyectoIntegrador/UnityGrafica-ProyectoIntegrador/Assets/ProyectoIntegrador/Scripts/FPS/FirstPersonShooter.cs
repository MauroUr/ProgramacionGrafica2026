using UnityEngine;

public class FirstPersonShooter : MonoBehaviour
{
    [Header("Look")]
    public float mouseSensitivity = 2f;
    public float minPitch = -80f;
    public float maxPitch = 80f;

    [Header("Move")]
    public float moveSpeed = 3.5f;

    [Header("Shoot")]
    public BigGunShooterFX shooterFX;
    public float fireCooldown = 0.25f;

    private float _pitch;
    private float _yaw;
    private float _fireTimer;

    private void Start()
    {
        Vector3 e = transform.eulerAngles;
        _yaw = e.y;
        _pitch = NormalizePitch(e.x);

        if (shooterFX == null)
            shooterFX = GetComponentInChildren<BigGunShooterFX>();

        LockCursor(true);
    }

    private void Update()
    {
        _yaw += Input.GetAxisRaw("Mouse X") * mouseSensitivity;
        _pitch -= Input.GetAxisRaw("Mouse Y") * mouseSensitivity;
        _pitch = Mathf.Clamp(_pitch, minPitch, maxPitch);
        transform.rotation = Quaternion.Euler(_pitch, _yaw, 0f);

        float h = Input.GetAxisRaw("Horizontal");
        float v = Input.GetAxisRaw("Vertical");
        Vector3 fwd = transform.forward; fwd.y = 0f; fwd.Normalize();
        Vector3 right = transform.right; right.y = 0f; right.Normalize();
        Vector3 move = (fwd * v + right * h);
        if (move.sqrMagnitude > 1f) move.Normalize();
        transform.position += move * moveSpeed * Time.deltaTime;

        _fireTimer -= Time.deltaTime;
        if (Input.GetMouseButtonDown(0) && _fireTimer <= 0f)
        {
            _fireTimer = fireCooldown;
            if (shooterFX != null) shooterFX.Shoot();
        }

        if (Input.GetKeyDown(KeyCode.Escape))
            LockCursor(false);
        else if (Input.GetMouseButtonDown(0) && Cursor.lockState != CursorLockMode.Locked)
            LockCursor(true);
    }

    private static float NormalizePitch(float x)
    {
        x %= 360f;
        return x > 180f ? x - 360f : x;
    }

    private void LockCursor(bool locked)
    {
        Cursor.lockState = locked ? CursorLockMode.Locked : CursorLockMode.None;
        Cursor.visible = !locked;
    }
}
