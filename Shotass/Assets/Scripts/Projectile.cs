using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projectile: MonoBehaviour
{
    [SerializeField]
    private double _speed = 0.01;
    public GameObject fxImpact;

    private double _damage = 10; // Default damage
    private Player _player;
    
    //To Help compute impact direction
    private Vector3 previousPosition; 
    private Vector3 currentPosition;
    
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //Each 5 frame
        if (Time.frameCount % 5 == 0)
        {
            previousPosition = currentPosition;
            currentPosition = transform.position;
        }
        
    }
    
    public void SetDamage(double damage)
    {
        _damage = damage;
    }

    public void SetPlayer(Player player)
    {
        _player = player;
    }
    
    public void SetSpeed(double speed)
    {
        _speed = speed;
    }

    // ON collision
    private void OnCollisionEnter(Collision other)
    {
        // Get the enemy
        var target = other.gameObject.GetComponentInParent<Target>();
        // If enemy is not null
        if (target != null)
        {
            if (_player is not null && Play.IsAlliedTarget(target, _player))
            {
                VRDebug.Log("Projectile hit allied target");
                Destroy(this.gameObject);
                return;
            }
            VRDebug.Log("Projectile hit target");
            // Call enemy take damage
            target.TakeDamage(_damage);
            if (target.IsDead())
            {
                // Set continuous collision detection
                target.gameObject.AddComponent<Rigidbody>();
                target.gameObject.GetComponent<Rigidbody>().collisionDetectionMode = CollisionDetectionMode.Continuous;
                // Get projectile direction
                Vector3 currentDirection = (currentPosition-previousPosition).normalized;
                // Give projectile force to target
                target.gameObject.GetComponent<Rigidbody>().AddForce(currentDirection * (float)_speed, ForceMode.Impulse);
            }
        }
        else
        {
            var terrainFire = Instantiate(fxImpact, transform.position, Quaternion.identity);
            Destroy(terrainFire, 5);
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