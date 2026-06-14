using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlurPP : MonoBehaviour
{
    [SerializeField] private Shader shader;
    [SerializeField] private Vector3 cameraForward;
    [SerializeField] private Vector3 movement;
    [SerializeField] [Range(0,1f)] float strenght;

    private Material material;

    private void Awake()
    {
        material = new Material(shader);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }

    private void Update()
    {
        cameraForward = this.transform.forward;

        material.SetVector("_CamForward", cameraForward.normalized);
        material.SetVector("_Movement", movement.normalized);
        material.SetFloat("_Strenght", strenght);
        
    }
}