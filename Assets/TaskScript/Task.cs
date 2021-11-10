using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class Task : MonoBehaviour
{
  
    public string description;
    private string symbol = "/";

    [SerializeField] internal GameObject m_uiObjectRef;

    internal GameObject descriptionText;
    internal GameObject currentamountText;
    internal GameObject symbolText;
    internal GameObject requiredamountText;

    // public Animator anim;
   // public GameObject ScratchEffect;


    void Start()
    {
        
        descriptionText = m_uiObjectRef.transform.GetChild(0).gameObject;
        currentamountText = m_uiObjectRef.transform.GetChild(1).gameObject;
        symbolText = m_uiObjectRef.transform.GetChild(2).gameObject;
        requiredamountText = m_uiObjectRef.transform.GetChild(3).gameObject;
        descriptionText.GetComponent<Text>().text = description;
        currentamountText.GetComponent<Text>().text = currentAmount.ToString();
        requiredamountText.GetComponent<Text>().text = requiredAmount.ToString();
        symbolText.GetComponent<Text>().text = symbol;
        //ScratchEffect.SetActive(false);
    }

    public enum TaskStatus
    {
        Open, Closed
    }
    public TaskStatus CurrentStatus;

    public int currentAmount;
    public int requiredAmount;

    public bool isReached()
    {
        return (currentAmount >= requiredAmount);
    }

    public void ItemsCollected()
    {
        currentAmount+=1;
        currentamountText.GetComponent<Text>().text = currentAmount.ToString();
    }


    public void ItemsDisposed()
    {
        currentAmount-=1;
        currentamountText.GetComponent<Text>().text = currentAmount.ToString();
    }
    public void TaskCompleted()
    {
        CurrentStatus = TaskStatus.Closed;
        StartCoroutine(Checkmark());
    }

    IEnumerator Checkmark()
    {
        //anim.SetBool("isChecked", true);
     //   ScratchEffect.SetActive(true);
        yield return new WaitForSeconds(3f);
      //  Destroy(this);
    }
}
