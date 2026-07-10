using UnityEngine;

public class WeaponPickup : MonoBehaviour
{
    [Header("Pickup")]
    public Transform player;
    public float radius = 2.5f;
    public KeyCode pickupKey = KeyCode.E;

    [Header("Equipar")]
    [Tooltip("Viewmodel del arma (arranca desactivado)")]
    public GameObject viewmodel;
    public FirstPersonShooter shooter;

    [Header("Prompt")]
    public string prompt = "[E] Agarrar arma";

    private bool inRange;

    void Update()
    {
        if (player == null) return;

        inRange = Vector3.Distance(player.position, transform.position) <= radius;

        if (inRange && Input.GetKeyDown(pickupKey))
            Equip();
    }

    void Equip()
    {
        if (viewmodel != null) viewmodel.SetActive(true);
        if (shooter != null) shooter.equipped = true;
        Destroy(gameObject);
    }

    void OnGUI()
    {
        if (!inRange) return;

        var style = new GUIStyle(GUI.skin.label);
        style.alignment = TextAnchor.MiddleCenter;
        style.fontSize = 22;
        style.normal.textColor = Color.white;
        GUI.Label(new Rect(0f, Screen.height * 0.62f, Screen.width, 40f), prompt, style);
    }
}
