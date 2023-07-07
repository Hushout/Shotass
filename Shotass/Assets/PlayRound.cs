using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PlayRound : MonoBehaviour
{
    public Target[] Player1Targets;
    public Target[] Player2Targets;

    public GameObject meteor;
    
    // Start is called before the first frame update
    void Start()
    {
        // on Target Die
        foreach (var target in Player1Targets)
        {
            target.OnDie += () =>
            {
                Debug.Log("Player 1 Target Died");
                if(CheckGameOverByPlayTargets(Player1Targets))
                {
                    EndRound();
                }

            };
        }
        
        foreach (var target in Player2Targets)
        {
            target.OnDie += () =>
            {
                Debug.Log("Player 2 Target Died");
                if(CheckGameOverByPlayTargets(Player1Targets))
                {
                    EndRound();
                }
            };
        }
    }
    
    
    public bool CheckGameOverByPlayTargets(Target[] targets)
    {
        foreach (var target in targets)
        {
            if (target != null && target.IsDead() == false)
            {
                return false;       
            }
        }
        return true;
    }
    
    public void EndRound()
    {
        meteor.SetActive(true);
        //Wait 10 seconds
        StartCoroutine(WaitAndReload(13f));
        //Reload Scene
        //SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }
    
    //WaitAndReload
    IEnumerator WaitAndReload(float waitTime)
    {
        yield return new WaitForSeconds(waitTime);
        SceneManager.LoadScene(SceneManager.GetActiveScene().name);
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
