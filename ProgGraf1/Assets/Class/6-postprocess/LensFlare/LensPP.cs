using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LensPP : MonoBehaviour
{
    [SerializeField] private Shader shader;
    [SerializeField] private Vector3 cameraForward;
    
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
        
        material.SetVector("_CamForward", cameraForward);
    }
}
