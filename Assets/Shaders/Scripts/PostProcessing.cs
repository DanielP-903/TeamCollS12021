using System;
using UnityEngine;

[ExecuteInEditMode]
public class PostProcessing : MonoBehaviour
{
	[SerializeField]
	private Material PostProcessMat;
	private void Awake()
	{
		if( PostProcessMat == null )
		{
			enabled = false;
		}
		else
		{
			// This is on purpose ... it prevents the know bug
			// https://issuetracker.unity3d.com/issues/calling-graphics-dot-blit-destination-null-crashes-the-editor
			// from happening
			PostProcessMat.mainTexture = PostProcessMat.mainTexture;
		}
	}

	private void Start()
	{
		Camera cam = GetComponent<Camera>();
		cam.depthTextureMode |= DepthTextureMode.DepthNormals;
	}

	void OnRenderImage( RenderTexture src, RenderTexture dest )
	{
		Graphics.Blit( src, dest, PostProcessMat );
	}
}
