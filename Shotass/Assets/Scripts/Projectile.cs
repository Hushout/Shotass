using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectile: MonoBehaviour
{
    [SerializeField]
    private double _speed = 10;

    private double _damage;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    
    public void SetDamage(double damage)
    {
        Debug.Log($"Projectile damage: {damage}");
        _damage = damage;
    }
    
    public void SetSpeed(double speed)
    {
        Debug.Log($"Projectile speed: {speed}");
        _speed = speed;
    }
    
    public void Launch()
    {
        Debug.Log("Projectile launched");
        //Get gameobject
        var rigidbody = GetComponent<Rigidbody>();
        rigidbody.AddForce(transform.forward * (float)_speed, ForceMode.Impulse);
    }
    
    // ON collision
    private void OnCollisionEnter(Collision other)
    {
        Debug.Log("Projectile collided");
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
    
    
}