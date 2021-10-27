using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class AIDog : MonoBehaviour
{

    public Transform[] points;
    public float duration= 5f;
    private int destinationpoint = 0;
    public float waitTimer;
    private NavMeshAgent agent;
    public Animator anim;

    void Start()
    {
        //other line of codes....


        agent = GetComponent<NavMeshAgent>();
    //    agent.autoBraking = false;
        GotoNextPoint();
    }

    void GotoNextPoint()
    {
        if (points.Length == 0)
            return;

        agent.destination = points[destinationpoint].position;
        destinationpoint = (destinationpoint + 1) % points.Length;
    }

    void Update()
    {
        if (!agent.pathPending && agent.remainingDistance < agent.stoppingDistance * 1.1f) // or keep < 0.5f if you want
        {
            anim.SetBool("isDone", false);
            waitTimer += Time.deltaTime;
            if (waitTimer > duration)
            {
                anim.SetBool("isDone", true);
                waitTimer = 0;
                GotoNextPoint();
            }
        }
    }
}
      