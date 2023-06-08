using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SceneLoader : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        var myGem = GameObject.FindGameObjectWithTag("MyGem").GetComponent<Gem>();
        var mySceptre = GameObject.FindGameObjectWithTag("MySceptre").GetComponent<Sceptre>();
        mySceptre.AttachGem(myGem);
    }

    // Update is called once per frame
    void Update()
    {
    }
}
