using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectile: MonoBehaviour
{
    [SerializeField]
    private double _speed = 0.01;

    private double _damage = 10;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
    public void SetDamage(double damage)
    {
        VRDebug.Log($"Projectile damage: {damage}");
        _damage = damage;
    }
    
    public void SetSpeed(double speed)
    {
        VRDebug.Log($"Projectile speed: {speed}");
        _speed = speed;
    }
    
    public void Launch()
    {
        VRDebug.Log("Projectile launched");
        //Get gameobject
        var rigidbody = GetComponent<Rigidbody>();
        rigidbody.AddForce(transform.forward * (float)_speed, ForceMode.Impulse);
    }
    
    // ON collision
    private void OnCollisionEnter(Collision other)
    {
        VRDebug.Log("Projectile collided");
        // Get the enemy
        var target = other.gameObject.GetComponentInParent<Target>();
        // If enemy is not null
        if (target != null)
        {
            // Call enemy take damage
            target.TakeDamage(_damage);
        }
        //Destroy the projectile
        Destroy(this.gameObject);
    }

    public void Launch(Transform origin)
    {
        this.transform.position = origin.position;
        this.GetComponent<Rigidbody>().velocity = origin.forward * (float)_speed;
        Destroy(this, 60);
    }
    
    
}