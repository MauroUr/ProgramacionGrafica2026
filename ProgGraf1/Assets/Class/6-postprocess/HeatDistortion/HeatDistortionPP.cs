using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HeatDistortionPP : MonoBehaviour
{
  
    [SerializeField] private Shader shader;
    [SerializeField] private float distance;
 

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
        material.SetFloat("_distanceThreshold", distance);
        
    }
}
