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
    [Tooltip("Se activa al agarrar el arma con E")]
    public bool equipped = false;

    [Header("Disparo cargado")]
    [Tooltip("Tiempo minimo aguantando el click para que cuente como cargado")]
    public float chargeThreshold = 0.25f;
    [Tooltip("Tiempo aguantando el click para llegar a carga maxima")]
    public float fullChargeTime = 1.2f;
    [Tooltip("Cooldown despues de un disparo con carga maxima")]
    public float chargedCooldown = 0.8f;

    private float _pitch;
    private float _yaw;
    private float _fireTimer;
    private bool _charging;
    private float _chargeTimer;

    private void Start()
    {
        Vector3 e = transform.eulerAngles;
        _yaw = e.y;
        _pitch = NormalizePitch(e.x);

        if (shooterFX == null)
            shooterFX = GetComponentInChildren<BigGunShooterFX>(true);

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

        if (equipped)
        {
            if (!_charging && Input.GetMouseButtonDown(0) && _fireTimer <= 0f
                && Cursor.lockState == CursorLockMode.Locked)
            {
                _charging = true;
                _chargeTimer = 0f;
            }

            if (_charging)
            {
                _chargeTimer += Time.deltaTime;
                if (shooterFX != null) shooterFX.SetCharge(Charge01());

                if (_chargeTimer >= fullChargeTime)
                    Fire(1f);
                else if (Input.GetMouseButtonUp(0))
                    Fire(Charge01());
            }
        }

        if (Input.GetKeyDown(KeyCode.Escape))
            LockCursor(false);
        else if (Input.GetMouseButtonDown(0) && Cursor.lockState != CursorLockMode.Locked)
            LockCursor(true);
    }

    private void Fire(float charge01)
    {
        _charging = false;
        if (shooterFX != null)
        {
            shooterFX.SetCharge(0f);
            shooterFX.Shoot(charge01);
        }
        _fireTimer = Mathf.Lerp(fireCooldown, chargedCooldown, charge01);
    }

    private float Charge01()
    {
        return Mathf.InverseLerp(chargeThreshold, fullChargeTime, _chargeTimer);
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
