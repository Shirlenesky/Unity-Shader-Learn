using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class PostEffectsBase : MonoBehaviour
{
    protected bool CheckSupported()
    {
        if(SystemInfo.supportsImageEffects == false || SystemInfo.supportsRenderTextures == false)
        {
            Debug.Log("NO");
            return false;
        }
        return true;
    }

    protected void CheckResources()
    {
        bool isSupported = CheckSupported();

        if(isSupported == false)
        {
            NotSupported();
        }
    }

    protected void NotSupported()
    {
        enabled = false;
    }

    protected void Start()
    {
        CheckResources();
    }

    protected Material CheckShaderAndCreateMaterial(Shader shader, Material mat)
    {
        if (shader == null) return null;

        if (shader.isSupported && mat && mat.shader == shader) return mat;

        if (!shader.isSupported) return null;
        else
        {
            mat = new Material(shader);
            mat.hideFlags = HideFlags.DontSave;

            if (mat) return mat;
            else
            {
                return null;
            }
        }

    }
}
