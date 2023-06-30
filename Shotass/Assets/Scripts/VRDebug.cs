using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.XR;
using UnityEngine.XR.Interaction.Toolkit;

public class VRDebug : MonoBehaviour
{
    public enum DisplayMode
    {
        Foreground,
        Background,
        None
    }
    static VRDebug _instance = null;
    private static DisplayMode _displayMode = DisplayMode.None;

    
    public GameObject _textOutputGameObjectContainer;
    public GameObject _textOutputGameObjectOutBoundsContainer;
    
    public GameObject _textOutputGameObject;
    public GameObject _textOutputGameObjectOutBounds;
    
    public TextMeshProUGUI _textOutput;
    public TextMeshProUGUI _textOutputOutBounds;
    
    public GameObject controllerGameObject;
    public ActionBasedController controller;
    
    
    void Start()
    {
        if (_textOutputGameObject == null)
        {
            VRDebug.Log("[VRDebug]: Can not start without a TextMesh GameObject");
            return;
        }

        if (_instance != null)
        {
            Debug.Log("[VRDebug]: There are more than one VRDebug instances in this scene");
            return;
        }
        try
        {
            _textOutput = _textOutputGameObject.GetComponent<TextMeshProUGUI>();
            _textOutputOutBounds = _textOutputGameObjectOutBounds.GetComponent<TextMeshProUGUI>();
            VRDebug._instance = this;
            controller = controllerGameObject.GetComponent<ActionBasedController>(); 
            
            VRDebug.Log("[VRDebug]: Is XR controller Game Object null : " + (controllerGameObject == null ? "yes" : "no"));
            VRDebug.Log("[VRDebug]: Is XR controller null : " + (controller == null ? "yes" : "no"));
            VRDebug.Log("[VRDebug]: Started");
            controller.selectAction.action.performed += ctx => OnInputSelectPress();
            NextDisplayMode();
            NextDisplayMode();
        } catch (Exception e)
        {
            Debug.Log("Error: " + e);
        }
    }

    public void OnInputSelectPress()
    {
        VRDebug.Log("[VRDebug] : You pressed on Select action");
        NextDisplayMode();
    }

    public void DisplayLog(string text)
    {
        if (_textOutputGameObjectContainer.active)
        {
            _textOutput.text += text + "\n";
            KeepTrackingBottom(_textOutput);
        }

        if (_textOutputGameObjectOutBoundsContainer)
        {
            _textOutputOutBounds.text += text + "\n";
            KeepTrackingBottom(_textOutputOutBounds);
        }
    }

    public static void NextDisplayMode()
    {
        
        if (_displayMode == DisplayMode.None)
        {
            _displayMode = DisplayMode.Foreground;
            _instance._textOutputGameObjectContainer.SetActive(true);
            _instance._textOutputGameObjectOutBoundsContainer.SetActive(false);
        } else if (_displayMode == DisplayMode.Foreground)
        {
            _displayMode = DisplayMode.Background;
            _instance._textOutputGameObjectContainer.SetActive(false);
            _instance._textOutputGameObjectOutBoundsContainer.SetActive(true);
        } else if (_displayMode == DisplayMode.Background)
        {
            _displayMode = DisplayMode.None;
            _instance._textOutputGameObjectContainer.SetActive(false);
            _instance._textOutputGameObjectOutBoundsContainer.SetActive(false);
        }

        VRDebug.Log("[VRDebug] : " + _displayMode.ToString());
    }

    private void KeepTrackingBottom(TextMeshProUGUI textMeshPro)
    {
        //if(textMeshPro == _textOutput && _textOutputGameObjectContainer.active == false)
        //    return;
        //if(textMeshPro == _textOutputOutBounds && _textOutputGameObjectOutBoundsContainer.active == false)
        //    return;
        
        if (textMeshPro.overflowMode == TextOverflowModes.Overflow)
        {
            RectTransform rectTransform = textMeshPro.rectTransform;
            float textHeight = rectTransform.rect.height;
            float contentHeight = textMeshPro.preferredHeight;

            if (contentHeight > textHeight)
            {
                float overflowAmount = contentHeight - textHeight;
                Vector3 currentPosition = rectTransform.localPosition;
                Vector3 targetPosition;
                //if (textMeshPro == _textOutput)
                //{
                //    targetPosition = new Vector3(currentPosition.x, overflowAmount, currentPosition.z);
                //    rectTransform.localPosition = targetPosition;
                //}
                //else if (textMeshPro == _textOutputOutBounds)
                //{
                //    targetPosition = new Vector3(-overflowAmount, currentPosition.y, currentPosition.z);
                //    rectTransform.localPosition = targetPosition;
                //}
                targetPosition = new Vector3(currentPosition.x, overflowAmount, currentPosition.z);
                rectTransform.localPosition = targetPosition;
            }
            else
            {
                // Reset position if content height is smaller than text height
                rectTransform.localPosition = Vector3.zero;
            }
        }
    }
    
    static public void Log(string message)
    {
        Debug.Log(message);
        if (VRDebug._instance != null)
        {
            VRDebug._instance.DisplayLog(message);
        }
    }
    
    static public void Log(float number)
    {
        VRDebug.Log(number.ToString());
    }
}