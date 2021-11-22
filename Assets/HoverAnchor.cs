using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HoverAnchor : MonoBehaviour
{
    [SerializeField]
    internal GameObject holdanchor;
    // Start is called before the first frame update
    void Start()
    {
        holdanchor.SetActive(false);
    }

    public void OnMouseOver()
    {
        holdanchor.SetActive(true);
    }

    public void OnMouseExit()
    {
        holdanchor.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
