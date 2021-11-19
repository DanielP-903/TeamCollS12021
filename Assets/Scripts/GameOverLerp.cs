using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameOverLerp : MonoBehaviour
{
    private MainMenuCamera mainMenuCamera;
    public bool isactive;
    // Start is called before the first frame update

    void Start()
    {
        StartCoroutine(GameMove());
    }

    IEnumerator GameMove()
    {

        yield return new WaitForSeconds(10f);
        mainMenuCamera = Camera.main.GetComponent<MainMenuCamera>();
        isactive = true;
        mainMenuCamera.ChangePosition(1);
    }

    // Update is called once per frame
    void Update()
    {
        if(isactive)
        {
            mainMenuCamera.MoveToPosition();
        }
        
    }
}
