﻿/**
 * @file         ShaderReferenceBuildInVariables.cs
 * @author       Hongwei Li(taecg@qq.com)
 * @created      2019-02-26
 * @updated      2019-02-26
 *
 * @brief        内置变量相关
 */

#if UNITY_EDITOR
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace taecg.tools.shaderReference
{
    public class ShaderReferenceBuildInVariables : EditorWindow
    {
        #region 数据成员
        private Vector2 scrollPos;
        #endregion

        public void DrawMainGUI ()
        {
            scrollPos = EditorGUILayout.BeginScrollView (scrollPos);
            ShaderReferenceUtil.DrawTitle ("Transformations");
            ShaderReferenceUtil.DrawOneContent ("UNITY_MATRIX_MVP", "模型空间>>投影空间");
            ShaderReferenceUtil.DrawOneContent ("UNITY_MATRIX_MV", "模型空间>>观察空间");
            ShaderReferenceUtil.DrawOneContent ("UNITY_MATRIX_V", "视图空间");
            ShaderReferenceUtil.DrawOneContent ("UNITY_MATRIX_P", "投影空间");
            ShaderReferenceUtil.DrawOneContent ("UNITY_MATRIX_VP", "视图空间>投影空间");
            //ShaderReferenceUtil.DrawOneContent("UNITY_MATRIX_T_MV", "");
            //ShaderReferenceUtil.DrawOneContent("UNITY_MATRIX_IT_MV", "");
            ShaderReferenceUtil.DrawOneContent ("unity_ObjectToWorld", "本地空间>>世界空间");
            ShaderReferenceUtil.DrawOneContent ("unity_WorldToObject", "世界空间>本地空间");

            ShaderReferenceUtil.DrawTitle ("Camera and Screen");
            ShaderReferenceUtil.DrawOneContent ("_WorldSpaceCameraPos", "主相机的世界坐标，类型：float3");
            ShaderReferenceUtil.DrawOneContent ("UnityWorldSpaceViewDir(i.worldPos)", "世界空间下的相机方向(顶点到主相机)，类型：float3");
            //ShaderReferenceUtil.DrawOneContent("_ProjectionParams", "");
            ShaderReferenceUtil.DrawOneContent ("_ScreenParams", "屏幕的相关参数，单位为像素。\nx表示屏幕的宽度\ny表示屏幕的高度\nz表示1+1/屏幕宽度\nw表示1+1/屏幕高度");
            //ShaderReferenceUtil.DrawOneContent("_ZBufferParams", "");
            //ShaderReferenceUtil.DrawOneContent("unity_OrthoParams", "");
            //ShaderReferenceUtil.DrawOneContent("unity_CameraProjection", "");
            //ShaderReferenceUtil.DrawOneContent("unity_CameraInvProjection", "");
            //ShaderReferenceUtil.DrawOneContent("unity_CameraWorldClipPlanes[6]", "");

            ShaderReferenceUtil.DrawTitle ("Time");
            ShaderReferenceUtil.DrawOneContent ("_Time", "时间，主要用于在Shader做动画,类型：float4\nx = t/20\ny = t\nz = t*2\nw = t*3");
            ShaderReferenceUtil.DrawOneContent ("_SinTime", "t是时间的正弦值，返回值(-1~1): \nx = t/8\ny = t/4\nz = t/2\nw = t");
            ShaderReferenceUtil.DrawOneContent ("_CosTime", "t是时间的余弦值，返回值(-1~1):\nx = t/8\ny = t/4\nz = t/2\nw = t");
            ShaderReferenceUtil.DrawOneContent ("unity_DeltaTime", "dt是时间增量,smoothDt是平滑时间\nx = dt\ny = 1/dt\nz = smoothDt\nz = 1/smoothDt");

            ShaderReferenceUtil.DrawTitle ("Lighting(ForwardBase & ForwardAdd)");
            ShaderReferenceUtil.DrawOneContent ("_LightColor0", "主平行灯的颜色值,rgb = 颜色x亮度; a = 亮度");
            ShaderReferenceUtil.DrawOneContent ("_WorldSpaceLightPos0", "平行灯:\t(xyz=位置,z=0))\n其它类型灯:\t(xyz=位置,z=1)");
            ShaderReferenceUtil.DrawOneContent ("unity_WorldToLight", "从世界空间转换到灯光空间下，等同于旧版的_LightMatrix0.");
            //ShaderReferenceUtil.DrawOneContent("unity_4LightPosX0,unity_4LightPosY0,unity_4LightPosZ0", "");
            //ShaderReferenceUtil.DrawOneContent("unity_4LightAtten0", "");
            //ShaderReferenceUtil.DrawOneContent("unity_LightColor", "");
            //ShaderReferenceUtil.DrawOneContent("unity_WorldToShadow", ""); 

            ShaderReferenceUtil.DrawTitle ("Fog and Ambient");
            ShaderReferenceUtil.DrawOneContent ("unity_AmbientSky", "环境光（Gradient）中的Sky Color.");
            ShaderReferenceUtil.DrawOneContent ("unity_AmbientEquator", "环境光（Gradient）中的Equator Color.");
            ShaderReferenceUtil.DrawOneContent ("unity_AmbientGround", "环境光（Gradient）中的Ground Color.");
            ShaderReferenceUtil.DrawOneContent ("UNITY_LIGHTMODEL_AMBIENT", "环境光(Color)中的颜色，等同于环境光（Gradient）中的Sky Color.");
            //ShaderReferenceUtil.DrawOneContent("unity_FogColor", "");
            //ShaderReferenceUtil.DrawOneContent("unity_FogParams", "");

            //ShaderReferenceUtil.DrawTitle("Various");
            //ShaderReferenceUtil.DrawOneContent("unity_LODFade", "");
            //ShaderReferenceUtil.DrawOneContent("_TextureSampleAdd", "");

            ShaderReferenceUtil.DrawTitle ("GPU Instancing");
            ShaderReferenceUtil.DrawOneContent ("实现步骤", "用于对多个对象(网格一样，材质一样，但是材质属性不一样)合批,单个合批最大上限为511个对象.\n" +
                "1.#pragma multi_compile_instancing 添加此指令后会使材质面板上曝露Instaning开关,同时会生成相应的Instancing变体\n" +
                "2.UNITY_VERTEX_INPUT_INSTANCE_ID 在顶点着色器的输入(appdata)和输出(v2f,可选项)中添加\n" +
                "3.UNITY_INSTANCING_BUFFER_START(arrayName) / UNITY_INSTANCING_BUFFER_END(arrayName) 将每个你需要实例化的属性都封装在这个常量寄存器中\n" +
                "4.UNITY_DEFINE_INSTANCED_PROP(type, name) 在上面的START和END间把需要的每条属性加进来\n" +
                "5.UNITY_SETUP_INSTANCE_ID(v); 需放在顶点着色器/片断着色器(可选)中最开始的地方,这样才能访问到全局的unity_InstanceID\n" +
                "6.UNITY_TRANSFER_INSTANCE_ID(v, o); 当需要将实例化ID传到片断着色器时,在顶点着色器中添加\n" +
                "7.UNITY_ACCESS_INSTANCED_PROP(arrayName, propName) 在片断着色器中访问具体的实例化变量\n");
            ShaderReferenceUtil.DrawOneContent ("Instancing选项", "对GPU Instancing进行一些设置\n" +
                "• #pragma instancing_options forcemaxcount:batchSize 强制设置单个批次内Instancing的最大数量,最大值和默认值是500\n" +
                "• #pragma instancing_options maxcount:batchSize 设置单个批次内Instancing的最大数量,仅Vulkan, Xbox One和Switch有效");

            EditorGUILayout.EndScrollView ();
        }
    }
}
#endif