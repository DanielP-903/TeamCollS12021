using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameOverLerp : MonoBehaviour
{
    private MainMenuCamera mainMenuCamera;
    public bool isactive;
    public bool isactive2;
    // Start is called before the first frame update

    void Start()
    {
        StartCoroutine(GameMove());
    }

    IEnumerator GameMove()
    {

        yield return new WaitForSeconds(15f);
        mainMenuCamera = Camera.main.GetComponent<MainMenuCamera>();
        isactive = true;
        mainMenuCamera.ChangePosition(1);
        yield return new WaitForSeconds(5f);
        isactive = false;
        yield return new WaitForSeconds(15f);
        isactive2 = true;
        Debug.Log("started");
        mainMenuCamera.ChangePosition(0);
        yield return new WaitForSeconds(5f);
        isactive2 = false;
    }


    // Update is called once per frame
    void Update()
    {
        if(isactive)
        {
            mainMenuCamera.MoveToPosition();
        }
        if (isactive2)
        {
            mainMenuCamera.MoveToPosition();
        }

    }
}
