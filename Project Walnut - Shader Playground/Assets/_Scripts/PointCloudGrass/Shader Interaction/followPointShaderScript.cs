using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class followPointShaderScript : MonoBehaviour
{

    public Transform t;
    private Renderer rend;


    private void Start()
    {
        rend = GetComponent<Renderer>();
    }

    // Update is called once per frame
    void Update()
    {
        rend.sharedMaterial.SetVector("_RotPoint", t.position);
    }
}
