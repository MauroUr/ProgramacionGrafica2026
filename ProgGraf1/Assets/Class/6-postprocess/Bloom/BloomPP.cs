using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BloomPP : MonoBehaviour
{
    [SerializeField] private Shader shader;
    [SerializeField] private float lightIntensity;
    [SerializeField] [Range(0,0.2f)] private float offset;
    
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
        material.SetFloat("_lightIntensity", lightIntensity);
        material.SetVector("_offset", new Vector2(offset,offset) );
    }
}