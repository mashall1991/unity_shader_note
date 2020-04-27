using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ShaderToyManager : MonoBehaviour
{
    public Shader PostProcessingShader;
    private Material mat;
    public Material Mat
    {
        get
        {
            //如果在面板中没有指定Shader的话，则报错提示
            if (PostProcessingShader == null)
            {
                Debug.LogError("Shader没有提定！");
                return null;
            }

            //如果当前指定的Shader不被支持的话，则报错提示
            if (!PostProcessingShader.isSupported)
            {
                Debug.LogError("Shader不支持！");
                return null;
            }

            //如果mat是空的，则创建一个新的材质球
            if (mat == null)
            {
                //新建一个材质球并返回
                Material _newMat = new Material(PostProcessingShader);
                _newMat.hideFlags = HideFlags.HideAndDontSave;
                mat = _newMat;
                return mat;
            }
            //如果mat已经存在，那就直接使用
            else
            {
                return mat;
            }

        }
    }
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(src, dest, Mat);
    }
}
