using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Meteor : MonoBehaviour
{
    public float rotationSpeedY = 10f;
    public float rotationSpeedX = 10f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    void Update()
    {
        // Récupère la rotation actuelle du GameObject
        Quaternion currentRotation = transform.rotation;

        // Ajoute une rotation supplémentaire autour de l'axe Y
        Quaternion newRotation = Quaternion.Euler(rotationSpeedX * Time.deltaTime, rotationSpeedY * Time.deltaTime, 0) * currentRotation;

        // Applique la nouvelle rotation au GameObject
        transform.rotation = newRotation;
    }
}
