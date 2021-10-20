using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoverButton : MonoBehaviour
{
    public RectTransform button;
    public float posXEnter;
    public float posXExit;
    public float posYEnter;
    public float posYExit;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    public void OnMouseOver()
    {
        button.anchoredPosition = new Vector3(posXEnter, posYEnter, 0);
    }

    public void OnMouseExit()
    {
        button.anchoredPosition = new Vector3(posXExit, posYExit, 0);
    }
}
