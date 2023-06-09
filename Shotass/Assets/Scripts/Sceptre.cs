using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Sceptre : Weapon
{
    [SerializeField]
    private Transform _projectileOrigin;
    private GameObject _projectilePrefab;



    // Start is called before the first frame update
    void Start()
    {
        _projectilePrefab = Resources.Load<GameObject>("Models/Projectile");
    }
    // Update is called once per frame
    void FixedUpdate()
    {
        // Each 5 seconds
        if (Time.frameCount % 300 == 0)
        {
            CastSpell();
        }
    }

    public GameObject CreateProjectile()
    {
        var projectileGameObject = Instantiate(_projectilePrefab, _projectileOrigin.position, _projectileOrigin.rotation);
        var projectile = projectileGameObject.GetComponent<Projectile>();
        projectileGameObject.transform.SetParent(this.transform);
        projectile.SetDamage(_damage);
        return projectileGameObject;
    }
    
    public void CastSpell()
    {
        var projectile = CreateProjectile().GetComponent<Projectile>();
        projectile.Launch();
    }

}
