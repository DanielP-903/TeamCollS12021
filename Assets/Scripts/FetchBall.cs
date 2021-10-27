using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FetchBall : MonoBehaviour
{
    public float speed = 10;
    public bool canHold = true;
    public bool isCompleted;
    public GameObject ball;
    public Transform guide;

    void Update()
    {
        if(!canHold && ball)
            ball.transform.position = guide.position;

    }//update

    //We can use trigger or Collision
    void OnTriggerEnter(Collider col)
    {
        if (col.gameObject.tag == "Interactable")
        {
 
            
            Pickup();
        }
    }

    //We can use trigger or Collision
    void OnTriggerExit(Collider col)
    {
        if (col.gameObject.tag == "Interactable")
        {
           
        }
    }


    private void Pickup()
    {
        if (!ball)
            return;
        ball.transform.SetParent(guide);
        //Set gravity to false while holding it
        ball.GetComponent<Rigidbody>().useGravity = false;

        //we apply the same rotation our main object (Camera) has.
        ball.transform.localRotation = transform.rotation;
        //We re-position the ball on our guide object 
        ball.transform.position = guide.position;

        canHold = false;
        StartCoroutine(throwing());
    }
    
    IEnumerator throwing()
    {
        yield return new WaitForSeconds(5f);
        throw_drop();
        yield return new WaitForSeconds(5f);
       // ball = GameObject.Find("Ball");
        isCompleted = true;
    }

    private void throw_drop()
    {
        if (!ball)
            return;

        //Set our Gravity to true again.
        ball.GetComponent<Rigidbody>().useGravity = true;
        // we don't have anything to do with our ball field anymore
        ball = null;
        //Apply velocity on throwing
        guide.GetChild(0).gameObject.GetComponent<Rigidbody>().velocity = transform.forward * speed;
        guide.GetChild(0).SetParent(null);

        canHold = true;
    }
}
